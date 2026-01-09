/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/*************************************************/
/**
* Responsible to apply zoom appropriately to a window.
* Mainly, this abstracts zoom into an int and swap CSS classes
* As a treat it includes also the plumbing for ctrl+scroll zooming
*/
public class Jorts.ZoomController : Object {

    private static bool is_control_key_pressed = false;
    private weak Jorts.StickyNoteWindow window;

    // Avoid setting this unless it is to restore a specific value, do_set_zoom does not check input
    private int _old_zoom;
    public int zoom {
        get {return _old_zoom;}
        set {do_set_zoom (value);}
    }

    public ZoomController (Jorts.StickyNoteWindow window) {
        this.window = window;
    }

    /**
    * Handler. Wraps a zoom enum into the correct function-
    */
    public void zoom_changed (Jorts.Zoomkind zoomkind) {
        debug ("Zoom changed!");
        switch (zoomkind) {
            case Zoomkind.ZOOM_IN:              zoom_in (); return;          // vala-lint=double-spaces
            case Zoomkind.DEFAULT_ZOOM:         zoom_default (); return;     // vala-lint=double-spaces
            case Zoomkind.ZOOM_OUT:             zoom_out (); return;         // vala-lint=double-spaces
            default:                            return;                      // vala-lint=double-spaces
        }
    }

    /**
    * Wrapper to check an increase doesnt go above limit
    */
    public void zoom_in () {
        if ((_old_zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            zoom = _old_zoom + 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    public void zoom_default () {
        if (_old_zoom != Jorts.Constants.DEFAULT_ZOOM ) {
            zoom = Jorts.Constants.DEFAULT_ZOOM;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Wrapper to check an increase doesnt go below limit
    */
    public void zoom_out () {
        if ((_old_zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            zoom = _old_zoom - 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Switch zoom classes, then reflect in the UI and tell the application
    */
    private void do_set_zoom (int new_zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        window.remove_css_class (Jorts.Zoom.from_int ( _old_zoom).to_css_class ());
        _old_zoom = new_zoom;
        window.add_css_class (Jorts.Zoom.from_int ( new_zoom).to_css_class ());

        // Adapt headerbar size to avoid weird flickering
        window.view.headerbar.height_request = Jorts.Zoom.from_int (new_zoom).to_ui_size ();

        // Reflect the number in the popover
        window.popover.zoom = new_zoom;

        // Keep it for next new notes
        NoteData.latest_zoom = zoom;

        window.changed ();
    }

    public bool on_key_press_event (uint keyval, uint keycode, Gdk.ModifierType state) {
        if (keyval == Gdk.Key.Control_L || keyval == Gdk.Key.Control_R) {
            debug ("Press!");
            is_control_key_pressed = true;
        }

        return Gdk.EVENT_PROPAGATE;
    }

    public void on_key_release_event (uint keyval, uint keycode, Gdk.ModifierType state) {
        if (keyval == Gdk.Key.Control_L || keyval == Gdk.Key.Control_R) {
            debug ("Release!");
            is_control_key_pressed = false;
        }
    }

    public bool on_scroll (double dx, double dy) {
        debug ("Scroll + Ctrl!");

        if (!is_control_key_pressed) {
            return Gdk.EVENT_PROPAGATE;
        }

        zoom_changed (Zoomkind.from_delta (dy));
        debug ("Go! Zoooommmmm");

        return Gdk.EVENT_PROPAGATE;
    }
}
