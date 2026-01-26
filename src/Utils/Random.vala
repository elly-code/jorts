/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/* CONTENT
randrange does not include upper bound.

random_theme(skip_theme)
random_title()
random_emote(skip_emote)
random_note(skip_theme)

*/
namespace Jorts.Utils {

    /*************************************************/
    /**
    * Placeholders for titles
    */
    ///TRANSLATORS: It does not need to match source 1:1 - avoid anything that could be rude or cold sounding
    public string random_title () {
        string[] alltitles = {
            _("All my very best friends"),
            _("My super good secret recipe"),
            _("My todo list"),
            _("Super secret to not tell anyone"),
            _("My grocery list"),
            _("Random shower thoughts"),
            _("My fav fanfics"),
            _("My fav dinosaurs"),
            _("My evil mastermind plan"),
            _("What made me smile today"),
            _("Hello world!"),
            _("New sticky, new me"),
            _("Hidden pirate treasure"),
            _("To not forget, ever"),
            _("Dear Diary,"),
            _("Have a nice day! :)"),
            _("My meds schedule"),
            _("Household chores"),
            _("Ode to my cat"),
            _("My dogs favourite toys"),
            _("How cool my birds are"),
            _("Suspects in the Last Cookie affair"),
            _("Words my parrots know"),
            _("Cool and funny compliments to give out"),
            _("Ok, listen here,"),
            _("My dream Pokemon team"),
            _("My little notes"),
            _("Surprise gift list"),
            _("Brainstorming notes"),
            _("To bring to the party"),
            _("My amazing mixtape"),
            _("Napkin scribblys"),
            _("My fav songs to sing along"),
            _("When to water which plant"),
            _("Top 10 anime betrayals"),
            _("Amazing ascii art!"),
            _("For the barbecue"),
            _("My favourite bands"),
            _("Best ingredients for salad"),
            _("Books to read"),
            _("Places to visit"),
            _("Hobbies to try out"),
            _("Who would win against Goku"),
            _("To plant in the garden"),
            _("Meals this week"),
            _("Everyone's pizza order"),
            _("Today selfcare to do"),
            _("Important affirmations to remember"),
            _("The coolest linux apps"),
            _("My favourite dishes"),
            _("My funniest jokes"),
            _("The perfect breakfast has...")
        };
        return alltitles[Random.int_range (0, alltitles.length)];
    }

    /*************************************************/
    /**
    * Generates emotes for the emote menu button
    * Optionally, skips one (typically the one to change from)
    */
    public string random_emote (string? skip_emote = null) {
        Gee.ArrayList<string> allemotes = new Gee.ArrayList<string> ();
        allemotes.add_all_array (Jorts.Constants.EMOTES);

        if (skip_emote != null) {
            allemotes.remove (skip_emote);
        }

        var random_in_range = Random.int_range (0, allemotes.size);
        return allemotes[random_in_range];
    }

    /*************************************************/
    /**
    * Hey! Looking in the source code is cheating!
    * Only for new notes which are not the first one
    */
    public NoteData golden_sticky (NoteData blank_slate) {

        var random_in_range = Random.int_range (0, 1000);

        // ONE IN THOUSAND
        if (random_in_range == 1) {

            print ("🔥🔥🔥GOLDEN STICKY🔥🔥🔥");
            ///TRANSLATORS: This is for an easter egg
            blank_slate.title = _("🔥WOW Congratulations!🔥");
            blank_slate.content = _(
"""You have found the Golden Sticky Note!

CRAZY BUT TRU: This message appears once in a thousand times!
Nobody will believe you hehehe ;)

I hope my little app brings you a lot of joy
Have a great day!🎇
""");
            blank_slate.theme = Jorts.Themes.BANANA;
        }

        return blank_slate;
    }
}
