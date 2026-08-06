/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

/*************************************************/
/**
 * Implemented by childs of ZoomedWindow
 */
public interface Jorts.Zoomable : Gtk.Widget {

    /**
     * Called by ZoomedWindow after changing zoom value.
     *
     * The default implementation does nothing.
     *
     * If you need to do some changes, such as display the new value, or refresh some displayed elements, override this.
     */
    public virtual void on_zoom_changed (int new_zoom) {
        debug ("Zoom changed: %i", new_zoom);
        return;
    }
}
