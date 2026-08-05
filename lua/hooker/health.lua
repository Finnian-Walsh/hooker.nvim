local M = setmetatable({}, {
    __index = function(_, key)
        return function(msg)
            return require("vim.health")[key](msg)
        end
    end,
})

function M.check()
    local uname_obj = vim.system{"uname"}:wait()

    if uname_obj.code ~= 0 then
        M.warn("Support for non Unix-based systems is limited")
    else
        M.ok("A Unix-based operating system is in use! The plugin will function correctly")
    end
end

return M
