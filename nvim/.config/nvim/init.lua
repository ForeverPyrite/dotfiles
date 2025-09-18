-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Is there a way I can set these in neovide config?
if vim.g.neovide then
  -- Neovide Scaling support
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)
  -- Neovide
  vim.g.neovide_detach_on_quit = "always_detach"
  vim.g.neovide_fullscreen = true
end

-- Unfortunately, the file paths are too long and break things
vim.loader.enable(false)
