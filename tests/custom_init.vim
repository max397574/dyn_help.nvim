set rtp+=.
set rtp+=../plenary.nvim/
set rtp+=../tree-sitter-lua/

runtime! plugin/plenary.vim

lua <<EOF
function P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
    return ...
end
EOF
