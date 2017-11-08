const activate = (Oni) => {
   console.log("config activated")
}

const deactivate = () => {
   console.log("config deactivated")
}

module.exports = {
   activate,
   deactivate,
  //add custom config here, such as
  "oni.bookmarks": ["~/Documents","~/Desktop/Coding/Work"],
  "oni.useDefaultConfig": false,
  "oni.loadInitVim": true,
  "editor.fontSize": "16px",
  "editor.fontFamily": "FuraCode Nerd Font",
  "editor.completions.enabled": true,
  "environment.additionalPaths": ['/usr/bin', '/usr/local/bin','/Users/akinyulife/.config/yarn/global/node_modules/.bin'],
  "editor.formatting.formatOnSwitchToNormalMode": true
}
