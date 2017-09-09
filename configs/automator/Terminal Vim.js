// Script which uses the automator app
// to open vim in iterm2 with a given file

function run(input, parameters) {
  const iTerm = Application('iTerm2');
  iTerm.activate();
  const windows = iTerm.windows();
  let window;
  let tab;
  if (windows.length) {
    window = iTerm.currentWindow();
    tab = window.createTabWithDefaultProfile();
  } else {
    window = iTerm.createWindowWithDefaultProfile();
    tab = window.currentTab();
  }
  const session = tab.currentSession();
  const files = input.map(file => quotedForm(file));
  session.write({ text: 'nvim ' + files.join(' ') });
}

function quotedForm(path) {
  const string = path.toString();
  if (string === '' || string === null) return "''";
  return string
    .replace(/([^a-z0-9_\-.,:\/@\n])/gi, '\\$1')
    .replace(/\n/g, "'\n'");
}
