/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* Small horizontal box with two toggles
* Allows user to switch between normal and monospace font
* Exposes bool monospace, also sends it via signal
*/
public class Jorts.MonospaceBox : Granite.Box {

    private Gtk.ToggleButton mono_monospace_toggle;

    public bool monospace {
        get { return mono_monospace_toggle.active;}
        set { mono_monospace_toggle.active = value;}
    }

    public MonospaceBox () {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            child_spacing: Spacing.LINKED,
            homogeneous: true,
            hexpand: true,
            margin_start: SPACING_DOUBLE,
            margin_end: SPACING_DOUBLE
        );
    }

    construct {
        ///TRANSLATORS: Both Default and Monospace are togglable buttons, synchronized with each other
        var mono_default_toggle = new Gtk.ToggleButton () {
            action_name = NoteView.ACTION_PREFIX + NoteView.ACTION_TOGGLE_MONO,
            child = new Gtk.Label (_("Default")),
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>m"},
                _("Use default text font")
            ),
            active = true
        };

        mono_monospace_toggle = new Gtk.ToggleButton () {
            action_name = NoteView.ACTION_PREFIX + NoteView.ACTION_TOGGLE_MONO,
            child = new Gtk.Label (_("Monospace")),
                tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>m"},
                _("Use monospaced font")
            )
        };
        mono_monospace_toggle.add_css_class ("monospace");

        append (mono_default_toggle);
        append (mono_monospace_toggle);

        mono_monospace_toggle.bind_property (
            "active",
            mono_default_toggle,
            "active",
            GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.INVERT_BOOLEAN
        );
    }
}
