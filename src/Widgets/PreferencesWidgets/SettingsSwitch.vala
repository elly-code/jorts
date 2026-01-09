/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/**
* Switch and its explanatory text
*/
public class Jorts.SettingsSwitch : Gtk.Box {

    public SettingsSwitch (string name, string explanation, string key) {
        orientation = Gtk.Orientation.HORIZONTAL;
        spacing = 5;

        var toggle = new Gtk.Switch () {
            halign = Gtk.Align.END,
            hexpand = true,
            valign = Gtk.Align.CENTER,
        };

        var label = new Granite.HeaderLabel (name) {
            mnemonic_widget = toggle,
            secondary_text = explanation
        };

        append (label);
        append (toggle);

        Application.gsettings.bind (
            key,
            toggle, "active",
            SettingsBindFlags.DEFAULT);
    }
}
