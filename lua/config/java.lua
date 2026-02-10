local ok_jdtls, jdtls = pcall(require, 'jdtls')
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

if ok_jdtls and ok_cmp_nvim_lsp then

  -- Define arquivos que indicam se o diretório é raiz de um projeto Java
  -- Caso não encontre, retorna.
  -- Isso impede que o servidor JDTLS seja iniciado em diretórios que não são projetos Java.
  local root_markers = {'.git', 'mvnw', 'pom.xml', 'gradlew', 'build.gradle'}
  local root_dir = jdtls.setup.find_root(root_markers)
  if not root_dir then return end 

  -- Define o diretório de trabalho do JDTLS e as capacidades do lsp
  -- O diretório de trabalho é necessário para que o JDTLS possa armazenar informações específicas do projeto, como configurações e cache.
  -- As capacidades do lsp são necessárias para que o JDTLS possa se comunicar corretamente com o Neovim e fornecer recursos como autocompletar, ir para definição, etc.
  -- O caminho para o JDTLS e o workspace são definidos com base no diretório do usuário e no diretório raiz do projeto.
  -- O JDTLS é instalado via Mason, então o caminho é definido com base no diretório do Mason e no nome do pacote do JDTLS.
  -- O workspace é definido com base no diretório do cache do usuário e no nome do projeto, que é extraído do diretório raiz.
  local home = os.getenv('HOME')
  local capabilities = cmp_nvim_lsp.default_capabilities()
  local jdtls_dir = home .. '/.local/share/nvim/mason/packages/jdtls'
  local workspace_dir = home .. '/.cache/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':t')

  -- Configura o JDTLS com as opções necessárias para o funcionamento correto do servidor, como o comando para iniciar o servidor, as configurações específicas do Java, etc.
  local config = {
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundlesStartupLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-javaagent:' .. jdtls_dir .. '/lombok.jar',
      '-Xmx1G',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', vim.fn.glob(jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', jdtls_dir .. '/config_linux',
      '-data', workspace_dir,
    },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-23',
              path = home .. '/.jdks/temurin-23.0.2',
              default = true,
            }
          },
          updateBuildConfiguration = 'automatic',
          extendedClientAttributes = 'generate',
          annotationProcessing = {
            enabled = true,
            profile = "default",
            enabledByDefault = true,
          },
        },
        maven = {
          downloadSources = true
        },
        lombokAnnotations = true,
        processors = {
          "lombok.launch.AnnotationProcessorHider$AnnotationProcessor",
          "org.projectlombok.process.pta.Processor"
        },
        references = {
          includeDecompiledSources = true,
        },
        contentProvider = {
          preferred = 'fernflower'
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.springframework.test.util.ReflectionTestUtils.*"
          }
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },

      },
    },
    init_options = {
      bundles = {}
    },
    -- Configurações para lidar com o ciclo de vida do servidor, como iniciar, parar, etc.
    -- O on_attach é usado para configurar o DAP (Debug Adapter Protocol) para o JDTLS, permitindo que o usuário possa depurar código Java diretamente do Neovim.
    -- O on_exit é usado para garantir que o processo do JDTLS seja encerrado
    -- O on_init é usado para garantir que o processo do JDTLS seja encerrado caso o servidor já esteja em execução, evitando conflitos entre múltiplas instâncias do JDTLS.
    on_attach = function(client, bufnr)
      jdtls.setup_dap({ hotcodereplace = 'auto' })
    end,
    on_exit = function(code)
      vim.cmd('silent !pkill -f "jdtls.*' .. root_dir .. '" || true')
      vim.notify("JDTLS terminado", vim.log.levels.INFO)
    end,
    on_init = function(client)
      vim.cmd('silent !pkill -f "jdtls.*' .. root_dir .. '" || true')
    end,
  }

  -- Configura um autocmd para garantir que o processo do JDTLS seja encerrado quando o buffer for fechado, evitando que o processo fique em execução em segundo plano e consuma recursos desnecessariamente.
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      vim.schedule(function()
        if vim.lsp.get_clients({name = "jdtls"})[1] then
          vim.lsp.stop_client(vim.lsp.get_clients({name = "jdtls"})[1].id)
        end
      end)
    end,
  })

  jdtls.start_or_attach(config)

end

