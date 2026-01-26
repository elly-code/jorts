/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* We use Granite.Bin to subclass ActionBar.
* Everything is kept there but most widgets are public
*/
 public class Jorts.ActionBar : Granite.Bin {

    public Gtk.ActionBar actionbar;
    public Gtk.Button list_button;
    public Gtk.MenuButton emoji_button;
    public Gtk.EmojiChooser emojichooser_popover;
    public Gtk.MenuButton menu_button;
    public Gtk.WindowHandle handle;

    construct {

        /* **** LEFT **** */
        var new_item = new Gtk.Button () {
            icon_name = "list-add-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>n"},
                _("New sticky note")
            )
        };
        new_item.action_name = Application.ACTION_PREFIX + Application.ACTION_NEW;
        new_item.add_css_class ("themedbutton");

        var delete_item = new Gtk.Button () {
            icon_name = "edit-delete-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>w"},
                _("Delete sticky note")
            )
        };
        delete_item.add_css_class ("themedbutton");
        delete_item.action_name = StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_DELETE;

        /* **** RIGHT **** */
        list_button = new Gtk.Button () {
            icon_name = "view-list-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Shift>F12"},
                _("Toggle list")
            )
        };
        list_button.add_css_class ("themedbutton");
        list_button.action_name = StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_TOGGLE_LIST;

        emojichooser_popover = new Gtk.EmojiChooser ();

        emoji_button = new Gtk.MenuButton () {
            icon_name = Jorts.Utils.random_emote (),
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>period"},
                _("Insert emoji")
            )
        };
        emoji_button.add_css_class ("themedbutton");
        emoji_button.popover = emojichooser_popover;

        menu_button = new Gtk.MenuButton () {
            icon_name = "open-menu-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>g", "<Control>o"},
                _("Preferences for this sticky note")
            )
        };
        menu_button.direction = Gtk.ArrowType.UP;
        menu_button.add_css_class ("themedbutton");

        /* **** Widget **** */
        actionbar = new Gtk.ActionBar () {
            hexpand = true
        };
        actionbar.revealed = false;
        actionbar.pack_start (new_item);
        actionbar.pack_start (delete_item);
        actionbar.pack_end (menu_button);
        actionbar.pack_end (emoji_button);
        actionbar.pack_end (list_button);

        handle = new Gtk.WindowHandle () {
            child = actionbar
        };

        child = handle;

        // Randomize-skip emoji icon
        emojichooser_popover.show.connect (on_emoji_popover);

        // Hide the list button if user has specified no list item symbol
        on_prefix_changed ();
        Application.gsettings.changed["list-item-start"].connect (on_prefix_changed);

    }

    /**
    * Allow control of when to respect the hide-bar setting
    * StickyNoteWindow will decide itself whether to show immediately or not
    */
    public void reveal_bind () {
        Application.gsettings.bind ("hide-bar", this.actionbar, "revealed", SettingsBindFlags.INVERT_BOOLEAN);
    }

    // Skip the current icon to avoid picking it twice
    private void on_emoji_popover () {
        debug ("Emote requested!");

        emoji_button.set_icon_name (
            Jorts.Utils.random_emote (
                emoji_button.icon_name
            )
        );
    }

    private void on_prefix_changed () {
        list_button.visible = (Application.gsettings.get_string ("list-item-start") != "");
    }
}
