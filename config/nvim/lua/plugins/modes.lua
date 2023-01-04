return {
  "mvllow/modes.nvim",
  event = "ModeChanged",
	tag = 'v0.2.0',
	config = function()
		require('modes').setup()
	end
}
