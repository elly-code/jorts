/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

 public class Jorts.PreferencesView : Granite.Bin {

    private Granite.Toast toast;
    public Gtk.Button close_button;

#if LIBPORTAL
    Gtk.Switch autostart_toggle;
    Jorts.Autostart autostart;
#endif

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

        toast = new Granite.Toast ("");
        overlay.add_overlay (toast);
        child = overlay;

        // the box with all the settings
        var settingsbox = new Gtk.Box (VERTICAL, SPACING_DOUBLE) {
            hexpand = true,
            vexpand = true,
            valign = Gtk.Align.START
        };

            /***************************************/
            /*               lists                 */
            /***************************************/

            var list_dropdown = new Gtk.DropDown.from_strings (ListPrefix.ALL) {
                halign = Gtk.Align.END,
                hexpand = false,
                valign = Gtk.Align.CENTER
            };

            list_dropdown.selected = Application.settings.get_enum (KEY_LIST);
            list_dropdown.notify["selected"].connect (() => {
                Application.settings.set_enum (KEY_LIST, (int)list_dropdown.selected);
            });

            var lists_box = new SettingsBox (
                _("List item prefix"),
                null, //_("If disabled, the toggle list button will be hidden"),
                list_dropdown);

            settingsbox.append (lists_box);


            /*************************************************/
            /*              scribbly Toggle                  */
            /*************************************************/

            var scribbly_toggle = new Gtk.Switch ();

            Application.settings.bind (KEY_SCRIBBLY,
                scribbly_toggle, "active",
                GLib.SettingsBindFlags.DEFAULT);

            var scribbly_box = new Jorts.SettingsBox (
                _("Scribble unfocused notes (Ctrl+H)"),
                null, //_("You can also use the Ctrl+H shortcut"),
                scribbly_toggle);

            settingsbox.append (scribbly_box);


            /*************************************************/
            /*               hidebar Toggle                  */
            /*************************************************/
            var hidebar_toggle = new Gtk.Switch ();

            Application.settings.bind (KEY_HIDEBAR,
                hidebar_toggle, "active",
                GLib.SettingsBindFlags.DEFAULT);

            var hidebar_box = new Jorts.SettingsBox (
                //TRANSLATORS: Instead of bottom bar you can also use "Action bar" or "button bar"
                _("Hide bottom bar (Ctrl+T)"),
                null, //_("You can also use the Ctrl+T shortcut"),
                hidebar_toggle);

            settingsbox.append (hidebar_box);



            /***********************************************/
            /*               Restore_last                  */
            /***********************************************/

            //TRANSLATORS: Button to restore sticky notes the application
            var restore_button = new Gtk.Button () {
                label = _("Restore note"),
                tooltip_markup = Granite.markup_accel_tooltip (
                    {"<Ctrl>R"},
                    _("Restore the last deleted sticky note")
                ),
                action_name = Application.ACTION_PREFIX + Application.ACTION_RESTORE_LAST,
                width_request = 96,
            };

           /*   var restore_box = new SettingsBox (
                _("Restore last deleted note"),
                _("Restore the last deleted sticky note (Ctrl+R)"),
                restore_button);  */

            //settingsbox.append (restore_box);


            /****************************************************/
            /*               Autostart Request                  */
            /****************************************************/

// Not all OSes have libportal
#if LIBPORTAL
            autostart_toggle = new Gtk.Switch ();

            Application.settings.bind (KEY_AUTOSTART,
                autostart_toggle, "active",
                GLib.SettingsBindFlags.DEFAULT);

            autostart = new Jorts.Autostart ();
            autostart_toggle.notify["state"].connect (handle_toggle_autostart);
            //autostart.fail.connect (toast.)

            var autostart_box = new Jorts.SettingsBox (
                _("Show notes on log in"),
                _("May be out of sync with system settings in some cases"),
                autostart_toggle);

            settingsbox.append (autostart_box);
#endif

        /*************************************************/
        // Bar at the bottom
        var actionbar = new Gtk.CenterBox () {
            valign = Gtk.Align.END,
            margin_top = SPACING_TRIPLE + SPACING_DOUBLE,
            hexpand = true,
            vexpand = false
        };

        // Monies?
        actionbar.start_widget = new Gtk.LinkButton.with_label (
            DONATE_LINK,
            _("Support us!")
        );

        var right_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, Jorts.SPACING_DOUBLE);
        actionbar.end_widget = right_box;

        var close = new Gtk.Button () {
            action_name = "window.close",
            width_request = 96,
            label = _("Close"),
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Alt>F4"},
                _("Close preferences")
            )
        };
        right_box.append (restore_button);
        right_box.append (close);

        prefview.append (settingsbox);
        prefview.append (actionbar);
    }

#if LIBPORTAL
    private void handle_toggle_autostart () {
        if (autostart_toggle.active) {
            autostart.request_set.begin ();
            return;
        }

        autostart.request_remove.begin ();
    }
#endif
}
