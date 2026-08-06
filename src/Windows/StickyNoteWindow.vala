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

    private Jorts.ZoomedWindow zoomed_window;
    private Jorts.ColorController color_controller;
    private Jorts.ScribblyController scribbly_controller;


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
        debug ("New StickyNoteWindow instance!");
        application = app;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);
        app.set_accels_for_action (ACTION_PREFIX + ACTION_DELETE, {"<Control>W"});

        color_controller = new Jorts.ColorController (this);
        scribbly_controller = new Jorts.ScribblyController (this);

        // The view has its own titlebar
        titlebar = new Gtk.Grid () {visible = false};

        view = new NoteView ();

        zoomed_window = new ZoomedWindow () {
            child = view
        };

        textview = view.textview;
        popover = view.popover;

        insert_action_group ("noteview", view.actions);
        insert_action_group ("textview", textview.actions);
        insert_action_group ("zoomed_window", zoomed_window.actions);

        set_child (zoomed_window);
        set_focus (zoomed_window);
        load_data (data);

#if DEVEL
        add_css_class (STYLE_DEVEL);
#endif
        add_css_class (STYLE_ANIMATED);


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        // Save when title or text have changed
        view.editablelabel.changed.connect (on_editable_changed);
        view.textview.buffer.changed.connect (has_changed);
        popover.theme_changed.connect (color_controller.on_color_changed);
        zoomed_window.notify ["zoom"].connect (has_changed);
    }

    /**
    * Simple handler for the EditableLabel
    */
    private void on_editable_changed () {
        //TRANSLATORS: "%s" is replaced by a specific sticky note title
        //Ex: "To remember - Jorts"
        //The text is shown in overviews of all open windows, accompanying the window
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
            zoom = zoomed_window.zoom,
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
        zoomed_window.zoom = data.zoom;
        view.monospace = data.monospace;
    }

    public void has_changed () {
        application.activate_action (Application.ACTION_SAVE, null);
    }

    private void action_delete () {
        Application.note_manager.delete_note (this);
    }

    ~StickyNoteWindow () {
        debug ("Destroying %s", view.title);
        view.editablelabel.changed.disconnect (on_editable_changed);
        view.textview.buffer.changed.disconnect (has_changed);
        popover.theme_changed.disconnect (color_controller.on_color_changed);

        zoomed_window = null;
        view = null;
        popover = null;
        textview = null;

        color_controller = null;
        scribbly_controller = null;
        application = null;
    }
}
