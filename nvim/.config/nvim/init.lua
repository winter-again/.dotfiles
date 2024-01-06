if vim.g.vscode then
    -- settings restricted to VSCode extension
    -- load in just my settings and keymaps in VSCode
    -- not sure if this is completely safe because sets are in the same file
    print('Using Neovim in VS Code.')
    require('andrew.settings')
    require('andrew.keymaps')
else
    -- ordinary Neovim config
    require('andrew')
end
