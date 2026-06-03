/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

public class Jorts.Autostart {

    Xdp.Portal portal;
    GenericArray<weak string> cmd;

    //public signal void result (bool if_accepted);

    public Autostart () {
        portal = new Xdp.Portal ();
        cmd = new GenericArray<weak string> ();
        cmd.add (APP_ID);
    }

    public async void request_set () {
        try {
            var result = yield portal.request_background (
                null,
                _("Set Jorts to start with the computer"),
                cmd,
                Xdp.BackgroundFlags.AUTOSTART,
                null);

            print ("Autostart set: %b", result);

        } catch (Error e) {
            warning (e.message);
        }

    }

    public async void request_remove () {
        try {
            var result = yield portal.request_background (
                null,
                _("Remove Jorts from system autostart"),
                cmd,
                Xdp.BackgroundFlags.NONE,
                null);

            print ("Autostart remove: %b", result);

        } catch (Error e) {
            warning (e.message);
        }
    }
}
