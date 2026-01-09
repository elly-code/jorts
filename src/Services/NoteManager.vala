/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/**
* Responsible for keeping track of various Sticky Notes windows
* It does its thing on its own. Make sure to call init() to summon all notes from storage
*/
public class Jorts.NoteManager : Object {

    private Jorts.Application application;
    public Gee.ArrayList<StickyNoteWindow> open_notes;
    public Jorts.Storage storage;
    private bool saving_lock = true;

    private static uint debounce_timer_id;

    public NoteManager (Jorts.Application app) {
        this.application = app;
    }

    construct {
        open_notes = new Gee.ArrayList<StickyNoteWindow> ();
        storage = new Jorts.Storage ();
    }

    /*************************************************/
    /**
    * Retrieve data from storage, and loop through it to create notes
    * Keep an active list of Windows.
    * We do not do this at construct time so we stay flexible whenever we want to init
    * NoteManager is also created too early by the app for new windows
    */    
    public void init () {
        debug ("Opening all sticky notes now!");
        Json.Array loaded_data = storage.load ();

        if (loaded_data.get_length () == 0) {
            var note_data = new NoteData ();
            note_data.theme = Constants.DEFAULT_THEME;
            create_note (note_data);

        } else {
            foreach (var json_data in loaded_data.get_elements()) {
                var json_obj = json_data.dup_object ();
                var note_data = new NoteData.from_json (json_obj);

                print ("\nLoaded: " + note_data.title);
                create_note (note_data);
            }
        }

        saving_lock = false;
        on_reduceanimation_changed ();
        Gtk.Settings.get_default ().notify["enable-animations"].connect (on_reduceanimation_changed);
    }

    /*************************************************/
    /**
    * Create new instances of StickyNoteWindow
    * Should we have data, we can pass it off, else create from random data
    * If we have data, nice, just load it into a new instance. Else we do a lil new note
    */
    public void create_note (NoteData? data = null) {
        debug ("Lets do a note");
        Jorts.StickyNoteWindow note;

        if (data != null) {
            note = new StickyNoteWindow (application, data);
        }
        else {
            var random_data = new NoteData ();
            
            // One chance at the golden sticky
            random_data = Jorts.Utils.golden_sticky (random_data);
            note = new StickyNoteWindow (application, random_data);
        }
        
        /* LETSGO */
        open_notes.add (note);
        note.changed.connect (save_all);

        note.show ();
        note.present ();
	}

    /*************************************************/
    /**
    * Delete a note by remove it from the active list and closing its window
    */
    public void delete_note (StickyNoteWindow note) {
        debug ("Removing a note…");

        open_notes.remove (note);
        note.changed.disconnect (save_all);
        application.remove_window ((Gtk.Window)note);

        note.close ();
        note.destroy ();

        print ("\nHas: " + note.ref_count.to_string () + " references");
        immediately_save ();
	}

    /*************************************************/
    /**
    * Cue to immediately write from the active list to the storage
    */
    public void save_all () {
        debug ("Save the stickies!");
        if (saving_lock) {return;}
        
        if (debounce_timer_id != 0) {
            GLib.Source.remove (debounce_timer_id);
        }

        debounce_timer_id = Timeout.add (Jorts.Constants.DEBOUNCE, debounce_handler);
    }

    public bool debounce_handler () {
        debounce_timer_id = 0;
        immediately_save ();
        return GLib.Source.REMOVE;
    }

    private void immediately_save () {
        var array = new Json.Array ();

        foreach (Jorts.StickyNoteWindow note in open_notes) {
            var data = note.packaged ();
            var object = data.to_json ();
            array.add_object_element (object);
        };

        storage.save (array);  
    }

    /*************************************************/
    /**
    * Handler to add or remove CSS animations from all active notes
    */
    public void on_reduceanimation_changed () {
        debug ("Reduce animation changed!");

        if (Gtk.Settings.get_default ().gtk_enable_animations) {
            foreach (var window in open_notes) {
                window.add_css_class ("animated");
            }

        } else {
            foreach (var window in open_notes) {
                // If we remove without checking we get a critical
                if ("animated" in window.css_classes) {
                    window.remove_css_class ("animated");
                }
            }
        }
    }
}
