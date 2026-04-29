return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "yamlls" }
      })
    end
  },

  {
    "neovim/nvim-lspconfig", -- still required, but no longer used directly
    config = function()
      -- use the new native API
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            validate = true,
            format = { enable = true },
            hover = true,
            completion = true,
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
              ["https://json.schemastore.org/kubernetes.json"] = "*.k8s.yaml",
            },
          }
        }
      })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end
  }
}

