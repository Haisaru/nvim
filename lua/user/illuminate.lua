local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
  vim.notify("illuminate not found")
	return
end

vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})


illuminate.configure({
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    delay = 100,
    under_cursor = true,
    large_file_cutoff = nil,
    large_file_overrides = nil,
})
