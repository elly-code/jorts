/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

namespace Jorts.Utils {
    public void autostart_remove () {
        Xdp.Portal portal = new Xdp.Portal ();
        GenericArray<weak string> cmd = new GenericArray<weak string> ();
        cmd.add ("io.github.ellie_commons.jorts");

        portal.request_background.begin (
            null,
            _("Remove Jorts from system autostart"),
            cmd,
            Xdp.BackgroundFlags.NONE,
            null);
    }

    public void autostart_set () {
        Xdp.Portal portal = new Xdp.Portal ();
        GenericArray<weak string> cmd = new GenericArray<weak string> ();
        cmd.add ("io.github.ellie_commons.jorts");

        portal.request_background.begin (
            null,
            _("Set Jorts to start with the computer"),
            cmd,
            Xdp.BackgroundFlags.AUTOSTART,
            null);
    }
}
