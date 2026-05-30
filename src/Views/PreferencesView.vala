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
        var prefview = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            margin_start = SPACING_DOUBLE,
            margin_end = SPACING_DOUBLE,
            margin_top = SPACING_DOUBLE,
            margin_bottom = SPACING_DOUBLE,
            hexpand = true,
            vexpand = true
        };

        var overlay = new Gtk.Overlay () {
            child = prefview
        };

        toast = new Granite.Toast (_("Request to system sent"));
        overlay.add_overlay (toast);
        child = overlay;

        // the box with all the settings
        var settingsbox = new Gtk.Box (VERTICAL, SPACING_DOUBLE) {
            hexpand = true,
            vexpand = true,
            valign = Gtk.Align.START
        };

#if FLATHUB
        settingsbox.spacing = 0;
#endif

            /***************************************/
            /*               lists                 */
            /***************************************/

            var list_dropdown = new Gtk.DropDown.from_strings (ListPrefix.ALL) {
                halign = Gtk.Align.END,
                hexpand = false,
                valign = Gtk.Align.CENTER
            };

            list_dropdown.selected = Application.gsettings.get_enum (KEY_LIST);
            list_dropdown.notify["selected"].connect (() => {
                Application.gsettings.set_enum (KEY_LIST, (int)list_dropdown.selected);
            });

            var lists_box = new SettingsBox (
                _("List item prefix"),
                _("If disabled, the toggle list button will be hidden"),
                list_dropdown);

            settingsbox.append (lists_box);


            /*************************************************/
            /*              scribbly Toggle                  */
            /*************************************************/

            debug ("Built UI. Lets do connects and binds");

            var scribbly_toggle = new Gtk.Switch ();
            Application.gsettings.bind (KEY_SCRIBBLY,
                scribbly_toggle, "active",
                GLib.SettingsBindFlags.DEFAULT);

            var scribbly_box = new Jorts.SettingsBox (_
                ("Scribble mode"),
                _("Scribble text of unfocused notes (Ctrl+H)"),
                scribbly_toggle);

            settingsbox.append (scribbly_box);


            /*************************************************/
            /*               hidebar Toggle                  */
            /*************************************************/
            var hidebar_toggle = new Gtk.Switch ();
            Application.gsettings.bind (KEY_HIDEBAR,
                hidebar_toggle, "active",
                GLib.SettingsBindFlags.DEFAULT);

            var hidebar_box = new Jorts.SettingsBox (
                //TRANSLATORS: Instead of bottom bar you can also use "Action bar" or "button bar"
                _("Hide bottom bar"),
                _("Keyboard shortcuts will still function (Ctrl+T)"),
                hidebar_toggle);

            settingsbox.append (hidebar_box);



            /***********************************************/
            /*               Restore_last                  */
            /***********************************************/

            //TRANSLATORS: Button to restore sticky notes the application
            var restore_button = new Gtk.Button () {
                label = _("Restore"),
                action_name = Application.ACTION_PREFIX + Application.ACTION_RESTORE_LAST
            };

            var restore_box = new SettingsBox (
                _("Restore last deleted note"),
                _("Restore the last deleted sticky note (Ctrl+R)"),
                restore_button);

            settingsbox.append (restore_box);


            /****************************************************/
            /*               Autostart Request                  */
            /****************************************************/

// Windows do not have libportal, so we have to skip the autostart options
#if !WINDOWS
            var both_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, SPACING_STANDARD) {
                halign = Gtk.Align.FILL
            };

            //TRANSLATORS: Button to autostart the application
            var set_autostart = new Gtk.Button () {
                label = _("Enable"),
                valign = Gtk.Align.CENTER
            };

            set_autostart.clicked.connect (() => {
                Jorts.Utils.autostart_set ();
                toast.send_notification ();
            });

            //TRANSLATORS: Button to remove the autostart for the application
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

            var autostart_box = new SettingsBox (
                _("Automatically start Jorts"),
                _("Show your sticky notes when you log in"),
                both_buttons);

            settingsbox.append (autostart_box);
#endif
        /*************************************************/
        // Bar at the bottom
        var actionbar = new Gtk.CenterBox () {
            valign = Gtk.Align.END,
            margin_top = SPACING_TRIPLE,
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
}
