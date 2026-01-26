/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/**
* Represents a Sticky Note, with its own settings and content
* There is a View, which contains the text
* There is a Popover, which manages the per-window settings (Tail wagging the dog situation)
* Can be packaged into a noteData file for convenient storage
* Reports to the NoteManager for saving
*/
public class Jorts.StickyNoteWindow : Gtk.Window {

    public Jorts.NoteView view;
    public Popover popover;
    public TextView textview;

    private Jorts.ColorController color_controller;
    public Jorts.ZoomController zoom_controller;
    private Jorts.ScribblyController scribbly_controller;

    public NoteData data {
        owned get { return packaged ();}
        set { load_data (value);}
    }

    public signal void changed ();

    private Gtk.EventControllerKey keypress_controller;
    private Gtk.EventControllerScroll scroll_controller;

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_SHOW_EMOJI = "action_show_emoji";
    public const string ACTION_SHOW_MENU = "action_show_menu";
    public const string ACTION_FOCUS_TITLE = "action_focus_title";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";
    public const string ACTION_TOGGLE_MONO = "action_toggle_mono";
    public const string ACTION_DELETE = "action_delete";
    public const string ACTION_TOGGLE_LIST = "action_toggle_list";

    public static Gee.MultiMap<string, string> action_accelerators;

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_DELETE, action_delete},
        { ACTION_SHOW_EMOJI, action_show_emoji},
        { ACTION_SHOW_MENU, action_show_menu},
        { ACTION_FOCUS_TITLE, action_focus_title},
        { ACTION_ZOOM_OUT, action_zoom_out},
        { ACTION_ZOOM_DEFAULT, action_zoom_default},
        { ACTION_ZOOM_IN, action_zoom_in},
        { ACTION_TOGGLE_MONO, action_toggle_mono},
        { ACTION_TOGGLE_LIST, action_toggle_list},
    };

    public StickyNoteWindow (Jorts.Application app, NoteData data) {
        Intl.setlocale ();
        debug ("[STICKY NOTE] New StickyNoteWindow instance!");
        application = app;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);

        color_controller = new Jorts.ColorController (this);
        zoom_controller = new Jorts.ZoomController (this);
        scribbly_controller = new Jorts.ScribblyController (this);

        keypress_controller = new Gtk.EventControllerKey ();
        scroll_controller = new Gtk.EventControllerScroll (VERTICAL) {
            propagation_phase = Gtk.PropagationPhase.CAPTURE
        };

        ((Gtk.Widget)this).add_controller (keypress_controller);
        ((Gtk.Widget)this).add_controller (scroll_controller);

        add_css_class ("rounded");
        title = "" + _(" - Jorts");


        /*****************************************/
        /*              HEADERBAR                */
        /*****************************************/

        // No
        titlebar = new Gtk.Grid () {visible = false};

        view = new NoteView ();
        textview = view.textview;

        popover = new Jorts.Popover (this);
        view.menu_button.popover = popover;

        set_child (view);
        set_focus (view);

        /****************************************/
        /*              LOADING                 */
        /****************************************/

        load_data (data);

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
        popover.zoom_changed.connect (zoom_controller.zoom_changed);
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
        view.editablelabel.text = data.title;
        title = view.editablelabel.text + _(" - Jorts");
        view.textview.buffer.text = data.content;

        color_controller.theme = data.theme;
        zoom_controller.zoom = data.zoom;
        popover.monospace = data.monospace;
    }

    private void has_changed () {changed ();}

    private void action_focus_title () {view.action_focus_title ();}
    private void action_show_emoji () {view.action_show_emoji ();}
    private void action_show_menu () {view.action_show_menu ();}
    private void action_delete () {((Jorts.Application)this.application).manager.delete_note (this); this.destroy ();}
    private void action_toggle_mono () {popover.monospace = !popover.monospace;}
    private void action_toggle_list () {view.action_toggle_list ();}

    private void action_zoom_out () {zoom_controller.zoom_out ();}
    private void action_zoom_default () {zoom_controller.zoom_default ();}
    private void action_zoom_in () {zoom_controller.zoom_in ();}
}
