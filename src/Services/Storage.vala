/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
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

    private const string FILENAME           = "saved_state.json";
    private string data_directory;
    private string storage_path;

    /**
    * Convenience property wrapping load() and save()
    */
    public Json.Array content {
        owned get {return load ();}
        set {save (value);}
    }

    /*************************************************/
    construct {

#if WINDOWS
        // In Windows we arent in a sandbox, so we need to have some courtesy and not dump in the allfolder
        data_directory      = GLib.Path.build_path("/", Environment.get_user_data_dir (), "Jorts");
#else
        data_directory      = Environment.get_user_data_dir ();
#endif

        storage_path        = data_directory + "/" + FILENAME;
        check_if_stash ();
    }

    /*************************************************/
    /**
    * Persistently check for the data directory and create if there is none 
    */
    private void check_if_stash () {
        debug ("do we have a data directory?");
        var dir = File.new_for_path (data_directory);

        try {
			if (!dir.query_exists ()) {
				dir.make_directory ();
				debug ("[STORAGE] yes we do now");
			}
		} catch (Error e) {
			warning ("[STORAGE] Failed to prepare target data directory %s\n", e.message);
		}
	}

    /*************************************************/
    /**
    * Converts a Json.Node into a string and take care of saving it
    */
    public void save (Json.Array json_data) {
        debug("Writing...");
        check_if_stash ();

        try {
            var generator = new Json.Generator ();
            var node = new Json.Node (Json.NodeType.ARRAY);
            node.set_array (json_data);
            generator.set_root (node);
            generator.to_file (storage_path);
            
        } catch (Error e) {
            warning ("[STORAGE] Failed to save notes %s", e.message);
        }

        print ("\n (Everything saved)");
    }

    /*************************************************/
    /**
    * Grab from storage, into a Json.Node we can parse. Insist if necessary
    */
    public Json.Array? load () {
        debug("Loading from storage letsgo");
        check_if_stash ();
        var parser = new Json.Parser ();
        var array = new Json.Array ();

        try {
            parser.load_from_mapped_file (storage_path);
            var node = parser.get_root ();
            array = node.get_array ();

        } catch (Error e) {
            warning ("Failed to load from storage " + e.message.to_string());

        }
        
        return array;
    }
}
