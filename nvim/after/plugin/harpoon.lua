vim.keymap.set("n", "<leader>hu", require("harpoon.ui").toggle_quick_menu, { desc = "[H]arpoon [U]i" })
vim.keymap.set("n", "<leader>m", require("harpoon.mark").add_file, { desc = "[M]ark" })
vim.keymap.set("n", "<leader>hk", require("harpoon.ui").nav_next, { desc = "[H]arpoon cycle next" })
vim.keymap.set("n", "<leader>hj", require("harpoon.ui").nav_prev, { desc = "[H]arpoon cycle previous" })

