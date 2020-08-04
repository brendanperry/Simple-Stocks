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
    
    Gtk.InfoBar info_bar;
    Gtk.Label info_label;

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
            default_height = 480,
            default_width = 400
        };
        
        main_window.get_style_context ().add_class ("main");

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);
        header.set_title ("Simple Stocks");
        main_window.set_titlebar (header);
        
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.show ();
        main_window.add (box);
        
        info_bar = new Gtk.InfoBar ();
        info_bar.message_type = Gtk.MessageType.WARNING;
        info_label = new Gtk.Label ("Warning");
        info_bar.get_content_area ().add (info_label);
        info_bar.set_show_close_button (true);
        info_bar.add_button ("Try Again", 0);
        info_bar.set_revealed (false);
        box.pack_start (info_bar, false, true, 0);

        var grid = new CardGrid ();

        var cards = new Cards (grid, this);
        cards.AddCard ("empty");
        
        Gtk.ScrolledWindow scroll_view = new Gtk.ScrolledWindow (null, null);
        scroll_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll_view.add (grid);
        
        box.pack_start (scroll_view, true, true, 0);
        main_window.show_all ();
        
        var timeout = Timeout.add (60000, () => {
            cards.UpdateCardData ();
            return true;
        });
    }
    
    public void ShowInfoBar (string message) {
        info_label.set_text (message);
        info_bar.set_revealed (true);
    }
    
    private void UpdateData (Cards cards) {
        cards.UpdateCardData ();
    }

    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
