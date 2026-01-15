vim.filetype.add({
  filename = {
    ["Jenkinsfile"] = "groovy",
    [".sqruff"] = "ini",
  },
  pattern = {
    [".env"] = "sh",
    [".env.*"] = "sh",
  },
  extension = {
    hbs = "html",
    ejs = "ejs",
    vil = "json",
  },
})
