return function()
  vim.g.startify_lists = {
    {type = "sessions", header = {"  😸 Sessions"}},
    {
      type = "dir",
      header = {"   Recently opened in " .. vim.fn.fnamemodify(vim.fn.getcwd(), "=t")}
    },
    {type = "files", header = {"   Recent"}},
    {type = "bookmarks", header = {"   Bookmarks"}},
    {type = "commands", header = {"   Commands"}}
  }

  vim.g.startify_bookmarks = {
    {z = "~/.zshrc"},
    {i = "~/.config/nvim/init.vim"},
    {t = "~/.config/tmux/.tmux.conf"},
    {d = vim.env.DOTFILES}
  }

  vim.g.header = {
    "",
    "███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗",
    "████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║",
    "██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║",
    "██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║",
    "██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║",
    "╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝",
    "",
    ""
  }

  local plugins_count = as.total_plugins()
  vim.g.header_suffix = {"", " Plugins loaded: " .. plugins_count.total .. " "}

  vim.g.startify_custom_header =
    "startify#pad(g:header + startify#fortune#boxed() + g:header_suffix)"

  vim.g.startify_commands = {
    {h = {"Help", ":help"}}
  }

  vim.g.startify_session_dir = vim.fn.stdpath("data") .. "/session/startify"
  vim.g.startify_fortune_use_unicode = 1
  vim.g.startify_session_autoload = 1
  vim.g.startify_session_delete_buffers = 1
  vim.g.startify_session_persistence = 1
  vim.g.startify_update_oldfiles = 1
  vim.g.startify_session_sort = 1
  vim.g.startify_change_to_vcs_root = 1
end
