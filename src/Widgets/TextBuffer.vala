/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* A buffer with some list abilities and utils
*/
public class Jorts.TextBuffer : Gtk.TextBuffer {

    public const string LIST_TAG_NAME = "list_item";
    private string list_item_prefix;
    private int indent_width;

    public void init_list_handling (string prefix, int initial_indent_width) {
        print ("prefix: %s, width: %i", prefix, initial_indent_width);

        // Setup the bespoke indent
        create_tag (LIST_TAG_NAME,
                "indent", -initial_indent_width
            );

        list_item_prefix = prefix;
        indent_width = initial_indent_width;

        // Sweep for prefixes to also tag
        restore_list_item_indentation ();
    }

    private void restore_list_item_indentation () {
        Gtk.TextIter start, end;
        get_bounds (out start, out end);
        remove_tag_by_name (LIST_TAG_NAME, start, end);

        if ( list_item_prefix == "") {
            return;
        }

        var line_count = get_line_count ();

        for (int line_number = 0; line_number < line_count; line_number++) {
            if (!this.has_prefix (line_number)) {
                continue;
            }

            Gtk.TextIter line_start, line_end;
            get_iter_at_line_offset (out line_start, line_number, 0);
            line_end = line_start.copy ();
            line_end.forward_to_line_end ();
            apply_tag_by_name (LIST_TAG_NAME, line_start, line_end);
        }
    }

    public void refresh_list_item_indentation (int new_indent) {
        var list_item_tag = tag_table.lookup (LIST_TAG_NAME);
        list_item_tag.indent = -new_indent;
        indent_width = new_indent;
    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private bool has_specific_prefix (int line_number, string prefix) {
        if (prefix == "") {return false;}

        Gtk.TextIter start, end;
        get_iter_at_line_offset (out start, line_number, 0);

        end = start.copy ();
        end.forward_to_line_end ();

        var text_in_line = get_slice (start, end, false);

        return text_in_line.has_prefix (prefix);
    }

    public bool has_prefix (int line_number) {
        return has_specific_prefix (line_number, list_item_prefix);
    }

    private void replace_prefix (int line_number, string old_prefix, string new_prefix) {
        Gtk.TextIter line_start, prefix_end;

        get_iter_at_line_offset (out line_start, line_number, 0);
        get_iter_at_line_offset (out prefix_end, line_number, old_prefix.char_count ());
        this.delete (ref line_start, ref prefix_end);

        get_iter_at_line_offset (out line_start, line_number, 0);
        insert (ref line_start, new_prefix, -1);
    }

    private void migrate_list_prefixes (string new_prefix) {
        if (new_prefix == "") {
            Gtk.TextIter start, end;
            get_bounds (out start, out end);
            remove_tag_by_name (LIST_TAG_NAME, start, end);

            return;
        }

        var line_count = get_line_count ();
        var did_change = false;


        for (int line_number = 0; line_number < line_count; line_number++) {
            if (!has_specific_prefix (line_number, list_item_prefix)) {
                continue;
            }

            replace_prefix (line_number, list_item_prefix, new_prefix);
            did_change = true;
        }

        if (did_change || new_prefix == "") {
            restore_list_item_indentation ();
        }
    }

    /**
     * Checks whether Line x to Line y are all bulleted.
     */
    public bool is_list (int first_line, int last_line) {

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
    public void set_list (int first_line, int last_line) {
        Gtk.TextIter line_start;
        for (int line_number = first_line; line_number <= last_line; line_number++) {

            print ("\nSetting line %i", line_number);
            debug ("doing line " + line_number.to_string ());
            if (!this.has_prefix (line_number)) {
                get_iter_at_line_offset (out line_start, line_number, 0);
                insert (ref line_start, list_item_prefix, -1);
            }

            // Apply hanging indent tag to the line
            Gtk.TextIter ls, le;
            get_iter_at_line_offset (out ls, line_number, 0);
            le = ls.copy ();
            le.forward_to_line_end ();
            apply_tag_by_name (LIST_TAG_NAME, ls, le);
        }
    }

    /**
     * Remove list prefix from line x to line y. Presuppose it is there
     */
    public void remove_list (int first_line, int last_line) {
        for (int line_number = first_line; line_number <= last_line; line_number++) {
            remove_prefix (line_number);
        }
    }

    /**
     * Remove list prefix from line x to line y. Presuppose it is there
     */
    public void remove_prefix (int line_number) {
        Gtk.TextIter line_start, prefix_end, line_end;
        var remove_range = list_item_prefix.to_string ().char_count ();

        debug ("doing line " + line_number.to_string ());
        get_iter_at_line_offset (out line_start, line_number, 0);
        get_iter_at_line_offset (out prefix_end, line_number, remove_range);
        this.delete (ref line_start, ref prefix_end);

        // Remove hanging indent tag from the line
        get_iter_at_line_offset (out line_start, line_number, 0);
        line_end = line_start.copy ();
        line_end.forward_to_line_end ();
        remove_tag_by_name (LIST_TAG_NAME, line_start, line_end);
    }

}
