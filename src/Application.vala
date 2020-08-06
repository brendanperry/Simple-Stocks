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
        
        add_window (new LandingPage());
        //add_window (new MainPage());
    }

    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}


