/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* A subclass of Gtk.EditableLabel, incorporating some conveniences
*/
public class Jorts.EditableLabel : Granite.Bin {

    private Gtk.EditableLabel editablelabel;
    public signal void changed ();

    public string text {
        owned get { return editablelabel.text;}
        set { editablelabel.text = value;}
    }

    public bool editing {
        get { return editablelabel.editing;}
        set { editablelabel.editing = value;}
    }

    public bool monospace {
        get { return "monospace" in this.css_classes;}
        set { mono_set (value);}
    }

    construct {
        editablelabel = new Gtk.EditableLabel ("") {
            xalign = 0.5f,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>L"},
                _("Click to edit the title")
            )
        };
        editablelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        child = editablelabel;

        editablelabel.changed.connect (repeat_change);
    }

    /**
    * Not using a lambda as they tend to memory leak
    */
    private void repeat_change () {changed ();}

    private void mono_set (bool if_mono) {
        if (if_mono) {
            this.add_css_class ("monospace");

        } else {
            if ("monospace" in this.css_classes) {
                this.remove_css_class ("monospace");
            }
        }
    }
}
