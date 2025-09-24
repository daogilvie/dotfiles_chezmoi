return {
  servers = {
    terraformls = {
      lsp_config = {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "terraform-vars" },
        root_markers = { ".terraform", ".git" }
      }
    }
  }
}
