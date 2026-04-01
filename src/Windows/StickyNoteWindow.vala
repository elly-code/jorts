/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */


/**
* Represents a Sticky Note, with its own settings and content
* There is a View, which contains the text
* There is a Popover, which manages the per-window settings (Tail wagging the dog situation)
* Can be packaged into a noteData file for convenient storage
* Reports to the NoteManager for saving
*/
public class Jorts.StickyNoteWindow : Gtk.ApplicationWindow {

    public Jorts.NoteView view;
    public Popover popover;
    public TextView textview;

    private Jorts.ColorController color_controller;
    public Jorts.ZoomController zoom_controller;
    private Jorts.ScribblyController scribbly_controller;
    private Gtk.EventControllerKey keypress_controller;
    private Gtk.EventControllerScroll scroll_controller;

    public NoteData data {
        owned get {return packaged ();}
        set {load_data (value);}
    }

    public signal void changed ();
    public const string ACTION_PREFIX = "win.";
    public const string ACTION_DELETE = "action_delete";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";

    public static Gee.MultiMap<string, string> action_accelerators;

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_DELETE, action_delete},
        { ACTION_ZOOM_OUT, action_zoom_out},
        { ACTION_ZOOM_DEFAULT, action_zoom_default},
        { ACTION_ZOOM_IN, action_zoom_in},
    };

    public StickyNoteWindow (Jorts.Application app, NoteData data) {
        Intl.setlocale ();
        debug ("[STICKY NOTE] New StickyNoteWindow instance!");
        application = app;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);

        app.set_accels_for_action (ACTION_PREFIX + ACTION_DELETE, {"<Control>W"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_OUT, {"<Control>minus", "<Control>KP_Subtract"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_DEFAULT, {"<Control>equal", "<Control>0", "<Control>KP_0"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_ZOOM_IN, {"<Control>plus", "<Control>KP_Add"});


        color_controller = new Jorts.ColorController (this);
        zoom_controller = new Jorts.ZoomController (this);
        scribbly_controller = new Jorts.ScribblyController (this);

        keypress_controller = new Gtk.EventControllerKey ();
        scroll_controller = new Gtk.EventControllerScroll (VERTICAL) {
            propagation_phase = Gtk.PropagationPhase.CAPTURE
        };

        ((Gtk.Widget)this).add_controller (keypress_controller);
        ((Gtk.Widget)this).add_controller (scroll_controller);

        title = "" + _(" - Jorts");

        // The view has its own titlebar
        titlebar = new Gtk.Grid () {visible = false};

        view = new NoteView ();
        textview = view.textview;
        insert_action_group ("noteview", view.actions);

        // Have shortcuts keep working with the popover open.
        popover = view.popover;
        view.popover.scroll_controller.scroll.connect (zoom_controller.on_scroll);
        view.popover.keypress_controller.key_pressed.connect (zoom_controller.on_key_press_event);
        view.popover.keypress_controller.key_released.connect (zoom_controller.on_key_release_event);

        set_child (view);
        set_focus (view);
        load_data (data);

#if DEVEL
        add_css_class ("devel");
#endif


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        // We need this for Ctr + Scroll. We delegate everything to zoomcontroller
        keypress_controller.key_pressed.connect (zoom_controller.on_key_press_event);
        keypress_controller.key_released.connect (zoom_controller.on_key_release_event);
        scroll_controller.scroll.connect (zoom_controller.on_scroll);

        debug ("Built UI. Lets do connects and binds");

        // Save when title or text have changed
        view.editablelabel.changed.connect (on_editable_changed);
        view.textview.buffer.changed.connect (has_changed);

        popover.theme_changed.connect (color_controller.on_color_changed);

        // Use the color theme of this sticky note when focused
        this.notify["is-active"].connect (color_controller.on_focus_changed);

        // Respect animation settings for showing ui elements
        if (Application.gtk_settings.gtk_enable_animations && (!Application.gsettings.get_boolean ("hide-bar"))) {
            show.connect_after (delayed_show);

        } else {
            bind_hidebar ();
        }
    }

        /********************************************/
        /*                  METHODS                 */
        /********************************************/

    /**
    * Show Actionbar shortly after the window is shown
    * This is more for the Aesthetic
    */
    private void delayed_show () {
        Timeout.add_once (250, bind_hidebar);
        show.disconnect (delayed_show);
    }

    private void bind_hidebar () {
        Application.gsettings.bind (
            "hide-bar",
            view.actionbar.actionbar,
            "revealed",
            SettingsBindFlags.INVERT_BOOLEAN);
    }

    /**
    * Simple handler for the EditableLabel
    */
    private void on_editable_changed () {
        title = view.editablelabel.text + _(" - Jorts");
#if DEVEL
        title += _(" (Development)");
#endif
        changed ();
    }

    /**
    * Package the note into a NoteData and pass it back.
    * Used by NoteManager to pass all informations conveniently for storage
    */
    public NoteData packaged () {
        debug ("Packaging into a noteData…");

        int this_width ; int this_height;
        this.get_default_size (out this_width, out this_height);

        var data = new NoteData () {
            title = view.title,
            theme = popover.color,
            content = view.content,
            monospace = popover.monospace,
            zoom = zoom_controller.zoom,
            width = this_width,
            height = this_height
        };

        return data;
    }

    /**
    * Propagate the content of a NoteData into the various UI elements. Used when creating a new window
    */
    private void load_data (NoteData data) {
        debug ("Loading noteData…");

        set_default_size (data.width, data.height);
        view.title = data.title;
        title = view.title + _(" - Jorts");
        view.content = data.content;

        color_controller.theme = data.theme;
        zoom_controller.zoom = data.zoom;
        popover.monospace = data.monospace;
    }

    private void has_changed () {changed ();}
    private void action_delete () {((Jorts.Application)this.application).manager.delete_note (this); this.destroy ();}
    private void action_zoom_out () {zoom_controller.zoom_out ();}
    private void action_zoom_default () {zoom_controller.zoom_default ();}
    private void action_zoom_in () {zoom_controller.zoom_in ();}
}
