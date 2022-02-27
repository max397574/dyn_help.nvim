local dyn_help = {}
dyn_help.option_value = function()
    local ok, res = pcall(vim.api.nvim_get_option_value, vim.fn.expand("<cword>"), {})
    if ok then
        return tostring(res)
    else
        return ""
    end
end
