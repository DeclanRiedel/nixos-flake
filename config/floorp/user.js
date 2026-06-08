// Floorp user preferences - managed by nix flake
// Changes here will be applied on every Floorp startup

// Tab behaviour
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.inTitlebar", 1);

// UI
user_pref("browser.theme.toolbar-theme", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Downloads
user_pref("browser.download.autohideButton", false);
user_pref("browser.download.panel.shown", true);
user_pref("browser.download.lastDir", "/home/declan/Downloads");

// Content
user_pref("browser.contentblocking.category", "standard");
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("keyword.enabled", true);
user_pref("browser.search.defaultenginename", "DuckDuckGo");
user_pref("browser.search.selectedEngine", "DuckDuckGo");
user_pref("browser.urlbar.suggest.searches", true);
user_pref("browser.urlbar.suggest.history", true);
user_pref("browser.urlbar.suggest.bookmark", true);

// Floorp design - Photon UI, vertical tabs
user_pref("floorp.design.configs", "{\"globalConfigs\":{\"userInterface\":\"photon\",\"faviconColor\":false,\"appliedUserJs\":\"\"},\"tabbar\":{\"tabbarStyle\":\"vertical\",\"tabbarPosition\":\"hide-horizontal-tabbar\",\"multiRowTabBar\":{\"maxRowEnabled\":false,\"maxRow\":3}},\"tab\":{\"tabScroll\":{\"enabled\":false,\"reverse\":false,\"wrap\":false},\"tabMinHeight\":30,\"tabMinWidth\":76,\"tabPinTitle\":false,\"tabDubleClickToClose\":false,\"tabOpenPosition\":-1},\"uiCustomization\":{\"navbar\":{\"position\":\"top\",\"searchBarTop\":false},\"display\":{\"disableFullscreenNotification\":false,\"deleteBrowserBorder\":false},\"special\":{\"optimizeForTreeStyleTab\":false,\"hideForwardBackwardButton\":false,\"stgLikeWorkspaces\":false},\"multirowTab\":{\"newtabInsideEnabled\":false},\"bookmarkBar\":{\"focusExpand\":false,\"position\":\"top\"},\"qrCode\":{\"disableButton\":false}}}}");
user_pref("floorp.browser.ssb.enabled", true);
user_pref("floorp.browser.ssb.config", "{\"showToolbar\":true}");
user_pref("floorp.browser.tabs.openNewTabPosition", -1);
user_pref("floorp.browser.welcome.page.shown", true);

// Floorp workspaces
user_pref("floorp.workspaces.enabled", true);
user_pref("floorp.workspaces.v4.config", "{\"manageOnBms\":false,\"showWorkspaceNameOnToolbar\":true,\"closePopupAfterClick\":false,\"exitOnLastTabClose\":false}");

// Floorp sidebar
user_pref("floorp.panelSidebar.enabled", false);
user_pref("floorp.panelSidebar.config", "{\"autoUnload\":false,\"position_start\":true,\"globalWidth\":400,\"displayed\":true,\"webExtensionRunningEnabled\":false}");

// Floorp split view
user_pref("floorp.splitView.config", "{\"layout\":\"horizontal\",\"maxPanes\":4}");

// Floorp mouse gestures
user_pref("floorp.mousegesture.enabled", false);
user_pref("floorp.mousegesture.config", "{\"enabled\":false,\"rockerGesturesEnabled\":true,\"wheelGesturesEnabled\":true,\"sensitivity\":40,\"showTrail\":true,\"showLabel\":true,\"trailColor\":\"#37ff00\",\"trailWidth\":6,\"contextMenu\":{\"minDistance\":5,\"preventionTimeout\":200},\"actions\":[{\"pattern\":[\"left\"],\"action\":\"gecko-back\"},{\"pattern\":[\"right\"],\"action\":\"gecko-forward\"},{\"pattern\":[\"up\",\"down\"],\"action\":\"gecko-reload\"},{\"pattern\":[\"down\",\"right\"],\"action\":\"gecko-close-tab\"},{\"pattern\":[\"down\",\"up\"],\"action\":\"gecko-open-new-tab\"},{\"pattern\":[\"up\"],\"action\":\"gecko-scroll-to-top\"},{\"pattern\":[\"down\"],\"action\":\"gecko-scroll-to-bottom\"},{\"pattern\":[\"left\",\"down\"],\"action\":\"gecko-scroll-up\"},{\"pattern\":[\"right\",\"down\"],\"action\":\"gecko-scroll-down\"}]}");

// Floorp keyboard shortcuts
user_pref("floorp.keyboardshortcut.enabled", true);
user_pref("floorp.keyboardshortcut.config", "{\"enabled\":true,\"shortcuts\":{}}");

// Floorp zen mode
user_pref("floorp.zenmode.enabled", false);
