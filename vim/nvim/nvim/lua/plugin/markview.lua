vim.pack.add({
  "https://github.com/OXY2DEV/markview.nvim",
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "markdown",
  callback = function()

    local presets = require("markview.presets")

    require("markview").setup(
      {
        preview = {
          -- Disable automatic previews.
          enable = false,
          enable_hybrid_mode = false,
          debounce = 300,       -- 防抖延迟(ms)
          max_buf_lines = 1000, -- 超过此行数启用部分渲染
          icon_provider = "devicons",
        },

        markdown = {
          -- 标题
          headings = {
            heading_1 = {
              style = "label",
              align = "left",
              sign = "󰉫",
              icon = " ",
              padding_left = "╾──────",
              padding_right = " ──────╼", 
            },
            heading_2 = {
              style = "label",
              align = "left",
              sign = "󰉬",
              icon = " ",
              padding_left = "╾─────",
              padding_right = " ─────╼", 
            },
            heading_3 = {
              style = "label",
              align = "left",
              sign = "󰉭",
              icon = " ",
              padding_left = "╾────",
              padding_right = " ────╼", 
            },
            heading_4 = {
              style = "label",
              align = "left",
              sign = "󰉮",
              icon = " ",
              padding_left = "╾───",
              padding_right = " ───╼", 
            },
            heading_5 = {
              style = "label",
              align = "left",
              sign = "󰉯",
              icon = " ",
              padding_left = "╾──",
              padding_right = " ──╼", 
            },
            heading_6 = {
              style = "label",
              align = "left",
              sign = "󰉰",
              icon = " ",
              padding_left = "╾─",
              padding_right = " ─╼", 
            },
          },
          -- 代码块配置
          code_blocks = {
            label_direction = "left",
            sign = false,
          },
          -- 水平线
          horizontal_rules = presets.horizontal_rules.thick,
          -- 表格
          tables = presets.tables.rounded
        },
        markdown_inline = {
          -- 复选框
          checkboxes = {
            enable = true,
            checked = { text = "󰄲" },
            unchecked = { text = "󰄱" },
          },
        }
      }
      -- No nerd font
      -- ,require("markview.presets").no_nerd_fonts
    )

    vim.keymap.set("n", "<leader>mp", "<CMD>Markview splitToggle<CR>", { desc = "Toggles `markview` previews globally." })
  end,
})
