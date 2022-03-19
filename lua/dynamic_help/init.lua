local dyn_help = {}
local Path = require("plenary.path")

--- Get the value of the option under the cursor
--- This can be used as statusline component
dyn_help.option_value = function(option)
    local ok, res = pcall(vim.api.nvim_get_option_value, option({}))
    if ok then
        return tostring(res)
    else
        return ""
    end
end

dyn_help.help_tags = function(opts)
    RELOAD("dynamic_help")
    -- code from https://github.com/nvim-telescope/telescope.nvim/blob/1d1da664eb6505c318d405eea3d633c451edc2d8/lua/telescope/builtin/internal.lua#L1
    opts = opts or {}
    opts.lang = vim.o.helplang
    opts.fallback = true
    opts.file_ignore_patterns = {}

    local langs = vim.split(opts.lang, ",", true)
    if opts.fallback and not vim.tbl_contains(langs, "en") then
        table.insert(langs, "en")
    end
    local langs_map = {}
    for _, lang in ipairs(langs) do
        langs_map[lang] = true
    end

    local tag_files = {}
    local function add_tag_file(lang, file)
        if langs_map[lang] then
            if tag_files[lang] then
                table.insert(tag_files[lang], file)
            else
                tag_files[lang] = { file }
            end
        end
    end

    local path_tail = (function()
        local os_sep = Path.path.sep
        local match_string = "[^" .. os_sep .. "]*$"

        return function(path)
            return string.match(path, match_string)
        end
    end)()

    local help_files = {}
    local all_files = vim.api.nvim_get_runtime_file("doc/*", true)
    for _, fullpath in ipairs(all_files) do
        local file = path_tail(fullpath)
        if file == "tags" then
            add_tag_file("en", fullpath)
        elseif file:match("^tags%-..$") then
            local lang = file:sub(-2)
            add_tag_file(lang, fullpath)
        else
            help_files[file] = fullpath
        end
    end

    local tags = {}
    local tags_map = {}
    local delimiter = string.char(9)
    for _, lang in ipairs(langs) do
        for _, file in ipairs(tag_files[lang] or {}) do
            local lines = vim.split(Path:new(file):read(), "\n", true)
            for _, line in ipairs(lines) do
                -- TODO: also ignore tagComment starting with ';'
                if not line:match("^!_TAG_") then
                    local fields = vim.split(line, delimiter, true)
                    if #fields == 3 and not tags_map[fields[1]] then
                        table.insert(tags, {
                            name = fields[1],
                            filename = help_files[fields[2]],
                            cmd = fields[3],
                            lang = lang,
                        })
                        tags_map[fields[1]] = true
                    end
                end
            end
        end
    end
    return tags
end
local function get_help_tag_lines(tag_name)
    local help_file
    local start = os.clock()
    for _, tag in pairs(dyn_help.help_tags()) do
        if
            tag.name == tag_name
            or tag.name == "'" .. tag_name .. "'"
            or tag.name == tag_name .. "()"
        then
            help_file = tag
            break
        end
    end
    -- dump(help_file)
    print(os.clock() - start .. "s")
    local lines = vim.fn.readfile(help_file.filename)
    -- dump(lines)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = 1,
        height = 1,
        col = 1,
        row = 1,
        border = "single",
        style = "minimal",
    })

    local query = help_file.cmd
    query = query:sub(2)
    query = [[\V]] .. query
    vim.cmd("norm! gg")
    vim.fn.search(query, "W")
    vim.cmd("norm! zz")
    local start_line = vim.api.nvim_win_get_cursor(win)[1]
    vim.cmd("q")
    local end_line
    local tag_lines = {}
    for i, line in ipairs(lines) do
        if i >= start_line then
            if line:match([[%*[^%s]+%*]]) and i ~= start_line then
                -- "%*%('%)?[%w_-]+%(()%)-%('%)?%*"
                break
            else
                table.insert(tag_lines, line)
            end
        end
    end

    local value = dyn_help.option_value()
    table.insert(tag_lines, 1, tag_name)
    if value ~= "" then
        table.insert(tag_lines, 3, "Current value: " .. value)
    end
    return tag_lines
end

local function test()
    local tag_lines = get_help_tag_lines(vim.fn.expand("<cword>"))
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
    local value = dyn_help.option_value(vim.fn.expand("<cword>"))
    if value ~= "" then
        vim.api.nvim_buf_add_highlight(buf, ns, "Keyword", 2, 0, -1)
    end
end

test()

return dyn_help
