vim.fn.sign_define("DiagnosticSignError",
  { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "", texthl = "DiagnosticSignHint" })

require("neo-tree").setup({
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    components = {
      harpoon_index = function(config, node, state)
        local Marked = require("harpoon.mark")
        local path = node:get_id()
        local succuss, index = pcall(Marked.get_index_of, path)
        if succuss and index and index > 0 then
          return {
            text = string.format(" ⥤ %d", index), -- <-- Add your favorite harpoon like arrow here
            highlight = config.highlight or "NeoTreeDirectoryIcon",
          }
        else
          return {}
        end
      end
    },
    renderers = {
      file = {
        { "icon" },
        { "name",         use_git_status_colors = true },
        { "harpoon_index" }, --> This is what actually adds the component in where you want it
        { "diagnostics" },
        { "git_status",   highlight = "NeoTreeDimText" },
      }
    }
  },
  window = {
    mappings = {
      ["h"] = function(state)
        local node = state.tree:get_node()
        if node.type == 'directory' and node:is_expanded() then
          require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
        else
          require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
        end
      end,
      ["l"] = function(state)
        local node = state.tree:get_node()
        if node.type == 'directory' then
          if not node:is_expanded() then
            require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
          elseif node:has_children() then
            require 'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
          end
        end
      end,
    }
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        require("neo-tree").close_all()
      end
    },
  },
})

vim.keymap.set("n", "<leader>ft", function()
  vim.cmd("Neotree filesystem left toggle")
end, { desc = "[F]ile [T]ree" })
