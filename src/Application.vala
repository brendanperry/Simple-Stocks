/*
* Copyright (c) 2020 Your Organization (https://brendanperry.me)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Author <bperry@hey.com>
*/

const string GETTEXT_PACKAGE = "...";

public class MyApp : Gtk.Application {
    public MyApp () {
        Object (
            application_id: "com.github.brendanperry.stocks",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var css_provider = new Style().GetCssProvider ();

        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var main_window = new Gtk.ApplicationWindow (this) {
            title = _("Stocks"),
            resizable = false,
            default_height = 480
        };

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);
        header.set_title ("Simple Stocks");
        main_window.set_titlebar (header);

        var grid = new CardGrid ();

        var cards = new Cards (grid);
        cards.AddCard ("APPL");
        cards.AddCard ("empty");
        
        Gtk.ScrolledWindow scroll_view = new Gtk.ScrolledWindow (null, null);
        scroll_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll_view.add (grid);
        
        main_window.add (scroll_view);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
