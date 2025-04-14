return {
  "vimwiki/vimwiki",
  lazy = false,
  init = function()
    local home = os.getenv("HOME") or os.getenv("USERPROFILE") or "C:/Users/Default"
    vim.g.vimwiki_list = {
      {
        path = home .. "/vimwiki/",
        syntax = "markdown",
        ext = ".md",
        diary_rel_path = "diary/",
        diary_index = "index",
        auto_diary_index = 1,
      },
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_diary_header = "# %s\n\n---\n\n## 📝 Today’s Notes\n\n"
    vim.g.vimwiki_diary_header_format = "%Y-%m-%d"
  end,
  config = function()
    vim.keymap.set("n", "<leader>wt", "<cmd>VimwikiTabMakeDiaryNote<CR>", { desc = "Open Today’s Diary in New Tab" })
  end,
}
