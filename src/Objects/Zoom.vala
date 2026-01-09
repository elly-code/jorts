/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

/*************************************************/
/**
* A register of all possible zoom values we have
*/
public enum Jorts.Zoom {
    ANTSIZED,
    MUCHSMALLER,
    SMALLER,
    SMALL,
    NORMAL,
    BIG,
    BIGGER,
    MUCHBIGGER,
    MUCHMUCHBIGGER,
    HUGE,
    SUPERHUGE,
    MEGAHUGE,
    ULTRAHUGE,
    MASSIVE,
    URPARENT;

    /*************************************************/
    /**
    * Returns an Int representation we can use to display and store the value
    */
    public int to_int () {
        switch (this) {
            case ANTSIZED: return 20;
            case MUCHSMALLER: return 40;
            case SMALLER: return 60;
            case SMALL: return 80;
            case NORMAL: return 100;
            case BIG: return 120;
            case BIGGER: return 140;
            case MUCHBIGGER: return 160;
            case MUCHMUCHBIGGER: return 180;
            case HUGE: return 200;
            case SUPERHUGE: return 220;
            case MEGAHUGE: return 240;
            case ULTRAHUGE: return 260;
            case MASSIVE: return 280;
            case URPARENT: return 300;
            default: return 100;
        }
    }

    /*************************************************/
    /**
    * CSS name is s + size. CSS classes cannot start name with number
    */
    public string to_css_class () {
        return "s" + this.to_int ().to_string ();
    }

    /*************************************************/
    /**
    * We cannot save Enums in JSON, so this recovers the enum from stored int
    */
    public static Zoom from_int (int wtf_is_this) {
        switch (wtf_is_this) {
            case 20: return ANTSIZED;
            case 40: return MUCHSMALLER;
            case 60: return SMALLER;
            case 80: return SMALL;
            case 100: return NORMAL;
            case 120: return BIG;
            case 140: return BIGGER;
            case 160: return MUCHBIGGER;
            case 180: return MUCHMUCHBIGGER;
            case 200: return HUGE;
            case 220: return SUPERHUGE;
            case 240: return MEGAHUGE;
            case 260: return ULTRAHUGE;
            case 280: return MASSIVE;
            case 300: return URPARENT;
            default: return NORMAL;
        }
    }

    /*************************************************/
    /**
    * We have to scale some UI elements according to zoom
    */
    public int to_ui_size () {
        switch (this) {
            case ANTSIZED: return 24;
            case MUCHSMALLER: return 26;
            case SMALLER: return 28;
            case SMALL: return 30;
            case NORMAL: return 32;
            case BIG: return 34;
            case BIGGER: return 38;
            case MUCHBIGGER: return 40;
            case MUCHMUCHBIGGER: return 44;
            case HUGE: return 48;
            case SUPERHUGE: return 52;
            case MEGAHUGE: return 54;
            case ULTRAHUGE: return 56;
            case MASSIVE: return 60;
            case URPARENT: return 64;
            default: return 32;
        }
    }
}