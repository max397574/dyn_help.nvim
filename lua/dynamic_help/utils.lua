local utils = {}

--- Gets the value of an option
--- It's safe to use this with an invalid name
---@param option string Name of option
---@return string value The value of the option as string or empty string
function utils.get_option_value(option)
    local ok, res = pcall(vim.api.nvim_get_option_value, option, {})
    if ok then
        return tostring(res)
    else
        return ""
    end
end

return utils
