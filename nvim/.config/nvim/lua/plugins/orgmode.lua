return {
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        config = function()
            require("orgmode").setup({
                org_agenda_files = "~/Documents/org/**/*",
                org_default_notes_file = "~/Documents/org/inbox.org",
                -- org_startup_indented = true, -- virtual indent
                -- org_adapt_indentation = true,
                mappings = {
                    org = {
                        org_open_at_point = { "gd", "gf" },
                    },
                },
            })
        end,
    },
    {
        "chipsenkbeil/org-roam.nvim",
        tag = "0.1.1",
        dependencies = {
            { "nvim-orgmode/orgmode", tag = "0.3.7" },
        },
        config = function()
            require("org-roam").setup({
                directory = "~/Documents/org/roam",
                -- org_files = {
                --     "~/Documents/org",
                -- },
                bindings = {
                    complete_at_point = "<leader>n.",
                },
            })
        end,
    },
}
