local M = {}
local Utils = require "utils"

-- NOTE: 禁用的键位(Disable Mappings)
M["disableMapping"] = {
  -- NOTE: 基础禁用键位
  baseMapping = {
    n = {
      ["<Leader>q"] = false,
      ["<Leader>Q"] = false,
      ["<Leader>sl"] = false,
      ["<Leader>c"] = false,
      ["<Leader>C"] = false,
      ["<Leader>h"] = false,
      ["<Leader>tf"] = false,
      ["<Leader>th"] = false,
      ["<Leader>tl"] = false,
      ["<Leader>tn"] = false,
      ["<Leader>tp"] = false,
      ["<Leader>tv"] = false,
    },
  },
  -- NOTE: Lsp禁用键位
  lspMapping = {
    n = {},
  },
}

-- NOTE: 键位映射(Key Mappings)
M["keyMapping"] = {
  -- NOTE: 基础键位映射
  baseMapping = {
    n = {
      --- 基础通用映射 General Mapping
      ["?"] = { "*", desc = "基础映射 查询光标下单词" },
      ["<Leader>q"] = { desc = "基础映射" },
      ["<Leader>qq"] = { "<CMD>qa<CR>", desc = "基础映射 退出AstroNvim" },
      ["<Leader>qs"] = {
        function() require("resession").load "Last Session" end,
        desc = "基础映射 加载最后的会话",
      },
      ["<Leader><Leader>"] = {
        function() require("telescope.builtin").find_files() end,
        desc = "查询(Find) 查找文件",
      },

      --- 光标映射 Cursor Mapping
      ["<A-j>"] = { "<cmd>m .+1<cr>==", desc = "光标(Cursor) nModel光标行向下移动" },
      ["<A-k>"] = { "<cmd>m .-2<cr>==", desc = "光标(Cursor) nModel光标行向上移动" },

      --- 缓冲区映射 Buffer Mapping
      ["<Leader>b"] = { desc = "缓冲区(Buffers)" },
      L = {
        function() require("astrocore.buffer").nav(vim.v.count1) end,
        desc = "缓冲区(Buffer) 下一个缓冲区",
      },
      H = {
        function() require("astrocore.buffer").nav(-vim.v.count1) end,
        desc = "缓冲区(Buffer) 上一个缓冲区",
      },
      ["<Leader>bd"] = {
        function() require("astrocore.buffer").close() end,
        desc = "缓冲区(Buffer) 关闭当前缓冲区",
      },
      ["<Leader>bD"] = {
        function() require("astrocore.buffer").close_all() end,
        desc = "缓冲区(Buffer) 关闭所有缓冲区",
      },

      --- Todo插件映射
      ["tn"] = {
        function() require("todo-comments").jump_next() end,
        desc = "待办(TODO) 下一个待办事项",
      },
      ["tp"] = {
        function() require("todo-comments").jump_prev() end,
        desc = "待办(TODO) 上一个待办事项",
      },
    },
    i = {
      --- 光标映射 Cursor Mapping
      ["<C-b>"] = { "<ESC>^i", desc = "光标(Cursor) iModel光标移动到行首" },
      ["<C-e>"] = { "<End>", desc = "光标(Cursor) iModel光标移动到行尾" },
      ["<C-h>"] = { "<Left>", desc = "光标(Cursor) iModel光标向左移动" },
      ["<C-l>"] = { "<Right>", desc = "光标(Cursor) iModel光标向右移动" },
      ["<C-j>"] = { "<Down>", desc = "光标(Cursor) iModel光标下移动" },
      ["<C-k>"] = { "<Up>", desc = "光标(Cursor) iModel光标上移动" },
      ["<A-j>"] = { "<esc><cmd>m .+1<cr>==gi", desc = "光标(Cursor) iModel光标行向下移动" },
      ["<A-k>"] = { "<esc><cmd>m .-2<cr>==gi", desc = "光标(Cursor) iModel光标行向上移动" },
    },
    v = {
      --- 光标映射 Cursor Mapping
      ["<A-j>"] = { ":m '>+1<cr>gv=gv", desc = "光标(Cursor) vModel光标行向下移动" },
      ["<A-k>"] = { ":m '<-2<cr>gv=gv", desc = "光标(Cursor) vModel光标行向上移动" },
    },
    t = {},
  },

  -- NOTE: Lsp键位映射
  lspMapping = {
    n = {
      ["<Leader>c"] = {
        desc = require("astroui").get_icon("ActiveLSP", 1, true) .. "语言服务器(LSP) Language Tools",
      },
      ["<Leader>ca"] = {
        function() vim.lsp.buf.code_action() end,
        desc = "语言服务器(LSP) code action",
      },
    },
  },
}

-- 多 Model 下的键位映射
function M.multipleModelMapping()
  local map = vim.keymap.set

  -- 光标映射 Cursor Mapping
  map({ "n", "v" }, "<Leader>h", "^", { desc = "光标(Cursor) 光标移动到行首" })
  map({ "n", "v" }, "<Leader>l", "$", { desc = "光标(Cursor) 光标移动到行尾" })

  --  终端映射 Terminal Mapping
  map({ "n", "i", "t" }, "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "终端(Terminal) 切换终端状态" })

  -- 调用easydict翻译快捷键
  map({ "n", "v" }, "<Leader>ts", function()
    local mode = vim.fn.mode()
    local selected_text = Utils.get_text(mode)
    os.execute("open easydict://" .. selected_text)
    vim.api.nvim_input "<Esc>"
  end, { desc = "翻译" })
end

M.multipleModelMapping()

--- 将禁用的映射和基础的映射进行合并
---baseMapping
M["baseMapping"] = Utils.merge_mapping(M["disableMapping"]["baseMapping"], M["keyMapping"]["baseMapping"])
---lspMapping
M["lspMapping"] = Utils.merge_mapping(M["disableMapping"]["lspMapping"], M["keyMapping"]["lspMapping"])

return M
