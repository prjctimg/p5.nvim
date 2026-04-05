-- Dependency management module for p5.nvim
local L = {}

L.require = function(plugin_name)
	local ok, plugin = pcall(require, plugin_name)
	if ok then
		return plugin
	end
	return nil
end

return L
