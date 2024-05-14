return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
            },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["phpactor"] = function ()
                    local lspconfig = require("lspconfig")
                    lspconfig.phpactor.setup({
                        cmd = {'phpactor', 'language-server', '-vvv'},
                        filetypes = {'php'},
                        root_dir = function()
                            return vim.fn.expand('%:p:h')
                        end,
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["emmet_ls"] = function ()
                    local lspconfig = require("lspconfig")
                    lspconfig.emmet_ls.setup({
                        filetypes = {"html","php","smarty"}
                    })
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<S-tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Enter>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources(
                {
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lsp_signature_help'},
                    {name = 'nvim_lua'},
                    {name = 'luasnip'},
                    {name = 'buffer'},
                    --{name = 'luasnip', keyword_length = 2},
                    --{name = 'buffer', keyword_length = 3},
                },
                {
                    { name = 'buffer' },
                }
            ),
            formatting = {
                    -- changing the order of fields so the icon is the first
                    fields = {'menu', 'abbr', 'kind'},

                    -- here is where the change happens
                    format = function(entry, item)
                        local menu_icon = {
                            nvim_lsp = 'λ',
                            luasnip = '⋗',
                            buffer = 'Ω',
                            path = '🖫',
                            nvim_lua = 'Π',
                        }

                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },

        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
