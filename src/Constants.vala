/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */
//vala-lint=skip-file

/**
* I just dump all my constants here
*/
namespace Jorts {

    /*************************************************/
    const string DONATE_LINK             = "https://ko-fi.com/teamcons/tip";

    // signature theme
#if HALLOWEEN
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.ORANGE;
#else
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.BLUEBERRY;
#endif

    // in ms
    const int DEBOUNCE                   = 900;

    // CSS
    const string STYLE_THEMEDBUTTON      = "themedbutton";
    const string STYLE_DEVEL             = "devel";

    // We need to say stop at some point
    const int ZOOM_MAX                   = 300;
    const int DEFAULT_ZOOM               = 100;
    const int ZOOM_MIN                   = 20;
    const bool DEFAULT_MONO              = false;

    // For new stickies
    const int DEFAULT_WIDTH              = 290;
    const int DEFAULT_HEIGHT             = 320;


    const int SPACING_STANDARD           = 5;
    const int SPACING_DOUBLE           = 10;
    const int SPACING_TRIPLE           = 15;

    // Autocomplete save me
    const string KEY_SCRIBBLY           = "scribbly-mode-active";
    const string KEY_HIDEBAR            = "hide-bar";
    const string KEY_LIST               = "list-item-start";

    // Used by random_emote () for the emote selection menu
    const string[] EMOTES = {
        "face-angel-symbolic",
        "face-angry-symbolic",
        "face-cool-symbolic",
        "face-crying-symbolic",
        "face-devilish-symbolic",
        "face-embarrassed-symbolic",
        "face-kiss-symbolic",
        "face-laugh-symbolic",
        "face-monkey-symbolic",
        "face-plain-symbolic",
        "face-raspberry-symbolic",
        "face-sad-symbolic",
        "face-sick-symbolic",
        "face-smile-symbolic",
        "face-smile-big-symbolic",
        "face-smirk-symbolic",
        "face-surprise-symbolic",
        "face-tired-symbolic",
        "face-uncertain-symbolic",
        "face-wink-symbolic",
        "face-worried-symbolic"
    };
}