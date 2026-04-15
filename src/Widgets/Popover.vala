/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* The popover menu to tweak individual notes
* Contains a setting for color, one for monospace font, one for zoom
*/
public class Jorts.Popover : Gtk.Popover {

    public Gtk.EventControllerKey keypress_controller;
    public Gtk.EventControllerScroll scroll_controller;

    private Jorts.ColorBox color_box;
    private Jorts.MonospaceBox monospace_box;
    private Jorts.ZoomBox font_size_box;

    public Themes color {
        get {return color_box.color;}
        set {color_box.color = value;}
    }

    public bool monospace {
        get {return monospace_box.monospace;}
        set {on_monospace_changed (value);}
    }

    public int zoom { set {font_size_box.zoom = value;}}
    public signal void theme_changed (Jorts.Themes selected);

    public Popover () {
        Object (
            position: Gtk.PositionType.TOP,
            halign: Gtk.Align.END
        );
    }

    static construct {
        add_binding_action (Gdk.Key.plus, Gdk.ModifierType.CONTROL_MASK, ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_IN, null);
        add_binding_action (Gdk.Key.equal, Gdk.ModifierType.CONTROL_MASK, ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_DEFAULT, null);    
        add_binding_action (48, Gdk.ModifierType.CONTROL_MASK, ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_DEFAULT, null);    
        add_binding_action (Gdk.Key.minus, Gdk.ModifierType.CONTROL_MASK, ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_OUT, null);

        add_binding_action (Gdk.Key.n, Gdk.ModifierType.CONTROL_MASK, NoteManager.ACTION_PREFIX + NoteManager.ACTION_NEW, null);
        add_binding_action (Gdk.Key.w, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_DELETE, null);
        add_binding_action (Gdk.Key.l, Gdk.ModifierType.CONTROL_MASK, NoteView.ACTION_PREFIX + NoteView.ACTION_FOCUS_TITLE, null);
        add_binding_action (Gdk.Key.g, Gdk.ModifierType.CONTROL_MASK, NoteView.ACTION_PREFIX + NoteView.ACTION_SHOW_MENU, null);
        add_binding_action (Gdk.Key.o, Gdk.ModifierType.CONTROL_MASK, NoteView.ACTION_PREFIX + NoteView.ACTION_SHOW_MENU, null);
        add_binding_action (Gdk.Key.m, Gdk.ModifierType.CONTROL_MASK, NoteView.ACTION_PREFIX + NoteView.ACTION_TOGGLE_MONO, null);    

        add_binding_action (Gdk.Key.F12, Gdk.ModifierType.SHIFT_MASK, TextView.ACTION_PREFIX + TextView.ACTION_TOGGLE_LIST, null);
   }

    construct {
#if DEVEL
        autohide = false;
#endif
        var view = new Gtk.Box (VERTICAL, SPACING_DOUBLE) {
            margin_top = SPACING_DOUBLE,
            margin_bottom = SPACING_DOUBLE
        };

        color_box = new Jorts.ColorBox ();
        monospace_box = new Jorts.MonospaceBox ();
        font_size_box = new Jorts.ZoomBox ();

        view.append (color_box);
        view.append (monospace_box);
        view.append (font_size_box);

        child = view;

        // Allow scrolling shenanigans from popover
        keypress_controller = new Gtk.EventControllerKey ();
        scroll_controller = new Gtk.EventControllerScroll (VERTICAL) {
            propagation_phase = Gtk.PropagationPhase.CAPTURE
        };

        ((Gtk.Widget)this).add_controller (keypress_controller);
        ((Gtk.Widget)this).add_controller (scroll_controller);

        // Propagate settings changes to the higher level
        color_box.theme_changed.connect ((theme) => {theme_changed (theme);});
    }

    /**
    * Switches the .monospace class depending on the note setting
    */
    private void on_monospace_changed (bool monospace) {
        debug ("Updating monospace to %s".printf (monospace.to_string ()));
        monospace_box.monospace = monospace;
        Jorts.NoteData.latest_mono = monospace;
    }
}
