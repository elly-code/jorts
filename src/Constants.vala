/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* I just dump all my constants here
*/
namespace Jorts.Constants {

    /*************************************************/
    const string RDNN                    = "io.github.elly_code.jorts";
    const string DONATE_LINK             = "https://ko-fi.com/teamcons";

    // signature theme
#if HALLOWEEN
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.ORANGE;
#elif CLASSIC
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.BANANA;
#else
    const Jorts.Themes DEFAULT_THEME    = Jorts.Themes.BLUEBERRY;
#endif

    // in ms
    const int DEBOUNCE                   = 900;

    // We need to say stop at some point
    const int ZOOM_MAX                   = 300;
    const int DEFAULT_ZOOM               = 100;
    const int ZOOM_MIN                   = 20;
    const bool DEFAULT_MONO                 = false;

    // For new stickies
    const int DEFAULT_WIDTH              = 290;
    const int DEFAULT_HEIGHT             = 320;

    // New preference window
    // We dont show autostart on windows, avoid awkward blank space
    // Autostart contributes to width too to accommodate buttons
#if WINDOWS
    const int DEFAULT_PREF_WIDTH         = 480;
    const int DEFAULT_PREF_HEIGHT        = 250;
#else
    const int DEFAULT_PREF_WIDTH         = 490;
    const int DEFAULT_PREF_HEIGHT        = 270;
#endif

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