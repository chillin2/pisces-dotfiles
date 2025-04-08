return {
  "vimwiki/vimwiki",
  lazy = false,
  init = function()
    vim.g.vimwiki_list = {
      {
        path = os.getenv("HOME") .. "/vimwiki/",
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
    vim.g.mapleader = "\\"
  end,
  config = function()
    -- 👇 다이어리 단축키 등록
    vim.keymap.set("n", "<leader>wt", "<cmd>VimwikiTabMakeDiaryNote<CR>", { desc = "Open Today’s Diary in New Tab" })
  end,
}
