-- 社区插件 https://github.com/AstroNvim/astrocommunity

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.motion.flash-nvim" }, -- 加速jk移动 https://github.com/rainbowhxch/accelerated-jk.nvim
  { import = "astrocommunity.scrolling.neoscroll-nvim" }, -- 平滑滚动 https://github.com/karb94/neoscroll.nvim

  -- import/override with your plugins folder
}
