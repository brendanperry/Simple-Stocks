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

public class MainPage : Gtk.Window {
    public MainPage (Application app) {
        set_resizable (false);
        set_default_size (400, 480);

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);
        header.set_title (_("Simple Stocks"));
        
        //var gtk_settings = Gtk.Settings.get_default ();

        // var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        //   mode_switch.primary_icon_tooltip_text = _("Light background");
        //   mode_switch.secondary_icon_tooltip_text = _("Dark background");
        //   mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        //   mode_switch.valign = Gtk.Align.CENTER;
        // header.pack_end (mode_switch);
        
        var preferences_button_icon = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        var preferences_button = new Gtk.ToolButton (preferences_button_icon, null);
        preferences_button.tooltip_text = _("Preferences");
        
        preferences_button.clicked.connect (() => {
		        var pop = new Gtk.Popover (preferences_button);
                pop.set_modal (true);
                
                var button = new Gtk.Button.with_label ("Enter new API key");
                
                button.clicked.connect (() => {
	                app.OpenLanding ();
                });
                
                pop.add (button);
                pop.show_all ();
	        });
        
        header.pack_end (preferences_button);
        
        set_titlebar (header);
        
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
        
        add (info_bar_and_scroll_view_container);
        
        GetNewCardDataEveryMinute (cards);
    }
    
    private void GetNewCardDataEveryMinute (Cards cards) {
        var timeout = Timeout.add (60000, () => {
            cards.UpdateCardData ();
            print ("here");
            return true;
        });
    }
    
    private Gtk.InfoBar info_bar;
    private Gtk.Label info_label;
    
    private Gtk.InfoBar CreateInfoBar (Cards cards) {
        info_bar = new Gtk.InfoBar ();
        
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
    
    public void ShowInfoBar (string message, string type) {
        if (type == "Warning") {
            info_bar.message_type = Gtk.MessageType.WARNING;
        } else {
            info_bar.message_type = Gtk.MessageType.ERROR;
        }
        
        info_label.set_text (message);
        info_bar.set_revealed (true);
    }
}

public class LandingPage : Gtk.Window {
    public LandingPage (Application app) {
        set_default_size (500, 500);
        set_resizable (false);
        set_title ("Simple Stocks");
        add (new WelcomeView (app));
    }
}

private class WelcomeView : Gtk.Grid {
    public WelcomeView (Application app) {
        var welcome = new Granite.Widgets.Welcome (_("Welcome"), _("Let's get things ready."));
        welcome.append ("text-x-generic", _("Create an Account"), _("Click here to get your free account with IEX Cloud."));
        welcome.append ("security-high", _("Grab Your API Token"), _("Click here to copy your token."));
        attach (welcome, 0, 0);
        
        get_style_context ().add_class ("white");
        
        var container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        container.get_style_context ().add_class ("white");
        container.halign = Gtk.Align.CENTER;
        container.set_spacing (10);
        
        var button = new Gtk.Button.with_label (_("Continue"));
        button.sensitive = false;
        
        var entry = new Gtk.Entry ();
        entry.placeholder_text = _("Enter your API token.");
        entry.set_width_chars (35);
        container.add (entry);
        
        entry.get_buffer ().inserted_text.connect (() => {
            if (entry.text_length > 20) {
                button.sensitive = true;
            }
        });
        
        entry.backspace.connect(() => {
           if (entry.text_length < 20) {
                button.sensitive = false;
            }
        });
        
        container.add (button);
        
        button.button_press_event.connect (() => {
            var api = new ApiKey ();
            api.Set (entry.get_text ());
            app.OpenMain ();
            return true;
        });
        
        attach (container, 0, 1, 1, 1);
        
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.get_style_context ().add_class ("gray-text");
        box.add (new Gtk.Label (_("Simple Stocks is not affiliated with IEX Cloud. Please do not share your API token.")));
        attach (box, 0, 2, 1, 1);

        welcome.activated.connect ((index) => {
            switch (index) {
                case 0:
                    try {
                        AppInfo.launch_default_for_uri ("https://www.iexcloud.io/cloud-login#/register", null);
                    } catch (Error e) {
                        warning (e.message);
                    }

                    break;
                case 1:
                    try {
                        AppInfo.launch_default_for_uri ("https://iexcloud.io/console", null);
                    } catch (Error e) {
                        warning (e.message);
                    }

                    break;
            }
        });
    }
}
