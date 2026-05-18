local get_tool_path = require("winter-again.globals").get_tool_path

return {
    cmd = { get_tool_path("svelteserver"), "--stdio" },
}
