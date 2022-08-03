require("formatter").setup({
	filetype = {
		python = {
			-- Configuration for psf/black
			function()
				return {
					exe = "black", -- this should be available on your $PATH
					args = { "-" },
					stdin = true,
				}
			end,
		},
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						-- "--config-path "
						--   .. os.getenv("XDG_CONFIG_HOME")
						--   .. "/stylua/stylua.toml",
						"-",
					},
					stdin = true,
				}
			end,
		},
	},
})
