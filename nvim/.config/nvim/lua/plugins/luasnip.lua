return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- build = (function()
    --     -- build step needed for optional regex support in snipppets
    --     if vim.fn.executable("make") == 0 then
    --         return
    --     end
    --     return "make install_jsregexp"
    -- end)(),
    config = function()
        local ls = require("luasnip")

        ls.setup({
            update_events = { "TextChanged", "TextChangedI" },
            enable_autosnippets = true,
        })
        ls.filetype_extend("markdown", { "python", "go" })

        require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/lua/winter-again/snippets" },
        })

        local map = require("winter-again.globals").map
        local opts = { silent = true }
        map({ "i", "s" }, "<C-h>", function()
            ls.jump(-1)
        end, opts, "Jump to previous snippet node")
        map({ "i", "s" }, "<C-l>", function()
            ls.jump(1)
        end, opts, "Jump to next snippet node")
    end,
}
