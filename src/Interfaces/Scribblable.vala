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
public interface Jorts.Scribblable : Gtk.Window {

    const string STYLE_SCRIBBLED = "scribbled";

    protected static bool _active_scribbling;
    public bool scribbling {
        get { return _active_scribbling;}
        set {
            scribble_follow_focus (value);
            _active_scribbling = value;
        }
    }

    /**
    * Wrapper to abstract setting/removing CSS as a bool
    */
    private void scribble_window (bool scribble_window) {

        if (scribble_window) {
            add_css_class (STYLE_SCRIBBLED);
            return;
        }

        remove_css_class (STYLE_SCRIBBLED);
    }

    /**
    * Connect-disconnect the whole manage text being scribbled
    */
    private void scribble_follow_focus (bool is_activated) {
        debug ("Scribbly mode changed!");

        if (is_activated) {
            notify["is-active"].connect (focus_scribble_unscribble);
            scribble_window (!is_active);

        } else {
            notify["is-active"].disconnect (focus_scribble_unscribble);
            scribble_window (false);
        }

        _active_scribbling = is_activated;
    }

    /**
    * Handler connected only when scribbly mode is active
    */
    private void focus_scribble_unscribble () {
        debug ("Scribbly mode changed!");
        scribble_window (!is_active);
    }
}
