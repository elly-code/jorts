/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

 public class Jorts.PreferencesView : Granite.Bin {

    private Granite.Toast toast;
    public Gtk.Button close_button;

    construct {
        var overlay = new Gtk.Overlay ();
        child = overlay;

        toast = new Granite.Toast (_("Request to system sent"));
        overlay.add_overlay (toast);

        var prefview = new Gtk.Box (Gtk.Orientation.VERTICAL, SPACING_DOUBLE) {
            margin_start = SPACING_TRIPLE,
            margin_end = SPACING_TRIPLE,
            margin_top = SPACING_DOUBLE,
            margin_bottom = SPACING_DOUBLE,
            hexpand = true,
            vexpand = true
        };
        overlay.child = prefview;

        // the box with all the settings
        var settingsbox = new Gtk.Box (VERTICAL, SPACING_DOUBLE) {
            hexpand = true,
            vexpand = true,
            valign = Gtk.Align.START
        };


                /***************************************/
                /*               lists                 */
                /***************************************/

                var list_entry = new Gtk.Entry () {
                    halign = Gtk.Align.END,
                    hexpand = false,
                    valign = Gtk.Align.CENTER,
                    max_length = 6,
                    max_width_chars = 6
                };

                list_entry.secondary_icon_name = "view-refresh-symbolic";
                list_entry.secondary_icon_tooltip_text = _("Reset to default");
                list_entry.icon_press.connect (on_reset_prefix);

                var list_label = new Granite.HeaderLabel (_("List item prefix")) {
                    mnemonic_widget = list_entry,
                    secondary_text = _("If left empty, the list button will be hidden"),
                    hexpand = true
                };

                var lists_box = new Gtk.Box (HORIZONTAL, SPACING_STANDARD);
                lists_box.append (list_label);
                lists_box.append (list_entry);

                Application.gsettings.bind (KEY_LIST,
                    list_entry, "text",
                    SettingsBindFlags.DEFAULT);

                settingsbox.append (lists_box);


                /*************************************************/
                /*              scribbly Toggle                  */
                /*************************************************/

                debug ("Built UI. Lets do connects and binds");

                var scribbly_box = new Jorts.SettingsSwitch (
                    _("Scribble mode"),
                    _("Scribble text of unfocused notes (Ctrl+H)"),
                    KEY_SCRIBBLY);

                settingsbox.append (scribbly_box);


                /*************************************************/
                /*               hidebar Toggle                  */
                /*************************************************/

                var hidebar_box = new Jorts.SettingsSwitch (
                    ///TRANSLATORS: Instead of bottom bar you can also use "Action bar" or "button bar"
                    _("Hide bottom bar"),
                    _("Keyboard shortcuts will still function (Ctrl+T)"),
                    KEY_HIDEBAR);

                settingsbox.append (hidebar_box);


                /****************************************************/
                /*               Autostart Request                  */
                /****************************************************/

// Windows do not have libportal, so we have to skip the autostart options
#if !WINDOWS
                var both_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, SPACING_STANDARD) {
                    halign = Gtk.Align.FILL
                };

                ///TRANSLATORS: Button to autostart the application
                var set_autostart = new Gtk.Button () {
                    label = _("Enable"),
                    valign = Gtk.Align.CENTER
                };

                set_autostart.clicked.connect (() => {
                    Jorts.Utils.autostart_set ();
                    toast.send_notification ();
                });

                ///TRANSLATORS: Button to remove the autostart for the application
                var remove_autostart = new Gtk.Button () {
                    label = _("Disable"),
                    valign = Gtk.Align.CENTER
                };

                remove_autostart.clicked.connect (() => {
                    Jorts.Utils.autostart_remove ();
                    toast.send_notification ();
                });

                both_buttons.append (set_autostart);
                both_buttons.append (remove_autostart);

                var autostart_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, SPACING_STANDARD);

                var autostart_label = new Granite.HeaderLabel (_("Automatically start Jorts")) {
                    mnemonic_widget = both_buttons,
                    hexpand = true,
                    secondary_text = _("Show your sticky notes when you log in")
                };

                autostart_box.append (autostart_label);
                autostart_box.append (both_buttons);
                settingsbox.append (autostart_box);
#endif
            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.CenterBox () {
                valign = Gtk.Align.END,
                hexpand = true,
                vexpand = false
            };

            // Monies?
            actionbar.start_widget = new Gtk.LinkButton.with_label (
                DONATE_LINK,
                _("Support us!")
            );

            actionbar.end_widget = new Gtk.Button () {
                action_name = "window.close",
                width_request = 96,
                label = _("Close"),
                tooltip_markup = Granite.markup_accel_tooltip (
                    {"<Alt>F4"},
                    _("Close preferences")
                )
            };

            prefview.append (settingsbox);
            prefview.append (actionbar);
    }

    private void on_reset_prefix (Gtk.EntryIconPosition icon_pos) {
        Application.gsettings.reset (KEY_LIST);
    }
}
