/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/*************************************************/
/**
* Responsible to apply RedactedScript font
* Give it a window and it will simply follow settings
*/
public class Jorts.ScribblyController : Object {

    private weak Jorts.StickyNoteWindow window;

    private bool _scribble;
    public bool scribble {
        get { return _scribble;}
        set { scribble_follow_focus (value);}
    }

    public ScribblyController (Jorts.StickyNoteWindow window) {
        this.window = window;

        Application.gsettings.bind (
            "scribbly-mode-active",
            this, "scribble",
            SettingsBindFlags.DEFAULT);
    }

    /**
    * Connect-disconnect the whole manage text being scribbled
    */
    private void scribble_follow_focus (bool is_activated) {
        debug ("Scribbly mode changed!");

        if (is_activated) {
            window.notify["is-active"].connect (focus_scribble_unscribble);
            scribbly_set (!window.is_active);

        } else {
            window.notify["is-active"].disconnect (focus_scribble_unscribble);
            scribbly_set (false);
        }

        _scribble = is_activated;
    }

    /**
    * Handler connected only when scribbly mode is active
    */
    private void focus_scribble_unscribble () {
        debug ("Scribbly mode changed!");
        scribbly_set (!window.is_active);
    }

    /**
    * Wrapper to abstract setting/removing CSS as a bool
    */
    private void scribbly_set (bool if_scribbly) {
        if (if_scribbly) {
            window.add_css_class ("scribbly");

        } else {
            if ("scribbly" in window.css_classes) {
                window.remove_css_class ("scribbly");
            }
        }
    }
}
