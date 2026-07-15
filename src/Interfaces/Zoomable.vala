/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

 // vala-lint=skip-file

/*************************************************/
/**
* An object used to package all data conveniently as needed.
*/
public interface Jorts.Zoomable: Gtk.Widget {

    public abstract void on_zoom_changed (int new_zoom);

}
