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

rex.bind("ctrl+shift+/", "pane.split.auto")
rex.bind("ctrl+shift+h", "pane.split.left")
rex.bind("ctrl+shift+j", "pane.split.down")
rex.bind("ctrl+shift+k", "pane.split.up")
rex.bind("ctrl+shift+l", "pane.split.right")

rex.bind("ctrl+shift+space", "pane.zoom")
rex.bind("cmd+w", "pane.close")
