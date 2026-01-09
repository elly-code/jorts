/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/*

/**
* I just dont wanna rewrite the same button over and over
*/
public class Jorts.ColorPill : Gtk.CheckButton {

        public Jorts.Themes color { get; construct; }

        public ColorPill (Themes color, Gtk.CheckButton? group_member = null) {
            Object (
                color: color,
                group: group_member
            );
        }

        construct {
            add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);

            //if (color == Themes.IDK) {
            //    add_css_class ("auto");

            //} else {
                add_css_class (color.to_css_class ());
            //}

            tooltip_text = color.to_nicename ();

            action_name = "popover.prefers-accent-color";
            action_target = new Variant.int32 (color);
        }
}
