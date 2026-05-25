/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

 /*************************************************/
/**
 * Used in a signal to tell windows in which way to change zoom
 */
public enum Jorts.ListPrefix {
    DISABLED,
    BULLET,
    DASH;

    /**
    * Safe way to convert from gsettings back to ListPrefix
    */
    public static ListPrefix from_int (int number) {
      switch (number) {
        case 0: return DISABLED;
        case 1: return BULLET;
        case 2: return DASH;
        default: return BULLET;
      }
    }

    /**
     * Character representation to be used
     */
    public string to_string () {
        switch (this) {
            case 0: return "";
            case 1: return " • ";
            case 2: return " ⁃ ";
            default: return " • ";
        }
    }

    /**
     * Used to display labels in a dropdown in the settings
     */
    public const string[] ALL = {
        N_("(Disabled)"),
        N_(" • Text"),
        N_(" ⁃ Text")
    };
}
