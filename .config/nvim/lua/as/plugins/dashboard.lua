return function()
  as_utils.dashboard = {}
  local join = function(k, v)
    return {k .. string.rep(" ", 16) .. v}
  end
  vim.g.dashboard_custom_header = {
    "                                                       ",
    "                                                       ",
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    "                                                       ",
    "                                                       "
  }
  vim.g.dashboard_default_executive = "telescope"
  vim.g.dashboard_disable_statusline = 1
  vim.g.dashboard_session_directory = vim.fn.stdpath("data") .. "/session/dashboard"
  vim.g.dashboard_custom_section = {
    sessions = {
      description = join(" Last session", "SPC s l"),
      command = "SessionLoad"
    },
    frecent = {
      description = join("ﭯ Recently opened", "SPC s o"),
      command = "TelescopeFrecent"
    },
    files = {
      description = join(" Project Files", "SPC s f"),
      command = "TelescopeFindFiles"
    }
  }
  vim.g.dashboard_custom_shortcut = {
    files = "SPC s f",
    sessions = "SPC s l",
    frecent = "SPC s o"
  }

  function as_utils.dashboard.save_session()
    vim.cmd "SessionSave"
  end

  require("as.autocommands").augroup(
    "TelescopeSession",
    {
      events = {"VimLeavePre"},
      targets = "*",
      command = "lua as_utils.dashboard.save_session()"
    }
  )
end
