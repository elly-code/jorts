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

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_DELETE = "action_delete";

    public static Gee.MultiMap<string, string> action_accelerators;
    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_DELETE, action_delete}
    };

    public StickyNoteWindow (Jorts.Application app, NoteData data) {
        Intl.setlocale ();
        debug ("[STICKY NOTE] New StickyNoteWindow instance!");
        application = app;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);
        app.set_accels_for_action (ACTION_PREFIX + ACTION_DELETE, {"<Control>W"});

        color_controller = new Jorts.ColorController (this);
        zoom_controller = new Jorts.ZoomController (this);
        scribbly_controller = new Jorts.ScribblyController (this);

        keypress_controller = new Gtk.EventControllerKey ();
        scroll_controller = new Gtk.EventControllerScroll (VERTICAL) {
            propagation_phase = Gtk.PropagationPhase.CAPTURE
        };

        ((Gtk.Widget)this).add_controller (keypress_controller);
        ((Gtk.Widget)this).add_controller (scroll_controller);

        // The view has its own titlebar
        titlebar = new Gtk.Grid () {visible = false};

        view = new NoteView ();
        textview = view.textview;
        insert_action_group ("noteview", view.actions);
        insert_action_group ("textview", textview.actions);
        insert_action_group ("zoom_controller", zoom_controller.actions);

        // Have shortcuts keep working with the popover open.
        popover = view.popover;
        view.popover.scroll_controller.scroll.connect (zoom_controller.on_scroll);
        view.popover.keypress_controller.key_pressed.connect (zoom_controller.on_key_press_event);
        view.popover.keypress_controller.key_released.connect (zoom_controller.on_key_release_event);

        set_child (view);
        set_focus (view);
        load_data (data);

#if DEVEL
        add_css_class (STYLE_DEVEL);
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
            KEY_HIDEBAR,
            view.actionbar.actionbar,
            "revealed",
            SettingsBindFlags.INVERT_BOOLEAN);
    }

    /**
    * Simple handler for the EditableLabel
    */
    private void on_editable_changed () {
#if DEVEL
        title = _("%s - Jorts (Development)").printf (view.title);
#else
        title = _("%s - Jorts").printf (view.title);
#endif
        has_changed ();
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

#if DEVEL
        title = _("%s - Jorts (Development)").printf (view.title);
#else
        title = _("%s - Jorts").printf (view.title);
#endif

        view.content = data.content;

        color_controller.theme = data.theme;
        zoom_controller.zoom = data.zoom;
        view.monospace = data.monospace;
    }

    public void has_changed () {
        application.activate_action (NoteManager.ACTION_SAVE, null);
    }
    private void action_delete () {((Jorts.Application)this.application).note_manager.delete_note (this); this.destroy ();}
}
