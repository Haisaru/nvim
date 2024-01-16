require "user.luasnip.latex"
local ls_status_ok, ls = pcall(require, "luasnip")
if not ls_status_ok then
  return
end

ls.setup({enable_autosnippets = true,
  store_selection_keys = "<Tab>",})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})
