/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */


/* CONTENT

Preferences is boring
Everything is in a Handle so user can move the window from anywhere
It is a box, with inside of it a box and an actionbar

the innerbox has widgets for settings.
the actionbar has a donate me and a set back to defaults just like elementaryOS

*/
public class Jorts.PreferenceWindow : Gtk.Window {


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


    public PreferenceWindow (Jorts.Application app) {
        debug ("[PREFWINDOW] Creating preference window");
        Intl.setlocale ();

        application = app;

#if DEVEL
        add_css_class (STYLE_DEVEL);
#endif

        /********************************************/
        /*              HEADERBAR BS                */
        /********************************************/

        /// TRANSLATORS: Feel free to improvise. The goal is a playful wording to convey the idea of app-wide settings
        title = _("Preferences - Jorts");

        var headerbar = new Gtk.HeaderBar () {
            title_widget = new Gtk.Label (_("Preferences for your Jorts")),
            show_title_buttons = false
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        headerbar.add_css_class (STYLE_PREFTITLE);

        set_titlebar (headerbar);
        set_size_request (DEFAULT_PREF_WIDTH, DEFAULT_PREF_HEIGHT);
        set_default_size (DEFAULT_PREF_WIDTH, DEFAULT_PREF_HEIGHT);
        resizable = false;

        var prefview = new Jorts.PreferencesView ();

        // Make the whole window grabbable
        var handle = new Gtk.WindowHandle () {
            child = prefview
        };

        this.child = handle;

        set_focus (prefview.close_button);

        // Since each sticky note adopts a different accent color
        // we have to revert to default when this one is focused
        this.notify["is-active"].connect (() => {
            if (this.is_active) {
                Application.gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry";
            }
        });
    }
}
