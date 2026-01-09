/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-codes/)
 */

 /*************************************************/
/**
* Used in a signal to tell windows in which way to change zoom
*/
 public enum Jorts.Zoomkind {
    ZOOM_OUT,
    DEFAULT_ZOOM,
    ZOOM_IN,
    NONE;

    public static Zoomkind from_delta (double delta) {

        if (delta == 0) {return NONE;}

        if (delta > 0)
        {
            return ZOOM_OUT;

        } else {
            return ZOOM_IN;
        }
    }
}