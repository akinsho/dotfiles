const activate = Oni => {
  console.log('config activated');
  Oni.input.unbind('<c-/>');
  Oni.input.bind('<m-\\>', 'language.symbols.document');
  Oni.input.bind('<m-r>', 'language.rename');
  Oni.input.bind('<m-/>', 'quickOpen.showBufferLines');
};

const deactivate = () => {
  console.log('config deactivated');
};

module.exports = {
  activate,
  deactivate,
  //add custom config here, such as
  'oni.bookmarks': ['~/Documents', '~/Desktop/Coding/Work'],
  'oni.useDefaultConfig': false,
  'oni.loadInitVim': true,
  'editor.fontSize': '16px',
  'editor.fontFamily': 'FuraCode Nerd Font',
  'editor.cursorLine': false,
  'editor.completions.enabled': true,
  'editor.scrollBar.visible': false,
  'environment.additionalPaths': [
    '/usr/bin',
    '/usr/local/bin',
    '/Users/akinyulife/.config/yarn/global/node_modules/.bin',
  ],
  'editor.formatting.formatOnSwitchToNormalMode': true,
  'ui.fontFamily': 'FuraCode Nerd Font',
  'ui.fontSize': '16px',
};
