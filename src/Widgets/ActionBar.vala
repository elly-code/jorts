/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
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
    public Jorts.Popover popover;

    const int ICON_SIZE = 32;

    construct {

        /* **** LEFT **** */
        var new_item = new Gtk.Button () {
            action_name = Application.ACTION_PREFIX + Application.ACTION_NEW,
            icon_name = "list-add-symbolic",
            width_request = ICON_SIZE,
            height_request = ICON_SIZE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>n"},
                _("New sticky note")
            )
        };
        new_item.add_css_class (STYLE_THEMEDBUTTON);

        var delete_item = new Gtk.Button () {
            action_name = StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_DELETE,
            icon_name = "edit-delete-symbolic",
            width_request = ICON_SIZE,
            height_request = ICON_SIZE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>w"},
                _("Delete sticky note")
            )
        };
        delete_item.add_css_class (STYLE_THEMEDBUTTON);

        /* **** RIGHT **** */
        list_button = new Gtk.Button () {
            action_name = NoteView.ACTION_PREFIX + NoteView.ACTION_TOGGLE_LIST,
            icon_name = "view-list-symbolic",
            width_request = ICON_SIZE,
            height_request = ICON_SIZE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Shift>F12"},
                _("Toggle list")
            )
        };
        list_button.add_css_class (STYLE_THEMEDBUTTON);

        emojichooser_popover = new Gtk.EmojiChooser ();
        emoji_button = new Gtk.MenuButton () {
            popover = emojichooser_popover,
            icon_name = Jorts.Utils.random_emote (),
            width_request = ICON_SIZE,
            height_request = ICON_SIZE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>period"},
                _("Insert emoji")
            )
        };
        emoji_button.add_css_class (STYLE_THEMEDBUTTON);

        popover = new Jorts.Popover ();
        menu_button = new Gtk.MenuButton () {
            popover = popover,
            icon_name = "open-menu-symbolic",
            width_request = ICON_SIZE,
            height_request = ICON_SIZE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>g", "<Control>o"},
                _("Preferences for this sticky note")
            ),
            direction = Gtk.ArrowType.UP
        };
        menu_button.add_css_class (STYLE_THEMEDBUTTON);

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
        Application.gsettings.changed[KEY_LIST].connect (on_prefix_changed);

    }

    /**
    * Allow control of when to respect the hide-bar setting
    * StickyNoteWindow will decide itself whether to show immediately or not
    */
    public void reveal_bind () {
        Application.gsettings.bind (KEY_HIDEBAR,
            actionbar, "revealed",
            SettingsBindFlags.INVERT_BOOLEAN);
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
        list_button.visible = (Application.gsettings.get_string (KEY_LIST) != "");
    }
}
