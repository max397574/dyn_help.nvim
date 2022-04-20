local dyn_help = {}
local utils = require("dynamic_help.utils")
local log = require("dynamic_help.log")

function dyn_help.float_help(tag_name)
    local tag_lines = utils.get_help_tag_lines(tag_name)
    if vim.tbl_isempty(tag_lines) then
        log.warn("No help found for this tag")
        return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, tag_lines)
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    -- dump(tag_lines)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = math.floor(width * 0.9),
        height = (#tag_lines <= (height * 0.9)) and #tag_lines or math.floor(
            height * 0.9
        ),
        col = math.floor(width * 0.05),
        row = math.floor(height * 0.05),
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_win_set_option(win, "winblend", 20)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "help")
    local ns = vim.api.nvim_create_namespace("dyn_help")
    vim.api.nvim_buf_add_highlight(buf, ns, "Special", 0, 0, -1)
    local value = utils.get_option_value(tag_name)
    local default = utils.get_default_option_value(tag_name)
    if value ~= "" then
        vim.api.nvim_buf_add_highlight(buf, ns, "Keyword", 2, 0, -1)
    end
    if default ~= "" then
        vim.api.nvim_buf_add_highlight(buf, ns, "Special", 3, 0, -1)
    end
end

return dyn_help
