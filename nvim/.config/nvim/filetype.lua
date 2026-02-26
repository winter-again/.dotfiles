-- incl. workaround for some kind of highlighting in .mdx files
-- based on: https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
vim.filetype.add({
    -- mapping from file ext to filetype
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
    -- pattern = {},
})
