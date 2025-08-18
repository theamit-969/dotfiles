return {

  -- zen-mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        options = {
          laststatus = 0,
        },
        tmux = true,
        kitty = { enabled = false, font = "+4" },
        alacritty = { enabled = true, font = "18" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- Not working
  -- {
  --   "rcarriga/nvim-notify",
  --   opts = {
  --     timeout = 10000,
  --   },
  -- },

  --filename
  -- NOTE:
  -- InclineNormal = Active filename bar
  -- InclineNormalNC = Inactive filename bar
  {
    "b0o/incline.nvim",
    -- dependencies = { "catppuccin/nvim" },
    -- dependencies = { "craftzdog/solarized-osaka.nvim" },
    -- dependencies = { "sainnhe/gruvbox-material" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      -- local colors = require("catppuccin.palettes").get_palette("mocha")
      -- local colors = require("solarized-osaka.colors").setup()
      local colors = {
        -- Gruvbox Material colors
        magenta500 = "#b16286", -- deep muted magenta
        base04 = "#928374", -- lighter gray
        violet500 = "#8f3f71", -- violet-ish
        base03 = "#3c3836", -- dark background
        mauve = "#b16286", -- use magenta500 as mauve
        crust = "#1d2021", -- crust dark bg
        overlay2 = "#7c6f64", -- gray overlay
        surface0 = "#504945", -- medium brown tone
      }
      require("incline").setup({
        highlight = {
          groups = {
            -- solarized-osaka 👇
            -- InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            -- InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
            -- catppuccin 👇
            -- InclineNormal = { guibg = colors.mauve, guifg = colors.crust },
            -- InclineNormalNC = { guifg = colors.overlay2, guibg = colors.surface0 },
            -- gruvbox-material 👇
            InclineNormal = { guibg = "#d79921", guifg = colors.crust },
            InclineNormalNC = { guifg = "#d4be98", guibg = colors.surface0 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },
}
