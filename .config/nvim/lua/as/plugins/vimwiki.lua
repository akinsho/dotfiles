local M = {}

function _G.__vimwiki_close_wikis()
  local fn = vim.fn
  local bufs = fn.getbufinfo {buflisted = true}
  for _, buf in ipairs(bufs) do
    if vim.bo[buf.bufnr].filetype == "vimwiki" then
      vim.api.nvim_buf_delete(buf.bufnr, {force = true})
    end
  end
end

function M.setup()
  local fn = vim.fn
  local home = vim.env.HOME
  vim.g.wiki_path =
    fn.isdirectory(fn.expand("$HOME/Dropbox")) > 0 and home .. "/Dropbox/wiki" or home .. "/wiki"

  vim.g.wiki = {
    name = "knowledge base",
    path = vim.g.wiki_path,
    path_html = vim.g.wiki_path .. "/public/",
    auto_toc = 1,
    auto_diary_index = 1,
    auto_generate_links = 1,
    auto_tags = 1
  }

  vim.g.learnings_wiki_path = home .. "/wiki"
  vim.g.learnings_wiki = {
    name = "Learnings",
    path = vim.g.learnings_wiki_path,
    path_html = vim.g.learnings_wiki_path .. "/public",
    auto_tags = 1,
    auto_export = 1
  }

  vim.g.dotfiles_wiki_path = vim.env.DOTFILES .. "/wiki"

  vim.g.dotfiles_wiki = {
    name = "Dotfiles Wiki",
    path = vim.g.dotfiles_wiki_path,
    path_html = vim.g.dotfiles_wiki_path .. "/public",
    auto_toc = 1,
    auto_tags = 1
  }
  vim.g.vimwiki_auto_chdir = 1
  vim.g.vimwiki_tags_header = "Wiki tags"
  vim.g.vimwiki_auto_header = 1
  vim.g.vimwiki_hl_headers = 1 --too colourful
  vim.g.vimwiki_conceal_pre = 1
  vim.g.vimwiki_hl_cb_checked = 1
  vim.g.vimwiki_list = {vim.g.wiki, vim.g.learnings_wiki, vim.g.dotfiles_wiki}

  vim.g.vimwiki_global_ext = 0
  vim.g.vimwiki_folding = "expr"
end

function M.config()
  as_utils.cmd("CloseVimWikis", "lua __vimwiki_close_wikis()")
  as_utils.map("n", "<leader>wq", "<Cmd>CloseVimWikis<CR>")

  function _G.__vimwiki_autocommit()
    local msg = "Auto commit"
    local add = "git -C " .. vim.g.learnings_wiki_path .. " add ."
    local commit = "git -C " .. vim.g.learnings_wiki_path .. ' commit -m "' .. msg .. '" .'
    local success, _ = pcall(require("as.async_job").execSync, add, commit)
    if not success then
      vim.cmd [[echoerr v:exception]]
      vim.cmd [[echo 'occurred at: '.v:throwpoint]]
      vim.api.nvim_echo({{"failed to commit " .. vim.g.learnings_wiki_path, "ErrorMsg"}}, true, {})
    end
  end

  local timer = -1

  function _G.__vimwiki_auto_save_start()
    if timer < 0 then
      vim.api.nvim_echo({{"Starting learning wiki auto save", "Title"}}, true, {})
      timer =
        vim.fn.timer_start(
        1000 * 60 * 5,
        function()
          vim.api.nvim_echo({{"pushing " .. vim.g.learnings_wiki_path .. "...", "Title"}}, true, {})
          local cmd = "git -C " .. vim.g.learnings_wiki_path .. " push -q origin master"
          local success = pcall(require("as.async_job").exec, cmd)
          if not success then
            vim.cmd [[echoerr v:exception]]
          end
        end,
        {["repeat"] = -1}
      )
    end
  end

  function _G.__vimwiki_auto_save_stop()
    vim.api({{"Stopping learning wiki auto save", "Title"}}, true, {})
    vim.fn.timer_stop(timer)
    timer = -1
  end

  local target_wiki = vim.g.learnings_wiki_path .. "/*.wiki"
  if vim.fn.isdirectory(vim.g.learnings_wiki_path .. "/.git") > 0 then
    require("as.autocommands").augroup(
      "AutoCommitLearningsWiki",
      {
        {events = {"BufWritePost"}, targets = {target_wiki}, command = "lua __vimwiki_autocommit()"},
        {
          events = {"BufEnter", "FocusGained"},
          targets = {target_wiki},
          command = "lua __vimwiki_auto_save_start()"
        },
        {
          events = {"BufLeave", "FocusLost"},
          targets = {target_wiki},
          command = "lua __vimwiki_auto_save_stop()"
        }
      }
    )
  end
end

return M
