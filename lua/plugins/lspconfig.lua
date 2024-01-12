return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "pylsp" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach_common = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        --vim.keymap.set('n', '<space>wl', function()
        --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, bufopts)
        --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<Leader>s", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<space>gf", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
          vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
              vim.lsp.buf.clear_references()
              vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Highlight document",
          })
        end

        require("nvim-navic").attach(client, bufnr)
      end

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach_clangd = function(client, bufnr)
        on_attach_common(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set({ "v" }, "<Leader>gf", function()
          vim.lsp.buf.format({ async = false })
          vim.api.nvim_input("<Esc>")
        end, bufopts)
      end
      lspconfig.clangd.setup({
        on_attach = on_attach_clangd,
        filetypes = { "cpp" },
        capabilities = capabilities,
      })

      lspconfig.pylsp.setup({
        on_attach = on_attach_common,
        filetypes = { "python" },
        capabilities = capabilities,
      })

      lspconfig.lua_ls.setup({
        on_attach = on_attach_common,
        filetypes = { "lua" },
        capabilities = capabilities,
      })

      -- local on_attach_mlir = function(client, bufnr)
      -- 	-- Enable completion triggered by <c-x><c-o>
      -- 	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      --
      -- 	-- Mappings.
      -- 	-- See `:help vim.lsp.*` for documentation on any of the below functions
      -- 	local bufopts = { noremap = true, silent = true, buffer = bufnr }
      -- 	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      -- 	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
      -- end
      --
      -- vim.cmd("au BufRead,BufNewFile *.mlir set filetype=mlir")
      -- lspconfig.mlir_lsp_server.setup({
      -- 	on_attach = on_attach_mlir,
      -- 	cmd = { "/home/arames/work/nn-mlir/build/dev/bin/nn-mlir-lsp-server" },
      -- 	filetypes = { "mlir" },
      -- })

      --   local lspconfig = require("lspconfig")
      --   local capabilities = require("cmp_nvim_lsp").default_capabilities()
      --   lspconfig.lua_ls.setup({
      --     capabilities = capabilities,
      --   })
      --   lspconfig.clangd.setup({
      --     capabilities = capabilities,
      --   })
      --   -- Global mappings.
      --   -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      --   vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      --   vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      --   vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      --   vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
      --
      --   -- Use LspAttach autocommand to only map the following keys
      --   -- after the language server attaches to the current buffer
      --   vim.api.nvim_create_autocmd("LspAttach", {
      --     group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      --     callback = function(ev)
      --       -- Enable completion triggered by <c-x><c-o>
      --       vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      --
      --       -- Buffer local mappings.
      --       -- See `:help vim.lsp.*` for documentation on any of the below functions
      --       local opts = { buffer = ev.buf }
      --       vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      --       vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      --       vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      --       vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      --       vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      --       vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
      --       vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
      --       vim.keymap.set("n", "<space>wl", function()
      --         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      --       end, opts)
      --       vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
      --       vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
      --       vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
      --       vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      --       vim.keymap.set("n", "<space>f", function()
      --         vim.lsp.buf.format({ async = true })
      --       end, opts)
      --     end,
      --   })
    end,
  },
}
