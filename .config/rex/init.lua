-- Moves focus when a pane lies that way, and otherwise lets the key through to
-- the terminal so Neovim still gets ctrl+h/j/k/l.
local function focus_or_pass(direction)
  return function()
    local before = rex.session.view({})
    if not before then
      return false
    end
    local after = rex.session.focus_direction({ direction = direction, wrap = false })
    return after ~= nil and after.revision ~= before.revision
  end
end

rex.bind("ctrl+h", focus_or_pass("left"))
rex.bind("ctrl+j", focus_or_pass("down"))
rex.bind("ctrl+k", focus_or_pass("up"))
rex.bind("ctrl+l", focus_or_pass("right"))

rex.bind("ctrl+space>\\", "pane.split.right")
rex.bind("ctrl+space>-", "pane.split.down")
rex.bind("ctrl+space>space", "pane.zoom")
rex.bind("ctrl+space>x", "pane.close")
rex.bind("cmd+w", "pane.close")
