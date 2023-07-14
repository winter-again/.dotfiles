if vim.g.vscode then
	-- settings restricted to VSCode extension
    -- load in just my sets and keymaps in VSCode
    -- not sure if this is completely safe because sets are in the same file
    print('Using Neovim in VS Code.')
    require('andrew.sets_and_remaps')
else
    -- ordinary Neovim config
    -- can just require a folder containing another init.lua file directly
    -- this loads andrew/init.lua
    require('andrew')
end
