-- incl. workaround for some kind of highlighting in .mdx files
-- based on: https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
vim.filetype.add({
    -- key = ext to look for, value = filetype to assign
    extension = {
        astro = "astro",
        mdx = "mdx",
        log = "log",
        conf = "conf",
        env = "dotenv",
    },
    filename = {
        [".env"] = "dotenv",
        ["env"] = "dotenv",
        ["tsconfig.json"] = "jsonc",
    },
    pattern = {},
})

-- use markdown parser for mdx files
vim.treesitter.language.register("markdown", { "mdx" })
