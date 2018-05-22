import * as React from "/Users/akinyulife/Desktop/Coding/oni/dist/mac/Oni.app/Contents/Resources/app/node_modules/react";
import * as Oni from "/Users/akinyulife/Desktop/Coding/oni/dist/mac/Oni.app/Contents/Resources/app/node_modules/oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated");

    oni.input.unbind("<c-/>");
    oni.input.unbind("<m-d>");
    oni.input.unbind("<m-o>");
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
    oni.input.bind("<c-d>", "buffer.delete");
    oni.input.bind("<c-s>", "buffer.split");
    oni.input.bind("<c-v>", "buffer.vsplit");
    oni.input.bind("<m-h>", "oni.editor.hide");
    oni.input.bind("<m-n>", "sidebar.toggle");
    oni.input.bind("<m-.>", "oni.git.branches");
    oni.input.bind("<m-f>", "autoformat.prettier");
    // oni.input.bind("<m-f>", "oni.git.fetch");
    // oni.input.bind("<m-.>", "autoformat.prettier.selection");
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

export const configuration = {
    //add custom config here, such as
    // UI customizations
    "ui.animations.enabled": true,

    // Font ------------------------------------
    // add custom config here, such as

    // 'ui.colorscheme': 'nord',
    // 'ui.colorscheme': 'solarized8_dark',

    // Debug -----------------------------------
    "debug.showNotificationOnError": true,

    // LSP -------------------------------------
    // Flow Language Server ===============================================
    "language.javascript.languageServer.command": "flow-language-server",
    "language.javascript.languageServer.arguments": ["--stdio"],

    // TypeScript Language Server ===============================================
    // "language.typescript.languageServer.command": "javascript-typescript-stdio",
    // "language.typescript.languageServer.command": "javascript-typescript-stdio",
    // "language.typescript.languageServer.command": "typescript-language-server",
    // "language.typescript.languageServer.arguments": ["--stdio"],
    // "language.typescript.rootFiles": ["tsconfig.json", "package.json"],
    "editor.renderer": "webgl",

    "language.rust.languageServer.command": "rustup",
    "language.rust.languageServer.arguments": ["run", "stable", "rls"],
    "language.rust.languageServer.rootFiles": ["Cargo.toml"],

    // Vue Language Server ===============================================
    "language.vue.languageServer.command": "vls",

    // Lua Language Server ===============================================
    // "language.lua.languageServer.command": "lua-lsp",

    // Go Language Server ===============================================
    // "language.go.languageServer.command": "go-langserver",
    // "language.go.languageServer.arguments": ["--gocodecompletion", "--freeosmemory", "false"],
    // "language.go.languageServer.rootFiles": [".git"],

    // Experimental -----------------------------
    "markdownPreview.enabled": true,
    "experimental.welcome.enabled": false,

    // Oni Core ---------------------------------
    "oni.bookmarks": ["~/Dotfiles", "~/Desktop/Coding/Work"],
    "oni.useDefaultConfig": false,
    "oni.loadInitVim": true,
    // Editor -----------------------------------
    "achievements.enabled": false,
    "sidebar.plugins.enabled": true,
    "sidebar.width": "16em",

    // "editor.fontFamily": "Hasklig-Regular",
    // "editor.fontFamily": "DejaVuSansCode",
    // "editor.fontFamily": "OperatorMonoLig-Medium",
    // "editor.fontFamily": "LigaFantasqueSansMono-Regular",
    // "editor.fontFamily": "OperatorMonoLig-Book",
    // "editor.fontFamily": "LigaAnonymous_Pro-Regular",
    // "editor.fontFamily": "LigaUbuntuMono-Regular",
    // "editor.fontFamily": "LigaSFMono-Regular",
    // "editor.fontFamily": "LigaInconsolata-Regular",
    // "editor.fontFamily": "LigaIBMPlexMono-Regular",

    // "editor.fontSize": "16px",
    // "editor.linePadding": 0,

    // "editor.fontFamily": "FiraCode-Retina",
    // "editor.fontSize": "16px",
    // "editor.linePadding": 5,

    "editor.fontFamily": "LigaSourceCodeVariable-Roman",
    "editor.fontSize": "17px",
    "editor.linePadding": 3,

    // "editor.fontFamily": "LigaInput-Regular",
    // "editor.fontSize": "16px",
    // "editor.linePadding": 2.5,

    // "editor.fontFamily": "OperatorMono-Book",
    // "editor.fontSize": "17px",
    // "editor.linePadding": 1.5,

    // "editor.fontFamily": "DankMono-Regular",
    // "editor.fontSize": "18px",
    // "editor.linePadding": 0,

    "editor.scrollBar.visible": true,
    "editor.cursorLine": true,

    "explorer.autoRefresh": false,
    "experimental.particles.enabled": false,

    // Sidebar ----------------------------------
    "sidebar.default.open": false,
    // UI ---------------------------------------
    // "ui.fontFamily": "OperatorMono-Medium",
    // "ui.fontSmoothing": "subpixel-antialiased",
    // "ui.fontFamily": "FiraCode-Medium",
    "ui.fontFamily": "FiraCode-Medium",
    "ui.fontSize": "15px",
    "ui.colorscheme": "onedark",
    "tabs.mode": "buffers",

    // Workspace ---------------------------------------
    "workspace.autoDetectWorkspace": "always",

    // Plugins ---------------------------------------
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
        formatOnSave: false,
        enabled: true,
    },
};
