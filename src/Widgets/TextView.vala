/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
 * A textview for our sticky notes.
 * Inherits Hypertextview to detect links and emails
 * Adds a list feature which is a hot mess
 */
public class Jorts.TextView : Granite.HyperTextView {

    // We subclass the buffer to manage the list feature at a lower level
    // We need to keep a reference to its "Extended version"
    public Jorts.TextBuffer list_buffer;

   /**
    * We listen to the keyboard to intervene in some situations:
    * - When someone backspaces on a prefix, to delete it
    * - When someone hits Enter from a list item, to expand it
    */
    private Gtk.EventControllerKey keyboard;

    // We need to keep this reference so we can disconnect a handler after using it
    private Gdk.FrameClock? frame_clock;

    // Convenience
    public string text {
        owned get {return buffer.text;}
        set {buffer.text = value;}
    }

    // Wrapper, handles changing prefixes in a convenient way
    private ListPrefix _listprefix = ListPrefix.DISABLED;
    public ListPrefix listprefix {
        get {return _listprefix;}
        set {
            list_buffer.list_item_prefix = value.to_string ();
            _listprefix = value;
            refresh_indentation ();
        }
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
            bottom_margin: SPACING_DOUBLE,
            left_margin: SPACING_DOUBLE,
            right_margin: SPACING_DOUBLE,
            top_margin: SPACING_STANDARD,
            hexpand: true,
            vexpand: true
        );
    }

    construct {

        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("textview", actions);

        unowned var app = ((Gtk.Application) GLib.Application.get_default ());
        app.set_accels_for_action (ACTION_PREFIX + ACTION_TOGGLE_LIST, {"<Shift>F12"});

        keyboard = new Gtk.EventControllerKey ();
        keyboard.key_pressed.connect (on_key_pressed);
        add_controller (keyboard);

        // Alternate way to access preferences
        var menuitem_pref = new GLib.MenuItem (
            _("Show Preferences"),
            Application.ACTION_PREFIX + Application.ACTION_SHOW_PREFERENCES
        );

        var menuitem_quit = new GLib.MenuItem (
            _("Quit Jorts"),
            Application.ACTION_PREFIX + Application.ACTION_QUIT
        );

        var extra = new GLib.Menu ();
        var section = new GLib.Menu ();

        section.append_item (menuitem_pref);
        section.append_item (menuitem_quit);
        extra.append_section (null, section);
        extra_menu = extra;

        // We pretty much only use list_buffer since it has the added features
        list_buffer = new Jorts.TextBuffer ();
        buffer = (Gtk.TextBuffer)list_buffer;


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        // This a workaround to ensure we always have correct indent at windows start
        realize.connect (refresh_indentation);
        notify ["monospace"].connect (queue_refresh_indentation);
    }


    private void refresh_indentation () {
        var layout = create_pango_layout (_listprefix.to_string ());
        int indent_width, h;
        layout.get_pixel_size (out indent_width, out h);

        debug ("\nNEW SIZE: %i", indent_width);
        list_buffer.indent_width = indent_width;
    }

    /**
     * Refreshing after zoom changes requires to wait for layouting phase
     * This is used so we wait for the appropriate moment to measure prefix size and update indentation
     */
    public void queue_refresh_indentation () {
        frame_clock = get_frame_clock ();

        // No frame_clock, no widget to see, no need to proceed
        // Without this the thing still works, but spits a lot of errors at app start
        if (frame_clock == null) {
            return;
        }

        frame_clock.request_phase (LAYOUT);
        frame_clock.layout.connect (clock);
    }

    /**
     * Clock 
     */
    private void clock () {
        refresh_indentation ();
        frame_clock.layout.disconnect (clock);
    }


    public void toggle_list () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);

        var first_line = start.get_line ();
        var last_line = end.get_line ();
        debug ("got " + first_line.to_string () + " to " + last_line.to_string ());

        var selected_is_list = list_buffer.is_list (first_line, last_line);

        buffer.begin_user_action ();
        if (selected_is_list) {
            list_buffer.remove_list (first_line, last_line);

        } else {
            list_buffer.set_list (first_line, last_line);
        }
        refresh_indentation ();
        buffer.end_user_action ();

        grab_focus ();
    }


    /**
     * Handler whenever a key is pressed, to see if user needs something and get ahead
     * Some local stuff is deduplicated in the Ifs, because i do not like the idea of getting computation done not needed 98% of the time
     */
    private bool on_key_pressed (uint keyval, uint keycode, Gdk.ModifierType state) {


        // If backspace on a prefix: Delete the prefix.
        if (keyval == Gdk.Key.BackSpace) {

            Gtk.TextIter start, end;
            list_buffer.get_selection_bounds (out start, out end);
            var line_number = start.get_line ();

            if (list_buffer.has_prefix (line_number)) {

                list_buffer.get_iter_at_line_offset (out start, line_number, 0);
                var text_in_line = list_buffer.get_slice (start, end, false);
                print ("\nLength detected: %i", text_in_line.length);

                if (text_in_line == _listprefix.to_string ()) {
                    print ("\nremoving prefix at line %i", line_number);
                    list_buffer.begin_user_action ();
                    list_buffer.remove_prefix (line_number);
                    list_buffer.end_user_action ();

                    // Stop - Do not propagate further
                    return true;
                }
            }

        // If Enter on a list item, add a list prefix on the new line
        } else if (keyval == Gdk.Key.Return) {
            Gtk.TextIter start, end;
            buffer.get_selection_bounds (out start, out end);
            var line_number = start.get_line ();

            if (list_buffer.has_prefix (line_number)) {

                buffer.begin_user_action ();
                buffer.insert_at_cursor ("\n" + _listprefix.to_string (), -1);

                // Ensure new line has tag applied since it was just inserted
                buffer.get_iter_at_line_offset (out start, line_number + 1, 0);
                end = start.copy ();
                end.forward_to_line_end ();
                buffer.apply_tag_by_name (TextBuffer.LIST_TAG_NAME, start, end);

                buffer.end_user_action ();

                return true;
            }
        }

        // Nothing, carry on
        return false;
    }

}
