---@class Options
---@field lines integer How many lines tall the hooker window should be
---@field width number The relative width of the screen the hooker window should be
---@field open_directory function The function called when a directory is opened by the plugin (the directory is passed as the only argument)
---@field target_directory string Which directory the hooks should be associated with (special field)

---@type Options
local M = {
    lines = 8,
    width = 0.6,
    open_directory = vim.cmd.edit,
    target_directory = assert(vim.uv.cwd(), "Expected a current working directory"),
}

return M
