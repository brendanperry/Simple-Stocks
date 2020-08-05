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
            resizable = false,
            default_height = 480,
            default_width = 400
        };
        
        main_window.get_style_context ().add_class ("main");

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);
        header.set_title (_("Simple Stocks"));
        
        // var gtk_settings = Gtk.Settings.get_default ();

        // var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        //   mode_switch.primary_icon_tooltip_text = _("Light background");
        //   mode_switch.secondary_icon_tooltip_text = _("Dark background");
        //   mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        // 
        // header.pack_end (mode_switch);
        
        main_window.set_titlebar (header);
        
        var grid = new CardGrid ();
        
        var api = new ApiKey ();
        string key = api.Get ();
        
        var cards = new Cards (grid, this, key);
        Local.LoadCards (cards);
        cards.AddCard ("empty");
        
        Gtk.ScrolledWindow scroll_view = new Gtk.ScrolledWindow (null, null);
        scroll_view.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroll_view.add (grid);
        
        var info_bar_and_scroll_view_container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        info_bar_and_scroll_view_container.pack_start (
            CreateInfoBar (cards), 
            false, 
            true, 
            0
        );
        info_bar_and_scroll_view_container.pack_start (scroll_view, true, true, 0);
        info_bar_and_scroll_view_container.show ();
        
        main_window.add (info_bar_and_scroll_view_container);
        main_window.show_all ();
        
        GetNewCardDataEveryMinute (cards);
    }
    
    private void GetNewCardDataEveryMinute (Cards cards) {
        var timeout = Timeout.add (60000, () => {
            cards.UpdateCardData ();
            return true;
        });
    }
    
    private Gtk.InfoBar info_bar;
    private Gtk.Label info_label;
    
    private Gtk.InfoBar CreateInfoBar (Cards cards) {
        info_bar = new Gtk.InfoBar ();
        info_bar.message_type = Gtk.MessageType.WARNING;
        info_label = new Gtk.Label ("Warning");
        info_bar.get_content_area ().add (info_label);
        var info_bar_button = info_bar.add_button ("Try Again", 0);
        
        info_bar_button.clicked.connect (() => {
                cards.UpdateCardData ();
		        info_bar.set_revealed (false);
	        });
	        
        info_bar.set_revealed (false);
        
        return info_bar;
    }
    
    public void ShowInfoBar (string message) {
        info_label.set_text (message);
        info_bar.set_revealed (true);
    }

    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
