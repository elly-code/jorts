/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* A textview subclassing {@link Granite.HyperTextView}, allowing it to do clickable links and emails
* 
* Extended with bullet lists that follows user settings
*/
public class Jorts.TextView : Granite.HyperTextView {

    private Gtk.EventControllerKey keyboard;
    public string list_item_start {get; set;}
    public bool on_list_item {public get; private set;}

    public string text {
        owned get {return buffer.text;}
        set {buffer.text = value;}
    }

    Gtk.TextTag tag_list;
    private const string TAG_LIST = "list_item";

    public SimpleActionGroup actions {get; construct;}
    public const string ACTION_PREFIX = "textview.";
    public const string ACTION_TOGGLE_LIST = "action_toggle_list";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_TOGGLE_LIST, toggle_list}
    };

    public TextView () {
        Object (
            wrap_mode: Gtk.WrapMode.WORD,
            bottom_margin: SPACING_DOUBLE,
            left_margin: SPACING_DOUBLE,
            right_margin: SPACING_DOUBLE,
            top_margin: SPACING_STANDARD,
            hexpand: true,
            vexpand: true
        );
    }

    construct {
        /***************************************************/
        /*              Actions and controllers            */
        /***************************************************/


        // Action stuff
        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("textview", actions);

        unowned var app = ((Gtk.Application) GLib.Application.get_default ());
        app.set_accels_for_action (ACTION_PREFIX + ACTION_TOGGLE_LIST, {"<Shift>F12"});

        keyboard = new Gtk.EventControllerKey ();
        keyboard.key_pressed.connect (on_key_pressed);
        add_controller (keyboard);

        // Alternate way to access preferences
        var menuitem_pref = new GLib.MenuItem (_("Show Preferences"), Application.ACTION_PREFIX + Application.ACTION_SHOW_PREFERENCES);
        var menuitem_quit = new GLib.MenuItem (_("Quit Jorts"), Application.ACTION_PREFIX + Application.ACTION_QUIT);
        var extra = new GLib.Menu ();
        var section = new GLib.Menu ();

        section.append_item (menuitem_pref);
        section.append_item (menuitem_quit);
        extra.append_section (null, section);
        extra_menu = extra;



        var tag_table = new Gtk.TextTagTable ();
        buffer = new Gtk.TextBuffer (tag_table);

        var a = new Pango.TabArray (2, true);
        a.set_tab (0, Pango.TabAlign.LEFT, 0);
        a.set_tab (1, Pango.TabAlign.LEFT, 14);

        tag_list = buffer.create_tag (TAG_LIST);
        tag_list.indent = -14;
        tag_list.left_margin = 14;
        tag_list.wrap_mode = Gtk.WrapMode.WORD;
        tag_list.tabs = a;

        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        Application.gsettings.bind (KEY_LIST,
            this, "list-item-start",
            GLib.SettingsBindFlags.DEFAULT);
    }

    public void toggle_list () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);

        var first_line = start.get_line ();
        var last_line = end.get_line ();
        debug ("got " + first_line.to_string () + " to " + last_line.to_string ());

        var selected_is_list = this.is_list (first_line, last_line, list_item_start);

        buffer.begin_user_action ();
        if (selected_is_list) {
            remove_list (first_line, last_line);

        } else {
            set_list (first_line, last_line);
        }
        buffer.end_user_action ();

        grab_focus ();
    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private bool has_prefix (int line_number) {
        if (list_item_start == "") {return false;}

        Gtk.TextIter start, end;
        buffer.get_iter_at_line_offset (out start, line_number, 0);

        end = start.copy ();
        end.forward_to_line_end ();

        var text_in_line = buffer.get_slice (start, end, false);

        return text_in_line.has_prefix (list_item_start);
    }

    /**
     * Checks whether Line x to Line y are all bulleted.
     */
    private bool is_list (int first_line, int last_line, string list_item_start) {

        for (int line_number = first_line; line_number <= last_line; line_number++) {
            debug ("doing line " + line_number.to_string ());

            if (!this.has_prefix (line_number)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private void set_list (int first_line, int last_line) {
        Gtk.TextIter line_start;
        for (int line_number = first_line; line_number <= last_line; line_number++) {

            debug ("doing line " + line_number.to_string ());
            if (!this.has_prefix (line_number)) {
                buffer.get_iter_at_line_offset (out line_start, line_number, 0);

                buffer.insert (ref line_start, "%s\t".printf (list_item_start), -1);

                buffer.get_iter_at_line_offset (out line_start, line_number, 0);
                var line_end = line_start.copy ();
                line_end.forward_to_line_end ();

                buffer.apply_tag (tag_list, line_start, line_end);
            }
        }

    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private void set_list_at (int line) {
        Gtk.TextIter line_start;

        buffer.get_iter_at_line_offset (out line_start, line, 0);
        var line_end = line_start.copy ();
        line_end.forward_to_line_end ();
        buffer.apply_tag (tag_list, line_start, line_end);

        buffer.insert (ref line_start, "%s\t".printf (list_item_start), -1);
    }



    private void remove_list_at (int line) {
        if (!has_prefix (line)) {
            return;
        }

        Gtk.TextIter line_start;
        remove_prefix (line);
    }



    /**
     * Remove list prefix from line x to line y. Presuppose it is there
     */
    private void remove_list (int first_line, int last_line) {
        for (int line_number = first_line; line_number <= last_line; line_number++) {
            remove_prefix (line_number);
        }
    }

    /**
     * Remove list prefix from line x to line y. Presuppose it is there
     */
    private void remove_prefix (int line_number) {
        Gtk.TextIter line_start, prefix_end;
        var remove_range = list_item_start.char_count ();

        debug ("doing line " + line_number.to_string ());
        buffer.get_iter_at_line_offset (out line_start, line_number, 0);
        buffer.get_iter_at_line_offset (out prefix_end, line_number, remove_range);
        buffer.delete (ref line_start, ref prefix_end);

        var line_end = line_start.copy ();
        line_end.forward_to_line_end ();
        buffer.remove_tag (tag_list, line_start, line_end);
    }

    /**
     * Handler whenever a key is pressed, to see if user needs something and get ahead
     * Some local stuff is deduplicated in the Ifs, because i do not like the idea of getting computation done not needed 98% of the time
     */
    private bool on_key_pressed (uint keyval, uint keycode, Gdk.ModifierType state) {

        // If backspace on a prefix: Delete the prefix.
        if (keyval == Gdk.Key.BackSpace) {
            print ("backspace");

            Gtk.TextIter start, end;
            buffer.get_selection_bounds (out start, out end);

            var line_number = start.get_line ();

            if (has_prefix (line_number)) {

                buffer.get_iter_at_line_offset (out start, line_number, 0);
                var text_in_line = buffer.get_slice (start, end, false);

                if (text_in_line == list_item_start) {

                    buffer.begin_user_action ();
                    buffer.delete (ref start, ref end);
                    buffer.insert_at_cursor ("\n", -1);
                    buffer.end_user_action ();
                }
            }
            return false;

        // If Enter on a list item, add a list prefix on the new line
        } else if (keyval == Gdk.Key.Return) {
            Gtk.TextIter start, end;
            buffer.get_selection_bounds (out start, out end);
            var line_number = start.get_line ();

            if (this.has_prefix (line_number)) {

                buffer.begin_user_action ();
                buffer.insert_at_cursor ("\n" + list_item_start, -1);
                buffer.end_user_action ();

                return true;
            }
        }

        // Nothing, carry on
        return false;
    }

/*      private void on_cursor_changed () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);
        var line_number = start.get_line ();

        on_list_item = this.has_prefix (line_number);

        print ("THIS IS LIST. HAS " + on_list_item.to_string () + "ON LINE " + line_number.to_string ());
    }  */
}
