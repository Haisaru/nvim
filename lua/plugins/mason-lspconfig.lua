--[[
To install a language server use :Mason
To intsall a null-ls source, write it into null-ls.lua and install in :Mason
--]]

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					check_outdated_packages_on_open = true,
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "jsonls" },
				automatic_installation = true,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							on_attach = function(client, bufnr)
								if client.supports_method("textDocument/formatting") then
									vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
									vim.api.nvim_create_autocmd("BufWritePre", {
										group = augroup,
										buffer = bufnr,
										callback = function()
											vim.lsp.buf.format()
										end,
									})
								end
							end,
							capabilities = capabilities,
						})
					end,
					["lua_ls"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup({
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" },
									},
								},
							},
							on_attach = function(client, bufnr)
								if client.supports_method("textDocument/formatting") then
									vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
									vim.api.nvim_create_autocmd("BufWritePre", {
										group = augroup,
										buffer = bufnr,
										callback = function()
											vim.lsp.buf.format()
										end,
									})
								end
							end,
						})
					end,
					["clangd"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.clangd.setup({
							capabilities = { offsetEncoding = { "utf-16" } },
							cmd = { "clangd", "--offset-encoding=utf-16" },
							on_attach = function(client, bufnr)
								if client.supports_method("textDocument/formatting") then
									vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
									vim.api.nvim_create_autocmd("BufWritePre", {
										group = augroup,
										buffer = bufnr,
										callback = function()
											vim.lsp.buf.format()
										end,
									})
								end
							end,
						})
					end,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("<leader>gf", vim.lsp.buf.format, "[G]o [F]ormat")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
		end,
	},
}
