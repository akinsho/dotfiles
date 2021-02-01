return function()
  local fn = vim.fn
  local home = vim.env.HOME
  vim.g.wiki_path =
    fn.isdirectory(fn.expand("$HOME/Dropbox")) and home .. "/Dropbox/wiki" or home .. "/wiki"

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

  function _G.__vimwiki_close_wikis()
    local bufs = fn.getbufinfo {buflisted = true}
    for buf in bufs do
      if fn.bufexists(buf) and vim.bo[buf].filetype == "vimwiki" and fn.winbufnr(buf) == -1 then
        vim.cmd [[silent! execute buf 'bdelete']]
      end
    end
  end

  as_utils.cmd("CloseVimWikis", "lua __vimwiki_close_wikis()")
  as_utils.map("n", "<leader>wq", "<Cmd>CloseVimWikis<CR>")
  -- function! s:autocommit() abort
  --   try
  --   let msg = 'Auto commit'
  --   let add = 'git -C '.vim.g.learnings_wiki_path.' add .'
  --   let commit = 'git -C '.vim.g.learnings_wiki_path.' commit -m "'.msg.'" .'
  --   call luaeval('require("as.async_job").execSync(_A)', [add, commit])
  --   catch /.*/
  --   echoerr v:exception
  --   echo 'occurred at: '.v:throwpoint
  --   echoerr 'failed to commit '.vim.g.learnings_wiki_path
  --   endtry
  --   endfunction

  --   function! s:auto_push(...) abort
  --     try
  --     call utils#message('pushing '.vim.g.learnings_wiki_path.'...', 'Title')
  --     let cmd = 'git -C '. vim.g.learnings_wiki_path. ' push -q origin master'
  --     call luaeval('require("as.async_job").exec(_A, 0)', cmd)
  --     catch /.*/
  --     echoerr v:exception
  --     endtry
  --     endfunction

  --     let s:timer = -1

  --     function! s:auto_save_start() abort
  --       if s:timer < 0
  --         call utils#message('Starting learning wiki auto save', 'Title')
  --         let s:timer = timer_start(1000 * 60 * 5, function('s:auto_push'), { 'repeat': -1 })
  --           endif
  --           endfunction

  --           function! s:auto_save_stop() abort
  --             call utils#message('Stopping learning wiki auto save', 'Title')
  --             call timer_stop(s:timer)
  --             let s:timer = -1
  --             endfunction

  --             if has('nvim') --autocommit is a lua based function
  --                 let s:target_wiki = vim.g.learnings_wiki_path . '/*.wiki'
  --                 if isdirectory(vim.g.learnings_wiki_path . '/.git')
  --                   augroup AutoCommitLearningsWiki
  --                   autocmd!
  --                   execute 'autocmd BufWritePost '. s:target_wiki .' call <SID>autocommit()'
  --                   execute 'autocmd BufEnter,FocusGained '. s:target_wiki .' call <SID>auto_save_start()'
  --                   execute 'autocmd BufLeave,FocusLost '. s:target_wiki .' call <SID>auto_save_stop()'
  --                   augroup END
  --                   endif
  --                   endif
end
