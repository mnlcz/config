require("vis")

vis.events.subscribe(vis.events.INIT, function()
	vis:command("set theme acme")

	-- Indenting (global defaults)
	vis:command("set expandtab")
	vis:command("set tabwidth 4")

	-- Search
	vis:command("set ignorecase")

end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Line numbers
	vis:command("set number")
	vis:command("set relativenumbers")

	-- Wrap
	vis:command("set nowrap")

	-- Per-filetype indentation (2 spaces for web/config files)
	local ft = win.syntax
	if ft == "lua" or ft == "html" or ft == "javascript" or ft == "css" then
		vis:command("set tabwidth 2")
	end
end)
