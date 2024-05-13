return {
	"nvimtools/none-ls.nvim", -- community fork of null-ls
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local formatting = null_ls.builtins.formatting
		local completion = null_ls.builtins.completion
		null_ls.setup({
			debug = false,
			sources = {
				formatting.stylua,
				formatting.black,
				completion.luasnip,
				completion.spell,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							vim.lsp.buf.format()
						end,
					})
				end
			end,
		})
	end,
}
