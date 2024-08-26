return {
    "folke/zen-mode.nvim",
    config = function()
        local zenmode = require("zen-mode")
        vim.keymap.set("n", "<leader>zz", function()
            zenmode.setup {
                window = {
                    width = 170,
                    options = { }
                },
            }
            zenmode.toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = true
        end)


        vim.keymap.set("n", "<leader>zZ", function()
            zenmode.setup {
                window = {
                    width = 150,
                    options = { }
                },
            }
            zenmode.toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
        end)
    end
}
