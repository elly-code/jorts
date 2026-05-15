/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* A textview incorporating detecting links and emails
* Fairly vanilla but having a definition allows to easily extend it
*/
public class Jorts.TextView : Granite.HyperTextView {

    private Gtk.EventControllerKey keyboard;
    private Gtk.TextBuffer? observed_buffer;
    private ulong buffer_changed_handler_id = 0;
    private bool list_item_restore_queued = false;
    private string _list_item_start = "";
    public string list_item_start {
        get { return _list_item_start; }
        set {
            if (_list_item_start == value) {
                return;
            }

            var old_prefix = _list_item_start;
            _list_item_start = value;
            migrate_list_prefixes (old_prefix, value);
        }
    }
    public bool on_list_item {public get; private set;}

    public string text {
        owned get {return buffer.text;}
        set {buffer.text = value;}
    }

    public SimpleActionGroup actions {get; construct;}
    public const string ACTION_PREFIX = "textview.";
    public const string ACTION_TOGGLE_LIST = "action_toggle_list";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_TOGGLE_LIST, toggle_list}
    };

    public TextView () {
        Object (
            wrap_mode: Gtk.WrapMode.WORD_CHAR,
            buffer: new Gtk.TextBuffer (null),
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


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        notify["buffer"].connect (() => {
            attach_buffer_observers ();
            queue_restore_list_item_indentation ();
        });
        attach_buffer_observers ();

        Application.gsettings.bind (KEY_LIST,
            this, "list-item-start",
            GLib.SettingsBindFlags.DEFAULT);
    }

    private void attach_buffer_observers () {
        if (observed_buffer == buffer) {
            return;
        }

        detach_buffer_observers ();
        observed_buffer = buffer;

        buffer_changed_handler_id = observed_buffer.changed.connect_after (queue_restore_list_item_indentation);
    }

    private void detach_buffer_observers () {
        if (observed_buffer == null) {
            return;
        }

        if (buffer_changed_handler_id != 0) {
            SignalHandler.disconnect (observed_buffer, buffer_changed_handler_id);
            buffer_changed_handler_id = 0;
        }

        observed_buffer = null;
    }

    private void queue_restore_list_item_indentation () {
        if (list_item_restore_queued) {
            return;
        }

        list_item_restore_queued = true;

        Idle.add (() => {
            list_item_restore_queued = false;
            restore_list_item_indentation ();
            return false;
        });
    }

    private void ensure_tags () {
        if (list_item_start == "") {
            return;
        }

        var layout = this.create_pango_layout (list_item_start);
        int width, height;
        layout.get_pixel_size (out width, out height);

        var list_item_tag = buffer.tag_table.lookup ("list_item");

        if (list_item_tag == null) {
            buffer.create_tag ("list_item",
                "indent", -width,
                "left-margin", SPACING_DOUBLE + width
            );
            return;
        }

        list_item_tag.indent = -width;
        list_item_tag.left_margin = SPACING_DOUBLE + width;
    }

    public void refresh_list_item_indentation () {
        ensure_tags ();
    }

    public void restore_list_item_indentation () {
        Gtk.TextIter start, end;
        buffer.get_bounds (out start, out end);
        buffer.remove_tag_by_name ("list_item", start, end);

        if (list_item_start == "") {
            return;
        }

        ensure_tags ();

        var line_count = buffer.get_line_count ();

        for (int line_number = 0; line_number < line_count; line_number++) {
            if (!this.has_prefix (line_number)) {
                continue;
            }

            Gtk.TextIter line_start, line_end;
            buffer.get_iter_at_line_offset (out line_start, line_number, 0);
            line_end = line_start.copy ();
            line_end.forward_to_line_end ();
            buffer.apply_tag_by_name ("list_item", line_start, line_end);
        }
    }

    public void toggle_list () {
        ensure_tags ();
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
    private bool has_specific_prefix (int line_number, string prefix) {
        if (prefix == "") {return false;}

        Gtk.TextIter start, end;
        buffer.get_iter_at_line_offset (out start, line_number, 0);

        end = start.copy ();
        end.forward_to_line_end ();

        var text_in_line = buffer.get_slice (start, end, false);

        return text_in_line.has_prefix (prefix);
    }

    private bool has_prefix (int line_number) {
        return has_specific_prefix (line_number, list_item_start);
    }

    private void replace_prefix (int line_number, string old_prefix, string new_prefix) {
        Gtk.TextIter line_start, prefix_end;

        buffer.get_iter_at_line_offset (out line_start, line_number, 0);
        buffer.get_iter_at_line_offset (out prefix_end, line_number, old_prefix.char_count ());
        buffer.delete (ref line_start, ref prefix_end);

        buffer.get_iter_at_line_offset (out line_start, line_number, 0);
        buffer.insert (ref line_start, new_prefix, -1);
    }

    private void migrate_list_prefixes (string old_prefix, string new_prefix) {
        if (old_prefix == "") {
            if (new_prefix == "") {
                Gtk.TextIter start, end;
                buffer.get_bounds (out start, out end);
                buffer.remove_tag_by_name ("list_item", start, end);
            }

            return;
        }

        var line_count = buffer.get_line_count ();
        var did_change = false;

        buffer.begin_user_action ();

        for (int line_number = 0; line_number < line_count; line_number++) {
            if (!has_specific_prefix (line_number, old_prefix)) {
                continue;
            }

            replace_prefix (line_number, old_prefix, new_prefix);
            did_change = true;
        }

        buffer.end_user_action ();

        if (did_change || new_prefix == "") {
            restore_list_item_indentation ();
        }
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

            // Apply hanging indent tag to the line
            Gtk.TextIter ls, le;
            buffer.get_iter_at_line_offset (out ls, line_number, 0);
            le = ls.copy ();
            le.forward_to_line_end ();
            buffer.apply_tag_by_name ("list_item", ls, le);
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
        Gtk.TextIter line_start, prefix_end, line_end;
        var remove_range = list_item_start.char_count ();

        debug ("doing line " + line_number.to_string ());
        buffer.get_iter_at_line_offset (out line_start, line_number, 0);
        buffer.get_iter_at_line_offset (out prefix_end, line_number, remove_range);
        buffer.delete (ref line_start, ref prefix_end);

        // Remove hanging indent tag from the line
        buffer.get_iter_at_line_offset (out line_start, line_number, 0);
        line_end = line_start.copy ();
        line_end.forward_to_line_end ();
        buffer.remove_tag_by_name ("list_item", line_start, line_end);
    }

    /**
     * Handler whenever a key is pressed, to see if user needs something and get ahead
     * Some local stuff is deduplicated in the Ifs, because i do not like the idea of getting computation done not needed 98% of the time
     */
    private bool on_key_pressed (uint keyval, uint keycode, Gdk.ModifierType state) {
        ensure_tags ();

        // If backspace on a prefix: Delete the prefix.
        if (keyval == Gdk.Key.BackSpace) {

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

                    // The line is now an empty normal line, so remove the hanging indent
                    buffer.get_iter_at_line_offset (out start, line_number, 0);
                    end = start.copy ();
                    end.forward_to_line_end ();
                    buffer.remove_tag_by_name ("list_item", start, end);

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

                // Ensure new line has tag applied since it was just inserted
                buffer.get_iter_at_line_offset (out start, line_number + 1, 0);
                end = start.copy ();
                end.forward_to_line_end ();
                buffer.apply_tag_by_name ("list_item", start, end);

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
