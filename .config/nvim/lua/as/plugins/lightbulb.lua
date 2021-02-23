return function()
  require("as.autocommands").augroup(
    "LspLightbulb",
    {
      {
        events = {"CursorHold", "CursorHoldI"},
        targets = {"*"},
        command = [[
          lua require'nvim-lightbulb'.update_lightbulb {
            sign = {enabled = false},
            virtual_text = {enabled = true, text = "💡"}
          }
        ]]
      }
    }
  )
end
