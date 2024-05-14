function ColorMyPencils(color)
	color = color or "sonokai"
	vim.cmd.colorscheme(color)
end

return {
    {
        "sainnhe/sonokai",
        name = "sonokai",
        config = function()
            vim.cmd("colorscheme sonokai")
            ColorMyPencils()
        end
    },
}
