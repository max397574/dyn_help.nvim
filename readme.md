title: readme
description: Readme for dynamic help
authors: max
categories: docs
created: 2022-04-20
version: 0.0.11

# Features
- Display help in floating window
    - Of word under cursor
    - Display default and current value for options
- Statusline components
    - Display option value
    - Show if help is available

# Usage
Install with a package manager.
```lua
use("max397574/dyn_help.nvim")
```

## Floating Help
### Basic
You can use this
```lua
require("dynamic_help").float_help(<help_tag>)
```
to open the help for this in a floating window.

### Advanced (also more useful)
It's recommended to use a function in a mapping like this:
```lua
vim.keymap.set(
  "n", -- normal mode
  "<leader>hd" -- remember: help->dynamic
  function()
    if
      require("dynamic_help.extras.statusline").available() ~= "" -- check if help is available
    then
      require("dynamic_help").float_help(vim.fn.expand("<cword>")) -- open help
    else
      local help = vim.fn.input("Help Tag> ") -- get a help tag as user input
      require("dynamic_help").float_help(help) -- open help
    end
  end,
  {}
)
```

## Statusline
### Option Value
You can use this function to get the value of an option under the cursor:
```lua
return require("dynamic_help.extras.statusline").value()
```

### Help Available
You can use this function to display a symbol if help is available:
```lua
return require("dynamic_help.extras.statusline").available()
```

# Limitations
Not every help in a floating window will be perfect.
This is because I get the text by just going through help files and storing all lines up to the next tag with a regex.
So it can happen that some lines are missing.