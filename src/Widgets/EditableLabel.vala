/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* A subclass of Gtk.EditableLabel, incorporating some conveniences
*/
public class Jorts.EditableLabel : Granite.Bin {

    private const string STYLE_MONOSPACE = "monospace";
    private Gtk.EditableLabel editablelabel;
    public signal void changed ();

    public string text {
        owned get {return editablelabel.text;}
        set {editablelabel.text = value;}
    }

    public bool editing {
        get {return editablelabel.editing;}
        set {editablelabel.editing = value;}
    }

    public bool monospace {
        get {return STYLE_MONOSPACE in this.css_classes;}
        set {mono_set (value);}
    }

    construct {
        editablelabel = new Gtk.EditableLabel ("") {
            xalign = 0.5f,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>L"},
                //TRANSLATORS: Tooltip when a user hovers the title of a sticky note. You are not constrained by space
                _("Click to edit the title")
            )
        };
        child = editablelabel;

        editablelabel.changed.connect (repeat_change);
    }

    /**
    * Not using a lambda as they tend to memory leak
    */
    private void repeat_change () {changed ();}

    private void mono_set (bool if_mono) {
        if (if_mono) {
            this.add_css_class (STYLE_MONOSPACE);
            return;
        }
        remove_css_class (STYLE_MONOSPACE);
    }

    ~EditableLabel () {
        debug ("Destroyed");
    }
}
