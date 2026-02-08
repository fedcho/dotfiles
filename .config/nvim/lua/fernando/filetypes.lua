vim.filetype.add({
  filename = {
    ["Jenkinsfile"] = "groovy",
    [".sqruff"] = "ini",
    ["Brewfile"] = "ruby",
  },
  pattern = {
    [".env"] = "sh",
    [".env.*"] = "sh",
  },
  extension = {
    hbs = "html",
    vil = "json",
  },
})
