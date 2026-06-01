/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* Switch and its explanatory text
*/
public class Jorts.SettingsBox : Gtk.Box {

    public string text {get; construct;}
    public string? description {get; construct;}
    public Gtk.Widget widget {get; construct;}

    public SettingsBox (string text, string? description, Gtk.Widget widget) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            spacing: SPACING_STANDARD,
            text: text,
            description: description,
            widget: widget
        );
    }

    construct {
        widget.halign = Gtk.Align.END;
        widget.hexpand = true;
        widget.valign = Gtk.Align.CENTER;

        var label = new Granite.HeaderLabel (text) {
            mnemonic_widget = widget,
            valign = Gtk.Align.CENTER,  //We need this else labels without descriptions keep a space for it
            hexpand = true,
        };

        if (description != null) {
            label.secondary_text = description;
        };

        append (label);
        append (widget);
    }
}
