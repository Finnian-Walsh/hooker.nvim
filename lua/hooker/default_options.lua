local M = {
    -- how many lines tall the hooker window should be
    lines = 8,

    -- the relative width of the screen the hooker window should be
    width = 0.6,

    -- the function called when a directory is opened by the plugin (the directory is passed as the only argument)
    open_directory = vim.cmd.edit,

    -- which directory the hooks should be associated with (probably shouldn't be changed unless you know what you're doing)
    target_directory = vim.uv.cwd(),
}

return M
