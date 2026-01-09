/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

 /**
* Horizontal box with a +, label, and -, representing zoom controls
* Gives off zoom_changed signal to tell the user has clicked one of three
* The signal transmits a Jorts.Zoomkind Enum
*/
public class Jorts.ZoomBox : Gtk.Box {

    private Gtk.Button zoom_default_button;
    private int _zoom = 100;

    public int zoom {
        get { return _zoom;}
        set {
            _zoom = value;
            //TRANSLATORS: %d is replaced by a number. Ex: 100, to display 100%
            //It must stay as "%d" in the translation so the app can replace it with the current zoom level.
            var label = _("%d%%").printf (value);
            zoom_default_button.set_label (label);
        }
    }

    public signal void zoom_changed (Jorts.Zoomkind zoomkind);

    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        homogeneous = true;
        hexpand = true;
        margin_start = 10;
        margin_end = 10;

        ///TRANSLATORS: These are displayed on small linked buttons in a menu. User can click them to change zoom
        var zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>minus", "<Control>KP_Subtract"},
                _("Zoom out")
                )
            };

        zoom_default_button = new Gtk.Button () {
            tooltip_markup = Granite.markup_accel_tooltip (
                { "<Control>equal", "<Control>0", "<Control>KP_0" },
                _("Default zoom level")
                )
            };

        var zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic") {
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>plus", "<Control>KP_Add"},
                _("Zoom in")
                )
            };

        append (zoom_out_button);
        append (zoom_default_button);
        append (zoom_in_button);
        add_css_class (Granite.STYLE_CLASS_LINKED);

        // Emit a signal when a button is toggled that will be picked by StickyNoteWindow
        zoom_out_button.clicked.connect (zoom_out);
        zoom_default_button.clicked.connect (zoom_default);
        zoom_in_button.clicked.connect (zoom_in);
    }

    private void zoom_out () {
        zoom_changed (Zoomkind.ZOOM_OUT);
    }

    private void zoom_default () {
        zoom_changed (Zoomkind.DEFAULT_ZOOM);
    }

    private void zoom_in () {
        zoom_changed (Zoomkind.ZOOM_IN);
    }
}
