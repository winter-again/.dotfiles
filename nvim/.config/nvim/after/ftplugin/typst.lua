-- TODO: not sure why this isn't working
vim.opt_local.shiftwidth = 4 -- number of spaces to use for autoindent

vim.opt_local.wrap = true
-- wrap long lines at chars in breakat var
vim.opt_local.linebreak = true
-- wrapped lines keep any indents
vim.opt_local.breakindent = true

vim.opt_local.spell = true

local root = vim.fs.root(0, { ".git", ".gitignore", ".fdignore", ".markdownlint-cli2.jsonc" })
local notebook_dir = vim.fs.normalize("~/Documents/notebook")

if root ~= nil and root == notebook_dir then
    vim.opt_local.spellfile = vim.uv.cwd() .. "/spell/en.utf-8.add"
end
