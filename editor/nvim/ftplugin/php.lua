-- Check if config exists, copy template if not
local function ensure_php_cs_fixer_config()
	local root = vim.fs.root(0, { ".git", "composer.json" }) or vim.fn.getcwd()
	local config_file = root .. "/.php-cs-fixer.dist.php"

	if vim.fn.filereadable(config_file) == 0 then
		local templates_dir = vim.fn.getenv("CONFIG_DIR")
		if templates_dir == vim.NIL or templates_dir == "" then
			vim.notify("CONFIG_DIR environment variable not set", vim.log.levels.WARN)
			return
		end

		local template = templates_dir .. "/templates/misc/.php-cs-fixer.dist.php"
		if vim.fn.filereadable(template) == 1 then
			vim.fn.system(string.format("cp %s %s", vim.fn.shellescape(template), vim.fn.shellescape(config_file)))
			vim.notify("Copied PHP-CS-Fixer config from template", vim.log.levels.INFO)
		else
			vim.notify("Template file not found: " .. template, vim.log.levels.WARN)
		end
	end
end

-- Run on buffer enter
ensure_php_cs_fixer_config()
