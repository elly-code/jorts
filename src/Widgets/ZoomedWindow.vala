/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* A
*/
 public class Jorts.ZoomedWindow : Gtk.Widget {

    // Scroll handers need that information to decide whether to act
    private static bool is_control_key_pressed = false;

    private Gtk.EventControllerKey keypress_controller;
    private Gtk.EventControllerScroll scroll_controller;
    private Gtk.GestureZoom gesturezoom_controller;

    // Avoid setting this unless it is to restore a specific value, do_set_zoom does not check input
    private int _old_zoom;
    public int zoom {
        get {return _old_zoom;}
        set {do_set_zoom (value);}
    }

    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "zoomed_window.";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";

    public static Gee.MultiMap<string, string> action_accelerators;

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_ZOOM_OUT, zoom_out},
        { ACTION_ZOOM_DEFAULT, zoom_default},
        { ACTION_ZOOM_IN, zoom_in}
    };

    class construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    private Zoomable? _child;
    public Zoomable? child {
        get {
            return _child;
        }

        set {
            if (value != null && value.get_parent () != null) {
                critical ("Tried to set a widget as child that already has a parent.");
                return;
            }

            if (_child != null) {
                _child.unparent ();
            }

            _child = value;

            if (_child != null) {
                _child.set_parent (this);
            }
        }
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);

        unowned var app = ((Gtk.Application) GLib.Application.get_default ());
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_OUT, {"<Control>minus", "<Control>KP_Subtract"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_DEFAULT, {"<Control>equal", "<Control>0", "<Control>KP_0"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_IN, {"<Control>plus", "<Control>KP_Add"});

        keypress_controller = new Gtk.EventControllerKey ();
        scroll_controller = new Gtk.EventControllerScroll (VERTICAL) {
            propagation_phase = Gtk.PropagationPhase.CAPTURE
        };
        gesturezoom_controller = new Gtk.GestureZoom ();

        add_controller (keypress_controller);
        add_controller (scroll_controller);
        add_controller (gesturezoom_controller);

        keypress_controller.key_pressed.connect (on_key_press_event);
        keypress_controller.key_released.connect (on_key_release_event);
        scroll_controller.scroll.connect (on_scroll);
        gesturezoom_controller.scale_changed.connect (on_pinch);
    }

    /**
    * Handler. Wraps a zoom enum into the correct function-
    */
    public void zoom_changed (Jorts.ZoomType zoomtype) {
        debug ("Zoom changed!");
        switch (zoomtype) {
            case ZoomType.ZOOM_IN:              zoom_in (); return;          // vala-lint=double-spaces
            case ZoomType.DEFAULT_ZOOM:         zoom_default (); return;     // vala-lint=double-spaces
            case ZoomType.ZOOM_OUT:             zoom_out (); return;         // vala-lint=double-spaces
            default:                            return;                      // vala-lint=double-spaces
        }
    }

    /**
    * Wrapper to check an increase doesnt go above limit
    */
    public void zoom_in () {
        if ((_old_zoom + 20) <= ZOOM_MAX) {
            zoom = _old_zoom + 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    public void zoom_default () {
        if (_old_zoom != DEFAULT_ZOOM ) {
            zoom = DEFAULT_ZOOM;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Wrapper to check an increase doesnt go below limit
    */
    public void zoom_out () {
        if ((_old_zoom - 20) >= ZOOM_MIN) {
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
        remove_css_class (Jorts.Zoom.from_int ( _old_zoom).to_css_class ());
        _old_zoom = new_zoom;
        add_css_class (Jorts.Zoom.from_int ( new_zoom).to_css_class ());

        _child.on_zoom_changed (new_zoom);
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

        zoom_changed (ZoomType.from_delta (dy));
        debug ("Go! Zoooommmmm");

        return Gdk.EVENT_STOP;
    }


    public void on_pinch (double dy) {
        debug ("Pinch!");

        // Delta is at 1 at rest
        // We need to invert the direction because pinch isnt like scroll
        zoom_changed (ZoomType.from_delta (- dy - 1));
        debug ("Go! Zoooommmmm");

        //return Gdk.EVENT_STOP;
    }

    ~ZoomedWindow () {
        if (_child != null) {
            _child.unparent ();
        }

        debug ("Destroyed");
    }
}
