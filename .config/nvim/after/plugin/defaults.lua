
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fencs = { 'cp949', 'utf-8', 'ucs-bom' }

vim.opt.shell = 'fish'
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.breakindent = true


vim.keymap.set('n', 'x', '"_x')

-- Increment/decrement
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
vim.keymap.set('n', 'te', ':tabedit')

-- Split window
vim.keymap.set('n', 'ss', ':split<Return><C-w>w')
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w')

-- Move window
vim.keymap.set('n', '<Space>', '<C-w>w')
vim.keymap.set('', 'sh', '<C-w>h')
vim.keymap.set('', 'sk', '<C-w>k')
vim.keymap.set('', 'sj', '<C-w>j')
vim.keymap.set('', 'sl', '<C-w>l')

-- Resize window
vim.keymap.set('n', '<C-w><left>', '<C-w><')
vim.keymap.set('n', '<C-w><right>', '<C-w>>')
vim.keymap.set('n', '<C-w><up>', '<C-w>+')
vim.keymap.set('n', '<C-w><down>', '<C-w>-')

vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
