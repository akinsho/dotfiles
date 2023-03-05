----------------------------------------------------------------------------------------------------
--  HAMMERSPOON 🥄
----------------------------------------------------------------------------------------------------
-- DOCS: https://www.hammerspoon.org/go/

----------------------------------------------------------------------------------------------------
--  Toggle opening and closing kitty with a hotkey
----------------------------------------------------------------------------------------------------
-- from: https://github.com/kovidgoyal/kitty/issues/45#issuecomment-573196169

hs.hotkey.bind({ 'cmd', 'ctrl' }, 'a', function()
  local app = hs.application.get('kitty')

  if app then
    if not app:mainWindow() then
      app:selectMenuItem({ 'kitty', 'New OS window' })
    elseif app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  else
    hs.application.launchOrFocus('kitty')
    hs.application.get('kitty')
  end
end)

hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()
