/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/**
* A box mimicking the one in elementary OS Appearance settings page
* It shows a row with all the colours
*/
public class Jorts.ColorBox : Gtk.Box {

    public SimpleAction accent_color_action;

    public Jorts.Themes color {
        get {return (Jorts.Themes)accent_color_action.get_state ();}
        set {accent_color_action.set_state (value);}
    }

    public signal void theme_changed (Themes selected);


    public ColorBox () {
        orientation = Gtk.Orientation.HORIZONTAL;
        accessible_role = Gtk.AccessibleRole.LIST;

        spacing = 1;
        margin_start = 10;
        margin_end = 10;


        var blueberry_button = new ColorPill (Themes.BLUEBERRY);
        var mint_button = new ColorPill (Themes.MINT, blueberry_button);
        var lime_button = new ColorPill (Themes.LIME, blueberry_button);
        var banana_button = new ColorPill (Themes.BANANA, blueberry_button);
        var orange_button = new ColorPill (Themes.ORANGE, blueberry_button);
        var strawberry_button = new ColorPill (Themes.STRAWBERRY, blueberry_button);
        var bubblegum_button = new ColorPill (Themes.BUBBLEGUM, blueberry_button);
        var grape_button = new ColorPill (Themes.GRAPE, blueberry_button);
        var cocoa_button = new ColorPill (Themes.COCOA, blueberry_button);
        var slate_button = new ColorPill (Themes.SLATE, blueberry_button);
        //var auto_button = new ColorPill (Themes.IDK, blueberry_button);

        append (blueberry_button);
        append (mint_button);
        append (lime_button);
        append (banana_button);
        append (orange_button);
        append (strawberry_button);
        append (bubblegum_button);
        append (grape_button);
        append (cocoa_button);
        append (slate_button);
        //append (auto_button);

        accent_color_action = new SimpleAction.stateful ("prefers-accent-color", GLib.VariantType.INT32, new Variant.int32 (Themes.IDK));
        var action_group = new SimpleActionGroup ();
        action_group.add_action (accent_color_action);
        insert_action_group ("popover", action_group);

        accent_color_action.activate.connect (set_broadcast);
    }

    // Ignore if user switches from same value to same value
    // Only send signal if it is a user action, to avoid a deathloop if theme is changed elsewhere
    private void set_broadcast (GLib.Variant? value) {
        if (!accent_color_action.get_state ().equal (value)) {
            accent_color_action.set_state (value);
            theme_changed ((Jorts.Themes)color);
        }
    }
}
