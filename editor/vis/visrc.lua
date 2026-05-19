require("vis")

vis.events.subscribe(vis.events.INIT, function()
	vis:command("set theme acme")

	-- Search
	vis:command("set ignorecase")

end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Indenting (global defaults)
	vis:command("set expandtab")
	vis:command("set tabwidth 4")

	-- Line numbers
	vis:command("set number")
	vis:command("set relativenumbers")

	-- Per-filetype indentation (2 spaces for web/config files)
	local ft = win.syntax
	if ft == "lua" or ft == "html" or ft == "javascript" or ft == "css" then
		vis:command("set tabwidth 2")
	end
end)
