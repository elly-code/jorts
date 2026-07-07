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
public class Jorts.ScribblyController : Object {

    private const string STYLE_SCRIBBLED = "scribbled";
    private weak Jorts.StickyNoteWindow window;

    private bool _scribble;
    public bool scribble {
        get { return _scribble;}
        set { scribbly_set (value);}
    }

    public ScribblyController (Jorts.StickyNoteWindow window) {
        this.window = window;

        // Gtk bug: Backdrop is not set when a window is first created and shown. Only after it gets focused at least once
        // Report: https://gitlab.gnome.org/GNOME/gtk/-/work_items/8211
        window.set_state_flags (Gtk.StateFlags.BACKDROP, false);


        Application.settings.bind (
            KEY_SCRIBBLY,
            this, "scribble",
            SettingsBindFlags.DEFAULT);
    }

    /**
    * Wrapper to abstract setting/removing CSS as a bool
    */
    private void scribbly_set (bool if_scribbly) {
        debug ("Scribbly mode changed!");
        if (if_scribbly) {
            window.add_css_class (STYLE_SCRIBBLED);
            return;
        }

        window.remove_css_class (STYLE_SCRIBBLED);
    }

    ~ScribblyController () {
        debug ("Destroyed");
        window = null;
    }
}
