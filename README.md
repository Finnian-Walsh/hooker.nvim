# Hooker

Create hooks to files in Neovim\
Inspired by the Harpoon plugin\
The sexual connotation of the plugin name is a side effect of the creator

## Installation

Use a plugin manager, such as Lazy:
```lua
return {
    "Neovimproved/hooker.nvim",
    opts = {},
}
```
Ensure that the setup function is called, otherwise the plugin will not start

## Configuration

The default options can be found [here](lua/hooker/default_options.lua)

## Niche features provided
1. Directory references don't break when the directory is moved:
- Hooker references directories by their inode number and creation time (thereby making it impossible for all practical purposes for the plugin to confuse directories with each other). Consequently, directories can be moved and the hooks still link to them.
- Since the inode number and creation time is used, this means that if a directory is deleted and recreated, the hooks will no longer link to that directory; however, fear not, since the plugin provides a `links` feature, which prompts you to reuse the hooks that you previously used for the directory.
2. A custom configurable function for opening a directory in case you want to use something specific:
- This is configured via the open_directory option
