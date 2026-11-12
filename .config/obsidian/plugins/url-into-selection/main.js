'use strict';

var obsidian = require('obsidian');

/*! *****************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise */

var extendStatics = function(d, b) {
    extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
    return extendStatics(d, b);
};

function __extends(d, b) {
    if (typeof b !== "function" && b !== null)
        throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
    extendStatics(d, b);
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
}

function __awaiter(thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
}

function __generator(thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
}

function getDefaultExportFromCjs (x) {
	return x && x.__esModule && Object.prototype.hasOwnProperty.call(x, 'default') ? x['default'] : x;
}

function createCommonjsModule(fn, basedir, module) {
	return module = {
		path: basedir,
		exports: {},
		require: function (path, base) {
			return commonjsRequire(path, (base === undefined || base === null) ? module.path : base);
		}
	}, fn(module, module.exports), module.exports;
}

function commonjsRequire () {
	throw new Error('Dynamic requires are not currently supported by @rollup/plugin-commonjs');
}

var assertNever_1 = createCommonjsModule(function (module, exports) {
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * Helper function for exhaustive checks of discriminated unions.
 * https://basarat.gitbooks.io/typescript/docs/types/discriminated-unions.html
 *
 * @example
 *
 *    type A = {type: 'a'};
 *    type B = {type: 'b'};
 *    type Union = A | B;
 *
 *    function doSomething(arg: Union) {
 *      if (arg.type === 'a') {
 *        return something;
 *      }
 *
 *      if (arg.type === 'b') {
 *        return somethingElse;
 *      }
 *
 *      // TS will error if there are other types in the union
 *      // Will throw an Error when called at runtime.
 *      // Use `assertNever(arg, true)` instead to fail silently.
 *      return assertNever(arg);
 *    }
 */
function assertNever(value, noThrow) {
    if (noThrow) {
        return value;
    }
    throw new Error("Unhandled discriminated union member: " + JSON.stringify(value));
}
exports.assertNever = assertNever;
exports.default = assertNever;
});

var assertNever = /*@__PURE__*/getDefaultExportFromCjs(assertNever_1);

// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

// resolves . and .. elements in a path array with directory names there
// must be no slashes, empty elements, or device names (c:\) in the array
// (so also no leading and trailing slashes - it does not distinguish
// relative and absolute paths)
function normalizeArray(parts, allowAboveRoot) {
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = parts.length - 1; i >= 0; i--) {
    var last = parts[i];
    if (last === '.') {
      parts.splice(i, 1);
    } else if (last === '..') {
      parts.splice(i, 1);
      up++;
    } else if (up) {
      parts.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (allowAboveRoot) {
    for (; up--; up) {
      parts.unshift('..');
    }
  }

  return parts;
}

// Split a filename into [root, dir, basename, ext], unix version
// 'root' is just a slash, or nothing.
var splitPathRe =
    /^(\/?|)([\s\S]*?)((?:\.{1,2}|[^\/]+?|)(\.[^.\/]*|))(?:[\/]*)$/;
var splitPath = function(filename) {
  return splitPathRe.exec(filename).slice(1);
};

// path.resolve([from ...], to)
// posix version
function resolve() {
  var resolvedPath = '',
      resolvedAbsolute = false;

  for (var i = arguments.length - 1; i >= -1 && !resolvedAbsolute; i--) {
    var path = (i >= 0) ? arguments[i] : '/';

    // Skip empty and invalid entries
    if (typeof path !== 'string') {
      throw new TypeError('Arguments to path.resolve must be strings');
    } else if (!path) {
      continue;
    }

    resolvedPath = path + '/' + resolvedPath;
    resolvedAbsolute = path.charAt(0) === '/';
  }

  // At this point the path should be resolved to a full absolute path, but
  // handle relative paths to be safe (might happen when process.cwd() fails)

  // Normalize the path
  resolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {
    return !!p;
  }), !resolvedAbsolute).join('/');

  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';
}
// path.normalize(path)
// posix version
function normalize(path) {
  var isPathAbsolute = isAbsolute(path),
      trailingSlash = substr(path, -1) === '/';

  // Normalize the path
  path = normalizeArray(filter(path.split('/'), function(p) {
    return !!p;
  }), !isPathAbsolute).join('/');

  if (!path && !isPathAbsolute) {
    path = '.';
  }
  if (path && trailingSlash) {
    path += '/';
  }

  return (isPathAbsolute ? '/' : '') + path;
}
// posix version
function isAbsolute(path) {
  return path.charAt(0) === '/';
}

// posix version
function join() {
  var paths = Array.prototype.slice.call(arguments, 0);
  return normalize(filter(paths, function(p, index) {
    if (typeof p !== 'string') {
      throw new TypeError('Arguments to path.join must be strings');
    }
    return p;
  }).join('/'));
}


// path.relative(from, to)
// posix version
function relative(from, to) {
  from = resolve(from).substr(1);
  to = resolve(to).substr(1);

  function trim(arr) {
    var start = 0;
    for (; start < arr.length; start++) {
      if (arr[start] !== '') break;
    }

    var end = arr.length - 1;
    for (; end >= 0; end--) {
      if (arr[end] !== '') break;
    }

    if (start > end) return [];
    return arr.slice(start, end - start + 1);
  }

  var fromParts = trim(from.split('/'));
  var toParts = trim(to.split('/'));

  var length = Math.min(fromParts.length, toParts.length);
  var samePartsLength = length;
  for (var i = 0; i < length; i++) {
    if (fromParts[i] !== toParts[i]) {
      samePartsLength = i;
      break;
    }
  }

  var outputParts = [];
  for (var i = samePartsLength; i < fromParts.length; i++) {
    outputParts.push('..');
  }

  outputParts = outputParts.concat(toParts.slice(samePartsLength));

  return outputParts.join('/');
}

var sep = '/';
var delimiter = ':';

function dirname(path) {
  var result = splitPath(path),
      root = result[0],
      dir = result[1];

  if (!root && !dir) {
    // No dirname whatsoever
    return '.';
  }

  if (dir) {
    // It has a dirname, strip trailing slash
    dir = dir.substr(0, dir.length - 1);
  }

  return root + dir;
}

function basename(path, ext) {
  var f = splitPath(path)[2];
  // TODO: make this comparison case-insensitive on windows?
  if (ext && f.substr(-1 * ext.length) === ext) {
    f = f.substr(0, f.length - ext.length);
  }
  return f;
}


function extname(path) {
  return splitPath(path)[3];
}
var path = {
  extname: extname,
  basename: basename,
  dirname: dirname,
  sep: sep,
  delimiter: delimiter,
  relative: relative,
  join: join,
  isAbsolute: isAbsolute,
  normalize: normalize,
  resolve: resolve
};
function filter (xs, f) {
    if (xs.filter) return xs.filter(f);
    var res = [];
    for (var i = 0; i < xs.length; i++) {
        if (f(xs[i], i, xs)) res.push(xs[i]);
    }
    return res;
}

// String.prototype.substr - negative index don't work in IE8
var substr = 'ab'.substr(-1) === 'b' ?
    function (str, start, len) { return str.substr(start, len) } :
    function (str, start, len) {
        if (start < 0) start = str.length + start;
        return str.substr(start, len);
    }
;

function fileUrl(filePath, options = {}) {
	if (typeof filePath !== 'string') {
		throw new TypeError(`Expected a string, got ${typeof filePath}`);
	}

	const {resolve = true} = options;

	let pathName = filePath;
	if (resolve) {
		pathName = path.resolve(filePath);
	}

	pathName = pathName.replace(/\\/g, '/');

	// Windows drive letter must be prefixed with a slash.
	if (pathName[0] !== '/') {
		pathName = `/${pathName}`;
	}

	// Escape required characters for path components.
	// See: https://tools.ietf.org/html/rfc3986#section-3.3
	return encodeURI(`file://${pathName}`).replace(/[?#]/g, encodeURIComponent);
}

// https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch08s18.html
var win32Path = /^[a-z]:\\(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]*$/i;
var unixPath = /^(?:\/[^/]+)+\/?$/i;
var testFilePath = function (url) { return win32Path.test(url) || unixPath.test(url); };
function UrlIntoSelection(editor, cb, settings) {
    // skip all if nothing should be done
    if (!editor.somethingSelected() && settings.nothingSelected === 0 /* doNothing */)
        return;
    if (typeof cb !== "string" && cb.clipboardData === null) {
        console.error("empty clipboardData in ClipboardEvent");
        return;
    }
    var clipboardText = getCbText(cb);
    if (clipboardText === null)
        return;
    var _a = getSelnRange(editor, settings), selectedText = _a.selectedText, replaceRange = _a.replaceRange;
    var replaceText = getReplaceText(clipboardText, selectedText, settings);
    if (replaceText === null)
        return;
    // apply changes
    if (typeof cb !== "string")
        cb.preventDefault(); // prevent default paste behavior
    replace(editor, replaceText, replaceRange);
    // if nothing is selected and the nothing selected behavior is to insert [](url) place the cursor between the square brackets
    if ((selectedText === "") && settings.nothingSelected === 2 /* insertInline */) {
        editor.setCursor({ ch: replaceRange.from.ch + 1, line: replaceRange.from.line });
    }
}
function getSelnRange(editor, settings) {
    var selectedText;
    var replaceRange;
    if (editor.somethingSelected()) {
        selectedText = editor.getSelection().trim();
        replaceRange = null;
    }
    else {
        switch (settings.nothingSelected) {
            case 1 /* autoSelect */:
                replaceRange = getWordBoundaries(editor, settings);
                selectedText = editor.getRange(replaceRange.from, replaceRange.to);
                break;
            case 2 /* insertInline */:
            case 3 /* insertBare */:
                replaceRange = getCursor(editor);
                selectedText = "";
                break;
            case 0 /* doNothing */:
                throw new Error("should be skipped");
            default:
                assertNever(settings.nothingSelected);
        }
    }
    return { selectedText: selectedText, replaceRange: replaceRange };
}
function isUrl(text, settings) {
    if (text === "")
        return false;
    try {
        // throw TypeError: Invalid URL if not valid
        new URL(text);
        return true;
    }
    catch (error) {
        // settings.regex: fallback test allows url without protocol (http,file...)
        return testFilePath(text) || new RegExp(settings.regex).test(text);
    }
}
function isImgEmbed(text, settings) {
    var rules = settings.listForImgEmbed
        .split("\n")
        .filter(function (v) { return v.length > 0; })
        .map(function (v) { return new RegExp(v); });
    for (var _i = 0, rules_1 = rules; _i < rules_1.length; _i++) {
        var reg = rules_1[_i];
        if (reg.test(text))
            return true;
    }
    return false;
}
/**
 * Validate that either the text on the clipboard or the selected text is a link, and if so return the link as
 * a markdown link with the selected text as the link's text, or, if the value on the clipboard is not a link
 * but the selected text is, the value of the clipboard as the link's text.
 * If the link matches one of the image url regular expressions return a markdown image link.
 * @param clipboardText text on the clipboard.
 * @param selectedText highlighted text
 * @param settings plugin settings
 * @returns a mardown link or image link if the clipboard or selction value is a valid link, else null.
 */
function getReplaceText(clipboardText, selectedText, settings) {
    var linktext;
    var url;
    if (isUrl(clipboardText, settings)) {
        linktext = selectedText;
        url = clipboardText;
    }
    else if (isUrl(selectedText, settings)) {
        linktext = clipboardText;
        url = selectedText;
    }
    else
        return null; // if neither of two is an URL, the following code would be skipped.
    var imgEmbedMark = isImgEmbed(clipboardText, settings) ? "!" : "";
    url = processUrl(url);
    if (selectedText === "" && settings.nothingSelected === 3 /* insertBare */) {
        return "<".concat(url, ">");
    }
    else {
        return imgEmbedMark + "[".concat(linktext, "](").concat(url, ")");
    }
}
/** Process file url, special characters, etc */
function processUrl(src) {
    var output;
    if (testFilePath(src)) {
        output = fileUrl(src, { resolve: false });
    }
    else {
        output = src;
    }
    if (/[<>]/.test(output))
        output = output.replace("<", "%3C").replace(">", "%3E");
    return /[\(\) ]/.test(output) ? "<".concat(output, ">") : output;
}
function getCbText(cb) {
    var clipboardText;
    if (typeof cb === "string") {
        clipboardText = cb;
    }
    else {
        if (cb.clipboardData === null) {
            console.error("empty clipboardData in ClipboardEvent");
            return null;
        }
        else {
            clipboardText = cb.clipboardData.getData("text");
        }
    }
    return clipboardText.trim();
}
function getWordBoundaries(editor, settings) {
    var cursor = editor.getCursor();
    var line = editor.getLine(cursor.line);
    var wordBoundaries = findWordAt(line, cursor);
    // If the token the cursor is on is a url, grab the whole thing instead of just parsing it like a word
    var start = wordBoundaries.from.ch;
    var end = wordBoundaries.to.ch;
    while (start > 0 && !/\s/.test(line.charAt(start - 1)))
        --start;
    while (end < line.length && !/\s/.test(line.charAt(end)))
        ++end;
    if (isUrl(line.slice(start, end), settings)) {
        wordBoundaries.from.ch = start;
        wordBoundaries.to.ch = end;
    }
    return wordBoundaries;
}
var findWordAt = (function () {
    var nonASCIISingleCaseWordChar = /[\u00df\u0587\u0590-\u05f4\u0600-\u06ff\u3040-\u309f\u30a0-\u30ff\u3400-\u4db5\u4e00-\u9fcc\uac00-\ud7af]/;
    function isWordChar(char) {
        return /\w/.test(char) || char > "\x80" &&
            (char.toUpperCase() != char.toLowerCase() || nonASCIISingleCaseWordChar.test(char));
    }
    return function (line, pos) {
        var check;
        var start = pos.ch;
        var end = pos.ch;
        (end === line.length) ? --start : ++end;
        var startChar = line.charAt(pos.ch);
        if (isWordChar(startChar)) {
            check = function (ch) { return isWordChar(ch); };
        }
        else if (/\s/.test(startChar)) {
            check = function (ch) { return /\s/.test(ch); };
        }
        else {
            check = function (ch) { return (!/\s/.test(ch) && !isWordChar(ch)); };
        }
        while (start > 0 && check(line.charAt(start - 1)))
            --start;
        while (end < line.length && check(line.charAt(end)))
            ++end;
        return { from: { line: pos.line, ch: start }, to: { line: pos.line, ch: end } };
    };
})();
function getCursor(editor) {
    return { from: editor.getCursor(), to: editor.getCursor() };
}
function replace(editor, replaceText, replaceRange) {
    if (replaceRange === void 0) { replaceRange = null; }
    // replaceRange is only not null when there isn't anything selected.
    if (replaceRange && replaceRange.from && replaceRange.to) {
        editor.replaceRange(replaceText, replaceRange.from, replaceRange.to);
    }
    // if word is null or undefined
    else
        editor.replaceSelection(replaceText);
}

var DEFAULT_SETTINGS = {
    regex: /[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/
        .source,
    nothingSelected: 0 /* doNothing */,
    listForImgEmbed: "",
};
var UrlIntoSelectionSettingsTab = /** @class */ (function (_super) {
    __extends(UrlIntoSelectionSettingsTab, _super);
    function UrlIntoSelectionSettingsTab() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    UrlIntoSelectionSettingsTab.prototype.display = function () {
        var _this = this;
        var containerEl = this.containerEl;
        var plugin = this.plugin;
        containerEl.empty();
        containerEl.createEl("h2", { text: "URL-into-selection Settings" });
        new obsidian.Setting(containerEl)
            .setName("Fallback Regular expression")
            .setDesc("Regular expression used to match URLs when default match fails.")
            .addText(function (text) {
            return text
                .setPlaceholder("Enter regular expression here..")
                .setValue(plugin.settings.regex)
                .onChange(function (value) { return __awaiter(_this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            if (!(value.length > 0)) return [3 /*break*/, 2];
                            plugin.settings.regex = value;
                            return [4 /*yield*/, plugin.saveSettings()];
                        case 1:
                            _a.sent();
                            _a.label = 2;
                        case 2: return [2 /*return*/];
                    }
                });
            }); });
        });
        new obsidian.Setting(containerEl)
            .setName("Behavior on pasting URL when nothing is selected")
            .setDesc("Auto Select: Automatically select word surrounding the cursor.")
            .addDropdown(function (dropdown) {
            var options = {
                0: "Do nothing",
                1: "Auto Select",
                2: "Insert [](url)",
                3: "Insert <url>",
            };
            dropdown
                .addOptions(options)
                .setValue(plugin.settings.nothingSelected.toString())
                .onChange(function (value) { return __awaiter(_this, void 0, void 0, function () {
                return __generator(this, function (_a) {
                    switch (_a.label) {
                        case 0:
                            plugin.settings.nothingSelected = +value;
                            return [4 /*yield*/, plugin.saveSettings()];
                        case 1:
                            _a.sent();
                            this.display();
                            return [2 /*return*/];
                    }
                });
            }); });
        });
        new obsidian.Setting(containerEl)
            .setName("Whitelist for image embed syntax")
            .setDesc(createFragment(function (el) {
            el.appendText("![selection](url) will be used for URL that matches the following list.");
            el.createEl("br");
            el.appendText("Rules are regex-based, split by line break.");
        }))
            .addTextArea(function (text) {
            text
                .setPlaceholder("Example:\nyoutu.?be|vimeo")
                .setValue(plugin.settings.listForImgEmbed)
                .onChange(function (value) {
                plugin.settings.listForImgEmbed = value;
                plugin.saveData(plugin.settings);
                return text;
            });
            text.inputEl.rows = 6;
            text.inputEl.cols = 25;
        });
    };
    return UrlIntoSelectionSettingsTab;
}(obsidian.PluginSettingTab));

var UrlIntoSel_Plugin = /** @class */ (function (_super) {
    __extends(UrlIntoSel_Plugin, _super);
    function UrlIntoSel_Plugin() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        // pasteHandler = (cm: CodeMirror.Editor, e: ClipboardEvent) => UrlIntoSelection(cm, e, this.settings);
        _this.pasteHandler = function (evt, editor) { return UrlIntoSelection(editor, evt, _this.settings); };
        return _this;
    }
    UrlIntoSel_Plugin.prototype.onload = function () {
        return __awaiter(this, void 0, void 0, function () {
            var _this = this;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        console.log("loading url-into-selection");
                        return [4 /*yield*/, this.loadSettings()];
                    case 1:
                        _a.sent();
                        this.addSettingTab(new UrlIntoSelectionSettingsTab(this.app, this));
                        this.addCommand({
                            id: "paste-url-into-selection",
                            name: "",
                            editorCallback: function (editor) { return __awaiter(_this, void 0, void 0, function () {
                                var clipboardText;
                                return __generator(this, function (_a) {
                                    switch (_a.label) {
                                        case 0: return [4 /*yield*/, navigator.clipboard.readText()];
                                        case 1:
                                            clipboardText = _a.sent();
                                            UrlIntoSelection(editor, clipboardText, this.settings);
                                            return [2 /*return*/];
                                    }
                                });
                            }); },
                        });
                        this.app.workspace.on("editor-paste", this.pasteHandler);
                        return [2 /*return*/];
                }
            });
        });
    };
    UrlIntoSel_Plugin.prototype.onunload = function () {
        console.log("unloading url-into-selection");
        this.app.workspace.off("editor-paste", this.pasteHandler);
    };
    UrlIntoSel_Plugin.prototype.loadSettings = function () {
        return __awaiter(this, void 0, void 0, function () {
            var _a, _b, _c, _d;
            return __generator(this, function (_e) {
                switch (_e.label) {
                    case 0:
                        _a = this;
                        _c = (_b = Object).assign;
                        _d = [{}, DEFAULT_SETTINGS];
                        return [4 /*yield*/, this.loadData()];
                    case 1:
                        _a.settings = _c.apply(_b, _d.concat([_e.sent()]));
                        return [2 /*return*/];
                }
            });
        });
    };
    UrlIntoSel_Plugin.prototype.saveSettings = function () {
        return __awaiter(this, void 0, void 0, function () {
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this.saveData(this.settings)];
                    case 1:
                        _a.sent();
                        return [2 /*return*/];
                }
            });
        });
    };
    return UrlIntoSel_Plugin;
}(obsidian.Plugin));

module.exports = UrlIntoSel_Plugin;


/* nosourcemap */