-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Unfortunately, the file paths are too long and break things
vim.loader.enable(false)

-- Clipboard (hopefully, right now my clipboard provider is tmux ig so...)
vim.o.clipboard = "unnamedplus"
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- Is there a way I can set these in neovide config?
if vim.g.neovide then
  -- Neovide copy & pasting
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
  -- Neovide Scaling support
  vim.g.neovide_scale_factor = 1.0
  local set_scale_factor = function(value)
    vim.g.nevoide_scale_factor = value
  end
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)
  vim.keymap.set("n", "<C-0>", function()
    set_scale_factor(1.0)
  end)
  -- General Neovide settings
  vim.g.neovide_detach_on_quit = "always_detach"
  vim.g.neovide_fullscreen = true
end
