-- Leave terminal-insert mode
vim.keymap.set("t", "<C-Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Window navigation: Alt+h/j/k/l works from terminal, normal, and insert mode
local directions = { h = "h", j = "j", k = "k", l = "l" }
for key, dir in pairs(directions) do
  vim.keymap.set("t", "<M-" .. key .. ">", [[<C-\><C-n><C-w>]] .. dir, { desc = "Window " .. dir })
  vim.keymap.set("n", "<M-" .. key .. ">", "<C-w>" .. dir, { desc = "Window " .. dir })
  vim.keymap.set("i", "<M-" .. key .. ">", "<Esc><C-w>" .. dir, { desc = "Window " .. dir })
end

-- Auto-focus terminal: drop into insert mode when opening or entering a terminal buffer
local term_group = vim.api.nvim_create_augroup("TerminalAutoInsert", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = term_group,
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})
