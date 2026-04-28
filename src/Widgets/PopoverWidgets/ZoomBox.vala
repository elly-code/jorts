/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

 /**
* Horizontal box with a +, label, and -, representing zoom controls
* Gives off zoom_changed signal to tell the user has clicked one of three
* The signal transmits a Jorts.ZoomType Enum
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

    public ZoomBox () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: SPACING_STANDARD,
            //child_spacing: Spacing.LINKED,
            homogeneous: true,
            hexpand: true,
            margin_start: SPACING_DOUBLE,
            margin_end: SPACING_DOUBLE
        );
    }

    construct {
        ///TRANSLATORS: These are displayed on small linked buttons in a menu. User can click them to change zoom
        var zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic") {
            action_name = ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_OUT,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>minus", "<Control>KP_Subtract"},
                _("Zoom out")
                )
            };

        zoom_default_button = new Gtk.Button () {
            action_name = ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_DEFAULT,
            tooltip_markup = Granite.markup_accel_tooltip (
                { "<Control>equal", "<Control>0", "<Control>KP_0" },
                _("Default zoom level")
                )
            };

        var zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic") {
            action_name = ZoomController.ACTION_PREFIX + ZoomController.ACTION_ZOOM_IN,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>plus", "<Control>KP_Add"},
                _("Zoom in")
                )
        };

        append (zoom_out_button);
        append (zoom_default_button);
        append (zoom_in_button);
    }
}
