const activate = Oni => {
  console.log('config activated');
  Oni.input.unbind('<c-/>');
  Oni.input.unbind('<tab>');
  Oni.input.unbind('<m-d>');
  Oni.input.bind('<m-d>', 'language.gotoDefinition');
  Oni.input.bind('<m-\\>', 'language.symbols.document');
  Oni.input.bind('<m-r>', 'language.rename');
  Oni.input.bind('<m-/>', 'quickOpen.showBufferLines');
  Oni.input.bind('<m-,>', 'commands.show');
  Oni.input.bind('<m-;>', 'markdown.togglePreview');
  Oni.input.bind('<m-\'>', 'markdown.openPreview');
  Oni.input.bind('<enter>', 'contextMenu.select');
  Oni.input.bind('<tab>', 'contextMenu.next');
  Oni.input.bind('<S-tab>', 'contextMenu.previous');
  Oni.input.bind('<m-u>', 'oni.editor.hide');
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
  // OperatorMono Nerd Font,
  // OperatorMono-Light, Pragmata Pro"
  // 'ui.colorscheme': 'nord',
  // 'ui.colorscheme': 'solarized8_dark',

  'language.vue.languageServer.command': 'vls',
  'language.javascript.languageServer.command': 'flow-language-server',
  'language.javascript.languageServer.arguments': ['--stdio'],
  'experimental.editor.textMateHighlighting.enabled': true,
  'experimental.commandline.mode': true,
  'experimental.commandline.icons': true,
  'experimental.wildmenu.mode': true,
  'experimental.markdownPreview.enabled': true,
  'experimental.sidebar.enabled': false,
  'oni.bookmarks': ['~/Dotfiles', '~/Desktop/Coding/Work'],
  'oni.useDefaultConfig': false,
  'oni.loadInitVim': true,
  'editor.fontSize': '17px',
  'editor.fontFamily': 'Hasklug Nerd Font',
  // 'editor.fontFamily': 'FuraCode Nerd Font',
  // 'editor.fontFamily': 'OperatorMonoLig-Book',
  'editor.cursorLine': false,
  'editor.scrollBar.visible': false,
  'ui.fontFamily': 'OperatorMono-BoldItalic',
  'ui.fontSize': '17px',
  'ui.colorscheme': 'onedark',
};
