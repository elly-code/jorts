/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*************************************************/
/**
* A register of all themes we have
*/
public enum Jorts.Themes {
    BLUEBERRY,
    MINT,
    LIME,
    BANANA,
    ORANGE,
    STRAWBERRY,
    BUBBLEGUM,
    GRAPE,
    COCOA,
    SLATE,
    LATTE,
    IDK;

    /*************************************************/
    /**
    * for use in CSS. Ex: @BLUEBERRY_500
    */
    public string to_string () {
        switch (this) {
            case BLUEBERRY:     return "BLUEBERRY";
            case MINT:          return "MINT";
            case LIME:          return "LIME";
            case BANANA:        return "BANANA";
            case ORANGE:        return "ORANGE";
            case STRAWBERRY:    return "STRAWBERRY";
            case BUBBLEGUM:     return "BUBBLEGUM";
            case GRAPE:         return "GRAPE";
            case COCOA:         return "COCOA";
            case SLATE:         return "SLATE";
            case LATTE:         return "LATTE";
            case IDK:           return (Jorts.Themes.random_theme (NoteData.latest_theme)).to_string ();
            default: return "BLUEBERRY";
        }
    }

    /*************************************************/
    /**
    * for use to pinpoint to the correct elementary stylesheet
    */
    public string to_css_class () {
        return this.to_string ().ascii_down ();
    }

    /*************************************************/
    /**
    * for the UI, as translated, proper name
    */
    public string to_nicename () {
        switch (this) {
            ///TRANSLATORS: These are the names of the elementary OS colours
            case BLUEBERRY:     return _("Blueberry");
            case MINT:          return _("Mint");
            case LIME:          return _("Lime");
            case BANANA:        return _("Banana");
            case ORANGE:        return _("Orange");
            case STRAWBERRY:    return _("Strawberry");
            case BUBBLEGUM:     return _("Bubblegum");
            case GRAPE:         return _("Grape");
            case COCOA:         return _("Cocoa");
            case SLATE:         return _("Slate");
            case LATTE:         return _("Latte");
            case IDK:           return _("No preference, random each time");
            default:            return _("Blueberry");
        }
    }

    /*************************************************/
    /**
    * convenient list of all supported themes
    */
    public static Themes[] all () {
        return {BLUEBERRY, MINT, LIME, BANANA, ORANGE, STRAWBERRY, BUBBLEGUM, GRAPE, COCOA, SLATE};
    }

    /*************************************************/
    /**
    * convenient list of all supported themes
    */
    public static string[] all_string () {
        return {"BLUEBERRY", "MINT", "LIME", "BANANA", "ORANGE", "STRAWBERRY", "BUBBLEGUM", "GRAPE", "COCOA", "SLATE"};
    }

    /*************************************************/
    /**
    * Used for new notes without data. Optionally allows to skip one
    * This avoids generating notes "randomly" with the same themes, which would be boring
    */
    public static Jorts.Themes random_theme (Jorts.Themes? skip_theme = null) {
        Gee.ArrayList<Jorts.Themes> themes = new Gee.ArrayList<Jorts.Themes> ();
        themes.add_all_array (Jorts.Themes.all ());

        if (skip_theme != null) {
            themes.remove (skip_theme);
        }

        var random_in_range = Random.int_range (0, themes.size);
        return themes[random_in_range];
    }
}
