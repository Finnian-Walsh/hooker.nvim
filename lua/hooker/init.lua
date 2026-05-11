local M = {}

local written_hooks = {}
local hooker_buffer, hooker_win = -1, -1

local default_options = {
	lines = 8,
	width = 0.6,
	open_directory = vim.cmd.edit,
}

local function list_shallow_equal(a, b)
	if #a ~= #b then
		return false
	end

	for i, val in pairs(a) do
		if b[i] ~= val then
			return false
		end
	end

	return true
end

function M.dump_data()
	vim.print(written_hooks)
	vim.print(hooker_buffer, hooker_win)
end

function M.select(index)
	local file_name

	if vim.api.nvim_buf_is_valid(hooker_buffer) then
		file_name = vim.api.nvim_buf_get_lines(hooker_buffer, index - 1, index, true)[1]
	else
		file_name = written_hooks[index]
	end

	if file_name:match("/$") then
		M.options.open_directory(file_name)
	else
		vim.cmd.edit(file_name)
	end
end

function M.menu()
	if vim.api.nvim_win_is_valid(hooker_win) then
		vim.api.nvim_win_close(hooker_win)
	end

	written_hooks = M.fetch_files()

	local opts = M.options
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, #written_hooks, false, written_hooks)

	local width = math.floor(vim.o.columns * opts.width)
	local height = math.min(vim.o.lines - 1, opts.lines)

	local row = math.floor(math.max(0, vim.o.lines - height - vim.o.cmdheight - 1) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = "Hooker",
	})

	hooker_buffer = buf
	hooker_win = win

	vim.opt.number = true

	local function close_window()
		vim.api.nvim_win_close(win, true)
	end

	vim.keymap.set("n", "<Esc>", close_window, { buffer = buf, desc = "Close window" })
	vim.keymap.set("n", "q", close_window, { buffer = buf, desc = "Close window" })

	vim.keymap.set("n", "<CR>", function()
		local current_line = vim.api.nvim_win_get_cursor(win)[1]
		M.select(current_line)
	end)
end

function M.add_current()
	local current_file_path = vim.fn.expand("%:p")
	local relative_path = vim.fn.fnamemodify(current_file_path, ":.")
	vim.fn.setreg('"', relative_path)
	M.menu()
end

function M.save()
	local hooks = vim.api.nvim_buf_get_lines(hooker_buffer, 0, -1, true)

	local trim_index = #hooks + 1

	for i = #hooks, 1, -1 do
		if #hooks[i] > 0 then
			trim_index = i + 1
			break
		end
	end

	for i = trim_index, #hooks do
		hooks[i] = nil
	end

	if list_shallow_equal(hooks, written_hooks) then
		return
	end

	local ok, result = pcall(vim.json.encode, hooks)

	if not ok then
		vim.notify(result, vim.log.levels.ERROR)
		return
	end

	local hooker_file = io.open(".hooker.json", "w")

	if not hooker_file then
		vim.notify("Unable to open hooker file", vim.log.levels.ERROR)
		return
	end

	hooker_file:write(result)
	hooker_file:close()

	written_hooks = result
end

function M.fetch_files()
	local hooker_file = io.open(".hooker.json", "r")

	if not hooker_file then
		return {}
	end

	local ok, result = pcall(vim.json.decode, hooker_file:read("*a"))

	hooker_file:close()

	if not ok then
		error(result)
	end

	if type(result) ~= "table" then
		error("JSON has incorrect format")
	end

	return result
end

function M.setup(opts)
	written_hooks = M.fetch_files()

	if opts then
		M.options = vim.tbl_deep_extend("force", default_options, opts)
	else
		M.options = default_options
	end

	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function(ev)
			if ev.buf == hooker_buffer and vim.api.nvim_buf_is_valid(hooker_buffer) then
				M.save()
				vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
			end
		end,
	})
end

return M
