local statusline = {}
local utils = require("dynamic_help.utils")
local help_tags = utils.help_tags()

local tag_names = {}
for _, tag in ipairs(help_tags) do
    table.insert(tag_names, tag.name)
end

--- Checks if there is a helpfile available for word under cursor
---@return string symbol Empty string if not available
statusline.available = function()
    local tag_name = vim.fn.expand("<cword>")
    if tag_name == "" then
        return ""
    end

    for _, tag in ipairs(tag_names) do
        if
            tag == tag_name
            or tag == "'" .. tag_name .. "'"
            or tag == tag_name .. "()"
        then
            return " "
        end
    end
    return ""
end

--- Gets the value of option under the cursor
---@return string value Empty string if no valid option
statusline.value = function()
    return utils.get_option_value(vim.fn.expand("<cword>"))
end

return statusline
