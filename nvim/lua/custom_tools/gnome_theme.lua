function Detect_gnome_theme()
    local result = vim.fn.system('gsettings get org.gnome.desktop.interface color-scheme')
    return result:match('dark') ~= nil
end

-- TODO: check if the themes are installed, if not, use internal black/light themes
local background = 'koda'
if Detect_gnome_theme() then
    local background = 'venom'
end

return {
    background = background,
}
