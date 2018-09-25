import * as React from "/Users/akinyulife/Desktop/Coding/oni/dist/mac/Oni.app/Contents/Resources/app/node_modules/react";
import * as Oni from "/Users/akinyulife/Desktop/Coding/oni/dist/mac/Oni.app/Contents/Resources/app/node_modules/oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated");

    oni.input.unbind("<c-/>");
    oni.input.unbind("<m-d>");
    oni.input.unbind("<m-o>");
    oni.input.unbind("<m-s-f>");
    oni.input.unbind("<m-]>");
    oni.input.unbind("<m-[>");
    oni.input.bind(["<enter>", "<tab>"], "contextMenu.select");
    oni.input.bind("<m-d>", "language.gotoDefinition");
    oni.input.bind("<m-\\>", "language.symbols.document");
    oni.input.bind("<m-r>", "language.rename");
    oni.input.bind("<m-/>", "quickOpen.showBufferLines");
    oni.input.bind("<m-,>", "commands.show");
    oni.input.bind("<m-;>", "markdown.togglePreview");
    oni.input.bind("<m-'>", "markdown.openPreview");
    oni.input.bind("<enter>", "contextMenu.select");
    oni.input.bind("<m-o>", "buffer.toggle");
    oni.input.bind("<c-s-d>", "buffer.delete");
    oni.input.bind("<c-s>", "buffer.split");
    oni.input.bind("<c-v>", "buffer.vsplit");
    oni.input.bind("<m-h>", "oni.editor.hide");
    oni.input.bind("<m-n>", "sidebar.toggle");
    oni.input.bind("<m-[>", "oni.editor.nextError");
    oni.input.bind("<m-]>", "oni.editor.previousError");
    oni.input.bind("<m-.>", "vcs.branches");
    oni.input.bind("m-s-v", "vcs.sidebar.toggle");
    oni.input.bind("<m-f>", "autoformat.prettier");
    oni.input.bind("<m-b>", "quickOpen.showBookmarks");
    oni.input.bind("<c-f>", "oni.bookmarks.setFolderOrOpenFile");
    oni.input.bind("<m-s-f>", "quickOpen.searchFileByContent");
    oni.input.bind("<s-c-h>", () =>
        oni.editors.activeEditor.neovim.command(`call OniNextWindow('h')<CR>`),
    );
    oni.input.bind("<s-c-j>", () =>
        oni.editors.activeEditor.neovim.command(`call OniNextWindow('j')<CR>`),
    );
    oni.input.bind("<s-c-k>", () =>
        oni.editors.activeEditor.neovim.command(`call OniNextWindow('k')<CR>`),
    );
    oni.input.bind("<s-c-l>", () =>
        oni.editors.activeEditor.neovim.command(`call OniNextWindow('l')<CR>`),
    );
};

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated");
};

const shouldShowErrors = () => {
    const hours = new Date().getHours();
    return hours > 17;
};

/*
 * Font Selector function to deal with my insane behaviour
 */
const fonts = {
    monofur: {
        "editor.fontFamily": "MonofurForPowerline",
        "editor.fontSize": "19px",
    },
    spaceMono: {
        "editor.fontFamily": "SpaceMono-Regular-NL",
        "editor.fontSize": "17px",
        "editor.linePadding": -2,
    },
    dank: {
        "editor.fontFamily": "DankMono-Regular",
        "editor.fontSize": "17px",
        "editor.linePadding": 0,
    },
    officeCode: {
        "editor.fontFamily": "OfficeCodePro-Regular",
        "editor.fontSize": "16px",
        "editor.linePadding": 0,
    },
    hack: {
        "editor.fontFamily": "Hack-Regular",
        "editor.fontSize": "16px",
        "editor.linePadding": 0,
    },
    courier: {
        "editor.fontFamily": "CourierPrimeCode-Regular",
        "editor.fontSize": "17px",
        "editor.linePadding": 4.5,
    },
    hasklig: {
        "editor.fontFamily": "Hasklig-Regular",
        "editor.fontSize": "16px",
        "editor.linePadding": 0,
    },
    plex: {
        "editor.fontFamily": "LigaIBMPlexMono-Regular",
        "editor.fontSize": "16px",
        "editor.linePadding": 0,
    },
    source: {
        "editor.fontFamily": "SourceCodePro-Regular",
        "editor.fontSize": "17px",
        "editor.linePadding": 2.5,
    },
    monaco: {
        "editor.fontFamily": "Monaco",
        "editor.fontSize": "16px",
        "editor.linePadding": 4,
    },
    menlo: {
        "editor.fontFamily": "Menlo",
        "editor.fontSize": "16px",
        "editor.linePadding": 2,
    },
    fira: {
        "editor.fontFamily": "FiraCode-Regular",
        "editor.fontSize": "16px",
        "editor.linePadding": 5,
    },
    input: {
        "editor.fontFamily": "LigaInput-Regular",
        "editor.fontSize": "15px",
        "editor.linePadding": 3.5,
    },
    mononoki: {
        "editor.fontFamily": "mononokiNerdFontComplete-Regular",
        "editor.fontSize": "18px",
        "editor.linePadding": 1,
    },
    operatorBook: {
        "editor.fontFamily": "OperatorMono-Book",
        "editor.fontSize": "17px",
        "editor.linePadding": 1.5,
    },
    operatorLight: {
        "editor.fontFamily": "OperatorMono-Light",
        "editor.fontSize": "17px",
        "editor.linePadding": 1.5,
    },
};

function selectFont<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];
}

export const configuration = {
    //add custom config here, such as
    // UI customizations
    "ui.animations.enabled": true,
    "configuration.showReferenceBuffer": false,

    // Debug -----------------------------------
    "debug.showNotificationOnError": shouldShowErrors(),
    "editor.textMateHighlighting.enabled": true,
    "editor.textMateHighlighting.debugScopes": false,

    // LSP -------------------------------------

    // Flow Language Server ===============================================
    // "language.javascript.languageServer.command": "flow-language-server",
    // "language.javascript.languageServer.command":
    // "/Users/akinyulife/.config/yarn/global/node_modules/flow-language-server/lib/bin/cli.js",
    // "language.javascript.languageServer.arguments": ["--stdio"],

    // TypeScript Language Server ===============================================
    // "language.typescript.languageServer.command": "javascript-typescript-stdio",
    // "language.typescript.languageServer.command": "typescript-language-server",
    // "language.typescript.languageServer.arguments": ["--stdio"],
    // "language.typescript.rootFiles": ["tsconfig.json", "package.json"],

    "wildmenu.mode": true,
    "autoClosingPairs.enabled": false,
    "editor.renderer": "webgl",

    "language.rust.languageServer.command": "rustup",
    "language.rust.languageServer.arguments": ["run", "nightly", "rls"],
    "language.rust.languageServer.rootFiles": ["Cargo.toml"],

    // Vue Language Server ===============================================
    "language.vue.languageServer.command": "vls",

    // Lua Language Server ===============================================
    "language.lua.languageServer.command": "lua-lsp",

    // Go Language Server ===============================================
    "language.go.languageServer.command": "go-langserver",
    "language.go.languageServer.arguments": ["--gocodecompletion", "--freeosmemory", "false"],
    "language.go.languageServer.rootFiles": [".git"],

    // Experimental -----------------------------
    "experimental.markdownPreview.enabled": true,
    "experimental.vcs.sidebar": true,
    "experimental.vcs.blame.enabled": true,
    "experimental.particles.enabled": false,
    "experimental.sessions.enabled": false,
    "experimental.vcs.blame.mode": "auto",
    "experimental.colorHighlight.enabled": false,
    "experimental.indentLines.enabled": true,
    "experimental.indentLines.bannedFiletypes": [".csv", ".md", ".txt"],
    "experimental.welcome.enabled": true,

    // Oni Core ---------------------------------
    "oni.bookmarks": ["Dotfiles", "Desktop/Coding/Work"],
    "oni.useDefaultConfig": false,
    "oni.loadInitVim": true,

    "editor.tokenColors": [
        {
            scope: "comment",
            settings: {
                fontStyle: "bold italic",
            },
        },
    ],

    // Font ------------------------------------
    ...selectFont(fonts, "dank"),

    // Editor -----------------------------------
    "achievements.enabled": false,
    "sidebar.plugins.enabled": true,
    "sidebar.width": "20em",
    "sidebar.marks.enabled": true,

    "editor.scrollBar.visible": true,
    "editor.cursorLine": false,

    "explorer.autoRefresh": false,

    // Sidebar ----------------------------------
    "sidebar.default.open": false,
    // UI ---------------------------------------
    "ui.fontFamily": "Firacode-Regular",
    "ui.fontSize": "15px",

    // "tabs.height": "2em",
    "tabs.mode": "buffers",
    "tabs.dirtyMarker.userColor": "green",

    // "ui.colorscheme": "onedark",
    "ui.colorscheme": "night-owl",
    "browser.enabled": true,
    // Workspace ---------------------------------------
    "workspace.autoDetectWorkspace": "always",

    // Plugins ---------------------------------------
    "oni.plugins.touchbar": {
        enabled: true,
        escapeItem: "bigger",
        leftActions: "sidebar",
        middleActions: [
            { label: ":q", type: "nvim", command: "<esc>:q<enter>" },
            { label: ":w", type: "nvim", command: "<esc>:w<enter>" },
            { label: "Reload Oni", type: "oni", command: "oni.debug.reload" },
            { label: "New Oni Window", type: "oni", command: "oni.process.openWindow" },
            { label: "Open Folder", type: "oni", command: "workspace.openFolder" },
        ],
        rightActions: "interaction",
    },
    "oni.plugins.prettier": {
        settings: {
            semi: true,
            tabWidth: 4,
            useTabs: false,
            singleQuote: false,
            trailingComma: "all",
            bracketSpacing: true,
            jsxBracketSameLine: false,
            arrowParens: "avoid",
            printWidth: 100,
        },
        formatOnSave: true,
        enabled: true,
    },
    "oni.plugins.importCost": {
        enabled: true,
        smallSize: 8,
        showCalculating: false,
    },

    plugins: ["Akin909/oni-theme-night-owl"],
};
