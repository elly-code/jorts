/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/*************************************************/
/**
* Responsible to apply RedactedScript font
* Give it a window and it will simply follow settings
*/
public class Jorts.ColorController : Object {

    public weak Jorts.StickyNoteWindow window;

    public Jorts.Themes theme {
        get { return (Jorts.Themes)accent_color_action.get_state ();}
        set { action_prefers_color ((GLib.Variant)value);}
    }

    public SimpleAction accent_color_action;
    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "color_controller.";
    public const string ACTION_PREFERS_COLOR = "action_prefers_color";

    public ColorController (Jorts.StickyNoteWindow window) {
        this.window = window;
    }

    construct {
        actions = new SimpleActionGroup ();
        accent_color_action = new SimpleAction.stateful (
            ACTION_PREFERS_COLOR,
            GLib.VariantType.INT32,
            new Variant.int32 (Themes.IDK));

        accent_color_action.activate.connect (action_prefers_color);
        actions.add_action (accent_color_action);
    }

    /**
    * Switches stylesheet
    * First use appropriate stylesheet, Then switch the theme classes
    */
    public void on_color_changed (Jorts.Themes new_theme) {
        debug ("Updating theme to %s".printf (new_theme.to_string ()));

        var old_theme = (Jorts.Themes)accent_color_action.get_state ();

        // Add remove class
        window.remove_css_class (old_theme.to_string ());
        window.add_css_class (new_theme.to_string ());

        // Propagate values
        window.popover.color = new_theme;
        NoteData.latest_theme = new_theme;

        // Avoid using the wrong accent until the popover is closed
        var stylesheet = "io.elementary.stylesheet." + new_theme.to_string ().ascii_down ();
        Application.gtk_settings.gtk_theme_name = stylesheet;

        // Cleanup;
        window.has_changed ();
    }

    /**
    * Changes the stylesheet accents to the notes color
    * Add or remove the Redacted font if the setting is active
    */
    public void on_focus_changed () {
        debug ("Focus changed!");

        if (window.is_active) {
            var stylesheet = "io.elementary.stylesheet." + theme.to_string ().ascii_down ();
            Application.gtk_settings.gtk_theme_name = stylesheet;
        }
    }

    public void action_prefers_color (GLib.Variant? value) {
        if (accent_color_action.get_state ().equal (value)) {
            return;
        }

        on_color_changed ((Jorts.Themes)value);
        accent_color_action.set_state (value);
    }
}
