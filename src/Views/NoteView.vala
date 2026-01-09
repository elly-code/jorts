/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

 public class Jorts.NoteView : Gtk.Box {
    public Gtk.HeaderBar headerbar;
    public Jorts.EditableLabel editablelabel;
    public Jorts.TextView textview;
    public Jorts.ActionBar actionbar;

    public Gtk.MenuButton emoji_button;
    public Gtk.EmojiChooser emojichooser_popover;
    public Gtk.MenuButton menu_button;

    public Gtk.ScrolledWindow scrolled;

    public bool monospace {
        get { return textview.monospace;}
        set { mono_set (value);}
    }

    public string title {
        owned get { return editablelabel.text;}
        set { editablelabel.text = value;}
    }

    public string content {
        owned get { return textview.text;}
        set { textview.text = value;}
    }

    construct {
        orientation = VERTICAL;
        spacing = 0;

        headerbar = new Gtk.HeaderBar () {
            show_title_buttons = false
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        headerbar.add_css_class ("headertitle");

        // Defime the label you can edit. Which is editable.
        editablelabel = new Jorts.EditableLabel ();
        headerbar.set_title_widget (editablelabel);

        textview = new Jorts.TextView ();
        scrolled = new Gtk.ScrolledWindow () {
            child = textview
        };

        actionbar = new Jorts.ActionBar ();
        emoji_button = actionbar.emoji_button;
        emojichooser_popover = actionbar.emojichooser_popover;
        menu_button = actionbar.menu_button;

        append (headerbar);
        append (scrolled);
        append (actionbar);
        //set_focus_child (textview);

        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        emojichooser_popover.show.connect (randomize_emote_button);
        emojichooser_popover.emoji_picked.connect (on_emoji_picked);
        //Application.gsettings.bind ("hide-bar", actionbar, "revealed", SettingsBindFlags.INVERT_BOOLEAN);

        //textview.bind_property ("on_list_item", actionbar.list_button, "active", GLib.BindingFlags.DEFAULT);
    }

    // Randomize the button emoji when clicked
    private void randomize_emote_button () {
        debug ("Emote requested!");
        emoji_button.icon_name = Jorts.Utils.random_emote (emoji_button.icon_name);
    }

    private void on_emoji_picked (string emoji) {
        debug ("Emote picked!");
        textview.buffer.insert_at_cursor (emoji, -1);
        textview.grab_focus ();
    }

    private void mono_set (bool if_mono) {
        editablelabel.monospace = if_mono;
        textview.monospace = if_mono;
    }

    public void action_focus_title () {editablelabel.editing = true;}
    public void action_show_emoji () {emoji_button.activate ();}
    public void action_show_menu () {menu_button.activate ();}
    public void action_toggle_list () {textview.toggle_list ();}
}
