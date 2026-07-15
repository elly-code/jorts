/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

int main (string[] args) {

#if DEVEL

    //GLib.Environment.set_variable ("LANGUAGE", "C", true);
    GLib.Environment.set_variable ("GTK_DEBUG", "interactive", true);
    //print (LOCALEDIR);

    warning ("""
    ----------------------------------------
    You are running a development version.
    Here be dragons.
    Tread carefully.
    ----------------------------------------
    """);

#endif

    return new Jorts.Application ().run (args);
}
