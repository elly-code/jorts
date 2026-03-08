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
 public enum Jorts.ZoomType {
    ZOOM_OUT,
    DEFAULT_ZOOM,
    ZOOM_IN,
    NONE;

    public static ZoomType from_delta (double delta) {

        if (delta == 0) {return NONE;}

        if (delta > 0)
        {
            return ZOOM_OUT;

        } else {
            return ZOOM_IN;
        }
    }
}