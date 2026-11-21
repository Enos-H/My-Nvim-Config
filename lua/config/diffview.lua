local ok_diffview, diffview = pcall(require, "diffview")
if not ok_diffview then return end

diffview.setup({
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
      disable_diagnostics = true,
    },
  },
})

