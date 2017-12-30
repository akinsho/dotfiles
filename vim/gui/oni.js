const activate = Oni => {
  console.log('config activated');
  Oni.input.unbind('<c-/>');
  Oni.input.bind('<m-\\>', 'language.symbols.document');
  Oni.input.bind('<m-r>', 'language.rename');
  Oni.input.bind('<m-/>', 'quickOpen.showBufferLines');
  Oni.input.bind('<m-,>', 'commands.show');
  Oni.input.bind('<m-;>', 'markdown.togglePreview');
  Oni.input.bind('<m-\'>', 'markdown.openPreview');
};

const deactivate = () => {
  console.log('config deactivated');
};

module.exports = {
  activate,
  deactivate,
  // add custom config here, such as
  // Font alternatives "OperatorMono-XLight,
  // OperatorMonoLig-Book,
  // Hasklug Nerd Font,
  // FuraCode Nerd Font,
  // OperatorMono-Light, Pragmata Pro"

  // 'ui.colorscheme': 'nord',
  // 'ui.colorscheme': 'solarized8_dark',
  // 'experimental.editor.textMateHighlighting.enabled': true,
  'experimental.commandline.mode': false,
  'experimental.wildmenu.mode': true,
  'experimental.markdownPreview.enabled': true,
  'experimental.sidebar.enabled': false,
  'oni.bookmarks': ['~/Dotfiles', '~/Desktop/Coding/Work'],
  'oni.useDefaultConfig': false,
  'oni.loadInitVim': true,
  'editor.fontSize': '17px',
  'editor.fontFamily': 'Hasklug Nerd Font',
  'editor.cursorLine': false,
  'editor.scrollBar.visible': true,
  'ui.fontFamily': 'Operator Mono',
  'ui.fontSize': '16px',
  'ui.colorscheme': 'onedark',
};
