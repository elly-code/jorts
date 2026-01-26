/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*************************************************/
/**
* Responsible to apply RedactedScript font
* Give it a window and it will simply follow settings
*/
public class Jorts.ColorController : Object {

    private weak Jorts.StickyNoteWindow window;

    private Jorts.Themes _theme;
    public Jorts.Themes theme {
        get { return _theme;}
        set { on_color_changed (value);}
    }

    public ColorController (Jorts.StickyNoteWindow window) {
        this.window = window;
    }

    /**
    * Switches stylesheet
    * First use appropriate stylesheet, Then switch the theme classes
    */
    public void on_color_changed (Jorts.Themes new_theme) {
        debug ("Updating theme to %s".printf (new_theme.to_string ()));

        // Add remove class
        if (_theme.to_string () in window.css_classes) {
            window.remove_css_class (_theme.to_string ());
        }
        window.add_css_class (new_theme.to_string ());

        // Propagate values
        _theme = new_theme;
        window.popover.color = new_theme;
        NoteData.latest_theme = new_theme;

        // Avoid using the wrong accent until the popover is closed
        var stylesheet = "io.elementary.stylesheet." + new_theme.to_string ().ascii_down ();
        Application.gtk_settings.gtk_theme_name = stylesheet;

        // Cleanup;
        window.changed ();
    }

    /**
    * Changes the stylesheet accents to the notes color
    * Add or remove the Redacted font if the setting is active
    */
    public void on_focus_changed () {
        debug ("Focus changed!");

        if (window.is_active) {
            var stylesheet = "io.elementary.stylesheet." + _theme.to_string ().ascii_down ();
            Application.gtk_settings.gtk_theme_name = stylesheet;
        }
    }
}
