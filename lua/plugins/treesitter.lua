-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "dart",
      "bash",
      "fish",
      "yaml",
      "vim",
      "vimdoc",
      "lua",
      "luadoc",
      "luap",
      "json",
      "html",
      "javascript",
      "typescript",
      "tsx",
      "vue",
      "markdown",
      "markdown_inline",
      "rust",
      -- add more arguments for adding more treesitter parsers
    })

    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    }

    opts.textobjects = {} --  解决 adart 文件打开慢
  end,
}
