return function()
  as.dashboard = {}
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
    all_sessions = {
      description = {" Last session"},
      command = "SessionLoad"
    },
    frecent = {
      description = join("ﭯ Recently opened", "<leader>fh"),
      command = "TelescopeFrecent"
    },
    project_files = {
      description = join(" Project Files", "<c-p>"),
      command = "TelescopeFindFiles"
    }
  }

  function as.dashboard.save_session()
    vim.cmd "SessionSave"
  end

  as.augroup(
    "TelescopeSession",
    {
      events = {"VimLeavePre"},
      targets = "*",
      command = "lua as.dashboard.save_session()"
    }
  )
end
