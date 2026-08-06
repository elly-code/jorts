/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

int main (string[] args) {

#if DEVEL

    // Do not overwrite environment, just show our apps debugs by default on devel builds
    var new_messages_domain = "%s %s".printf (Environment.get_variable ("G_MESSAGES_DEBUG"), APP_ID);

    //GLib.Environment.set_variable ("LANGUAGE", "C", true);
    GLib.Environment.set_variable ("GTK_DEBUG", "interactive", true);
    GLib.Environment.set_variable ("G_MESSAGES_DEBUG", new_messages_domain, true);
    //print (LOCALEDIR);

    warning ("""
    ----------------------------------------
    You are running a development version.
    Here be dragons.
    Tread carefully.
    ----------------------------------------
    """);

#endif

        print ("""
🎉✨ ACTIVATING: SUPER COOL JORTS 😎🔥❗🎶🤌
Your Notes are all belong to us!
      _       _
    (\o/)   (\o/)    <--- Tiny electric angels working in the background
     /_\     /_\

Please wait while the app remembers all the things…
""");

    return new Jorts.Application ().run (args);
}
