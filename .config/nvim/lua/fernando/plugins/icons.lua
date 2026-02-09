return {
  "nvim-tree/nvim-web-devicons",
  opts = {
    override = {
      css = {
        icon = "",
        color = "#42A5F5",
        cterm_color = "75",
        name = "Css",
      },
    },
    override_by_filename = {
      [".env.local"] = {
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "Env",
      },
    },
  },
}
