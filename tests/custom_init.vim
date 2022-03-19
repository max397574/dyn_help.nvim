set rtp+=.
set rtp+=../plenary.nvim/
set rtp+=../tree-sitter-lua/
set rtp+=./plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/opt/plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/start/plenary.nvim

runtime! plugin/plenary.vim

lua <<EOF
function P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
    return ...
end
EOF
