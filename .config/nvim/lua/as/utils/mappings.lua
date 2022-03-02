-----------------------------------------------------------------------------//
-- MAPPINGS
-----------------------------------------------------------------------------//
-- A very over-engineered mapping mini-module. Yes, I know I could have used one
-- a number of plugins and be done with it.
-- e.g
-- - https://github.com/b0o/mapx.nvim [The Best Option]
-- - https://github.com/svermeulen/vimpeccable [The Original]
--
-- But frankly I like to be in control of my mappings and I honestly think that very soon this
-- won't be needed as mappings are likely to become simpler once the native api is improved

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { label = opts } or opts and vim.deepcopy(opts) or {}
    if opts.label then
      local ok, wk = as.safe_require('which-key', { silent = true })
      if ok then
        wk.register({ [lhs] = opts.label }, { mode = mode })
      end
      opts.label = nil
    end
    opts = vim.tbl_extend('keep', opts, parent_opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
as.nmap = make_mapper('n', map_opts)
-- A recursive select mapping
as.xmap = make_mapper('x', map_opts)
-- A recursive terminal mapping
as.imap = make_mapper('i', map_opts)
-- A recursive operator mapping
as.vmap = make_mapper('v', map_opts)
-- A recursive insert mapping
as.omap = make_mapper('o', map_opts)
-- A recursive visual & select mapping
as.tmap = make_mapper('t', map_opts)
-- A recursive visual mapping
as.smap = make_mapper('s', map_opts)
-- A recursive normal mapping
as.cmap = make_mapper('c', { noremap = false, silent = false })
-- A non recursive normal mapping
as.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
as.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
as.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
as.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
as.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
as.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
as.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
as.cnoremap = make_mapper('c', { noremap = true, silent = false })
