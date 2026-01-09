/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/**
* A textview incorporating detecting links and emails
* Fairly vanilla but having a definition allows to easily extend it
*/
public class Jorts.TextView : Granite.HyperTextView {

    private Gtk.EventControllerKey keyboard;
    private string list_item_start;
    public bool on_list_item {public get; private set;}

    public string text {
        owned get {return buffer.text;}
        set {buffer.text = value;}
    }

    public const string ACTION_PREFIX = "textview.";
    public const string ACTION_TOGGLE_LIST = "action_toggle_list";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_TOGGLE_LIST, toggle_list},
    };

    construct {
        buffer = new Gtk.TextBuffer (null);
        bottom_margin = 10;
        left_margin = 10;
        right_margin = 10;
        top_margin = 5;

        hexpand = true;
        vexpand = true;
        wrap_mode = Gtk.WrapMode.WORD_CHAR;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("textview", actions);

        list_item_start = Application.gsettings.get_string ("list-item-start");
        Application.gsettings.changed["list-item-start"].connect (on_prefix_changed);

        keyboard = new Gtk.EventControllerKey ();
        add_controller (keyboard);
        keyboard.key_pressed.connect (on_key_pressed);

        //TODO: Buggy. Clicking anywhere brings it out of whack
        // on_cursor_changed ();
        // move_cursor.connect_after (on_cursor_changed);


        // var menuitem = new GLib.MenuItem (_("Toggle list"), TextView.ACTION_PREFIX + TextView.ACTION_TOGGLE_LIST);
        // var extra = new GLib.Menu ();
        // var section = new GLib.Menu ();

        // section.append_item (menuitem);
        // extra.append_section (null, section);

        // this.extra_menu = extra;
    }

    public void toggle_list () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);

        var first_line = start.get_line ();
        var last_line = end.get_line ();
        debug ("got " + first_line.to_string () + " to " + last_line.to_string ());

        var selected_is_list = this.is_list (first_line, last_line, list_item_start);

        buffer.begin_user_action ();
        if (selected_is_list)
        {
            this.remove_list (first_line, last_line);

        } else {
            this.set_list (first_line, last_line);
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
                buffer.insert (ref line_start, list_item_start, -1);
            }
        }
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

    private void on_prefix_changed () {
        list_item_start = Application.gsettings.get_string ("list-item-start");
    }

/*      private void on_cursor_changed () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);
        var line_number = start.get_line ();

        on_list_item = this.has_prefix (line_number);

        print ("THIS IS LIST. HAS " + on_list_item.to_string () + "ON LINE " + line_number.to_string ());
    }  */
}
