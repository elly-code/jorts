/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

 public class Jorts.PreferencesView : Gtk.Box {
    //public Gtk.Button reset_button;
    private Granite.Toast toast;
    public Gtk.Button close_button;

    construct {
        orientation = VERTICAL;
        margin_top = 10;
        margin_bottom = 10;
        margin_start = 10;
        margin_end = 10;

        var overlay = new Gtk.Overlay ();
        append (overlay);

            toast = new Granite.Toast (_("Request to system sent"));
            overlay.add_overlay (toast);

            // the box with all the settings
            var settingsbox = new Gtk.Box (VERTICAL, 15) {
                margin_top = 5,
                margin_start = 5,
                margin_end = 5,
                hexpand = true,
                vexpand = true,
                valign = Gtk.Align.START
            };


                /***************************************/
                /*               lists                 */
                /***************************************/

                var lists_box = new Gtk.Box (HORIZONTAL, 5);

                var list_entry = new Gtk.Entry () {
                    halign = Gtk.Align.END,
                    hexpand = false,
                    valign = Gtk.Align.CENTER,
                    max_length = 6,
                    max_width_chars = 6
                };

                var list_label = new Granite.HeaderLabel (_("List item prefix")) {
                    mnemonic_widget = list_entry,
                    secondary_text = _("If left empty, the list button will be hidden"),
                    hexpand = true
                };

                lists_box.append (list_label);
                lists_box.append (list_entry);

                Application.gsettings.bind (
                    "list-item-start",
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
                    "scribbly-mode-active");

                settingsbox.append (scribbly_box);


                /*************************************************/
                /*               hidebar Toggle                  */
                /*************************************************/

                var hidebar_box = new Jorts.SettingsSwitch (
                    ///TRANSLATORS: Instead of bottom bar you can also use "Action bar" or "button bar"
                    _("Hide bottom bar"),
                    _("Keyboard shortcuts will still function (Ctrl+T)"),
                    "hide-bar");

                settingsbox.append (hidebar_box);


                /****************************************************/
                /*               Autostart Request                  */
                /****************************************************/
#if !WINDOWS
                var both_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5) {
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

                var autostart_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);

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
                margin_start = 5,
                margin_end = 5,
                valign = Gtk.Align.END,
                hexpand = true,
                vexpand = false
            };

            // Monies?
            var support_button = new Gtk.LinkButton.with_label (
                Jorts.Constants.DONATE_LINK,
                _("Support us!")
            );
            actionbar.start_widget = support_button;

            close_button = new Gtk.Button () {
                width_request = 96,
                label = _("Close"),
                tooltip_markup = Granite.markup_accel_tooltip (
                    {"<Alt>F4"},
                    _("Close preferences")
                )
            };

            actionbar.end_widget = close_button;

            append (settingsbox);
            append (actionbar);
    }
}
