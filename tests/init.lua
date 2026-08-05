#!/usr/bin/env -S nvim -l

vim.pack.add { "https://github.com/nvim-mini/mini.test" }

require("mini.test").setup {}

local test_dir = vim.fs.dirname(vim.fn.fnamemodify(arg[0], ":p"))
local root_dir = vim.fs.dirname(test_dir)

vim.opt.rtp:prepend(root_dir)

require("hooker")
