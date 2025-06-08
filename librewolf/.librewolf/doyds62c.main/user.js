// NOTE: based on my Firefox user.js; Librewolf already configures many of the same
// privacy-related settings so I only set the other prefs here

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.profiles.enabled", true);

/** THEME ADJUSTMENTS ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

/** FULLSCREEN NOTICE ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
user_pref("browser.urlbar.unitConversion.enabled", true);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("dom.text_fragments.create_text_fragment.enabled", true);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);

/** POCKET ***/
user_pref("extensions.pocket.enabled", false);

/** DOWNLOADS ***/
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
user_pref("browser.download.open_pdf_attachments_inline", true);

/** TAB BEHAVIOR ***/
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("browser.menu.showViewImageInfo", true);
user_pref("findbar.highlightAll", true);
user_pref("layout.word_select.eat_space_to_next_word", false);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
 ****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

// PREF: allow websites to ask you for your location
user_pref("permissions.default.geo", 0);
// PREF: allow websites to ask you to receive site notifications
user_pref("permissions.default.desktop-notification", 0);

// PREF: restore Top Sites on New Tab page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);
// PREF: remove default Top Sites (Facebook, Twitter, etc.)
// This does not block you from adding your own.
user_pref("browser.newtabpage.activity-stream.default.sites", "");
// PREF: remove sponsored content on New Tab page
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // Sponsored shortcuts
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false); // Recommended by Pocket
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // Sponsored Stories

// PREF: disable unified search button
user_pref("browser.urlbar.scotchBonnet.enableOverride", false);

// PREF: enable container tabs
// can also install Multi-Account containers extension
user_pref("privacy.userContext.enabled", true);

// OPTIONAL HARDENING:

// PREF: disable Firefox Sync
user_pref("identity.fxaccounts.enabled", false);
// PREF: disable the Firefox View tour from popping up
user_pref("browser.firefox-view.feature-tour", '{"screen":"","complete":true}');

// PREF: disable login manager
user_pref("signon.rememberSignons", false);
// PREF: disable address and credit card manager
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// PREF: enable HTTPS-Only Mode
// Warn me before loading sites that don't support HTTPS
// in both Normal and Private Browsing windows.
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

// PREF: set DoH provider
// NOTE: currently having issues
// user_pref("network.trr.uri", "https://dns.dnswarden.com/00000000000000000000048"); // Hagezi Light + TIF DNS-over-HTTPS (DoH)
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
// increased protection option will switch back to local provider if any issues arise
// user_pref("network.trr.mode", 2);
// user_pref("network.trr.max-fails", 5);
// max protection option:
// PREF: enforce DNS-over-HTTPS (DoH)
user_pref("network.trr.mode", 3);

// PREF: hide weather on New Tab page
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// PREF: always ask where to save every file
user_pref("browser.download.useDownloadDir", false);
// PREF: ask whether to open or save new file types
user_pref("browser.download.always_ask_before_handling_new_types", true);

// PREF: display the installation prompt for all extensions
user_pref("extensions.postDownloadThirdPartyPrompt", false);

// PREF: enforce certificate pinning
// [ERROR] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE
// 1 = allow user MiTM (such as your antivirus) (default)
// 2 = strict
user_pref("security.cert_pinning.enforcement_level", 2);

// PREF: delete cookies, cache, and site data on shutdown
// manually set any exceptions
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown_v2.cache", true); // DEFAULT
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", true); // DEFAULT
// NOTE: retains browser history
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);

// PREF: after crashes or restarts, do not save extra session data
// such as form content, scrollbar positions, and POST data
user_pref("browser.sessionstore.privacy_level", 2);

/****************************************************************************/
// NOT PRIVACY RELATED:

// disable media keys, picture-in-picture, and topbar menu keys
user_pref("media.hardwaremediakeys.enabled", false);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("ui.key.menuAccessKeyFocuses", false);
// compact tab bar
user_pref("browser.uidensity", 1);
// highlight all search hits
user_pref("findbar.highlightAll", true);
// search highlighting
user_pref("ui.textSelectAttentionBackground", "#8f8aac");
user_pref("ui.textHighlightBackground", "#767676");
// allow userChrome.css customization
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
// VA-API hardware video accel; should no longer need since Firefox 115
// user_pref("media.ffmpeg.vaapi.enabled", true);
// for auto-collapse sidebery config where you want to drag tabs around without
// sidebery collapsing
user_pref("widget.gtk.ignore-bogus-leave-notify", 1);
// allow suggestions from bookmarks
user_pref("browser.urlbar.suggest.bookmark", true);
// whether to show bookmarks bar: always, never, or newtab
user_pref("browser.toolbars.bookmarks.visibility", "never");
// disable hover preview on tabs
user_pref("browser.tabs.hoverPreview.enabled", false);
user_pref("browser.tabs.hoverPreview.showThumbnails", false);

// XDG desktop portals
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
 ****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:
// only use one at a time

// only sharpen scrolling
// user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
// user_pref("general.smoothScroll", true); // DEFAULT
// user_pref("mousewheel.min_line_scroll_amount", 10); // 10-40; adjust this number to your liking; default=5
// user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80); // default=50
// user_pref("general.smoothScroll.currentVelocityWeighting", "0.15"); // default=.25
// user_pref("general.smoothScroll.stopDecelerationWeighting", "0.6"); // default=.4

// recommended for 60hz+ displays
user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
user_pref("general.smoothScroll", true); // DEFAULT
user_pref("mousewheel.default.delta_multiplier_y", 275); // 250-400; adjust this number to your liking
// Firefox Nightly only:
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1846935
// user_pref("general.smoothScroll.msdPhysics.enabled", false); // [FF122+ Nightly]

/****************************************************************************
 * END: BETTERFOX                                                           *
 ****************************************************************************/
