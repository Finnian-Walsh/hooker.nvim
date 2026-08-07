local M = setmetatable({}, {
    __index = function(_, key)
        return function(msg)
            return require("vim.health")[key](msg)
        end
    end,
})

function M.check()
    local uname_obj = vim.system({ "uname" }):wait()

    if uname_obj.code ~= 0 then
        M.error("Only Unix-based systems are supported")
    else
        M.ok("Your system is using a Unix-based operating system")
    end
end

return M
