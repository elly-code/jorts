/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/**
* Represents the file on-disk, and takes care of the annoying  
* 
* void          save (Json.Array)  --> Save to the storage file data
* Json.Array   load ()           --> Load and return 
*
* save() takes a Json.Node instead of an NoteData[] so we avoid looping twice through all notes
* It is agressively persistent in 
*/
public class Jorts.Storage : Object {

    private const string FILENAME = "saved_state.json";
    private File datadir;
    private string savefile_path;

    /**
    * Convenience property wrapping load() and save()
    */
    public Json.Array content {
        owned get {return load ();}
        set {save (value);}
    }

    /*************************************************/
    construct {
        var path_data = GLib.Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), APP_ID);
        datadir = File.new_for_path (path_data);
        savefile_path = GLib.Path.build_path (Path.DIR_SEPARATOR_S, path_data, FILENAME);

        ensure_datadir ();

        // TODO: Remove the below cruft after a while
        var old_storage_path = GLib.Path.build_path (Path.DIR_SEPARATOR_S, Environment.get_user_data_dir (), FILENAME);
        var old_storage_file = File.new_for_path (old_storage_path);
        var savefile = File.new_for_path (savefile_path);

        if (old_storage_file.query_exists ()) {
            try {
                old_storage_file.move (savefile, GLib.FileCopyFlags.OVERWRITE);
                print ("Sucessfully moved old storage");

            } catch (Error e) {
                warning ("Failed to move storage %s\n", e.message);
            }
        }
    }

    /*************************************************/
    /**
    * Persistently check for the data directory and create if there is none 
    */
    private void ensure_datadir () {
        debug ("do we have a data directory?");
        if (datadir.query_exists ()) {
            debug ("Yes, nevermind");
            return;
        }

        try {
            datadir.make_directory_with_parents ();
            debug ("yes we do now");

        } catch (Error e) {
            warning ("Failed to prepare target data directory %s", e.message);
        }
    }

    /*************************************************/
    /**
    * Converts a Json.Node into a string and take care of saving it
    */
    public void save (Json.Array json_data) {
        ensure_datadir ();
        debug ("Writing %u elements (Should be same number as sticky notes)", json_data.get_length ());

        try {
            var generator = new Json.Generator ();
            var node = new Json.Node (Json.NodeType.ARRAY);
            node.set_array (json_data);
            generator.set_root (node);
            generator.to_file (savefile_path);

        } catch (Error e) {
            warning ("Failed to save notes %s", e.message);
        }

        print ("\n (%u notes saved)", json_data.get_length ());
    }

    /*************************************************/
    /**
    * Grab from storage, into a Json.Node we can parse. Insist if necessary
    */
    public Json.Array load () {
        debug ("Loading from storage letsgo");
        var parser = new Json.Parser ();
        var array = new Json.Array ();

        try {
            parser.load_from_mapped_file (savefile_path);
            var node = parser.get_root ();
            array = node.get_array ();

        } catch (Error e) {
            warning ("Failed to load from storage %s", e.message);

        }

        debug ("Retrieved %ui elements", array.get_length ());
        return array;
    }
}
