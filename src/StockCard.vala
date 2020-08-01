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

public class StockCard: Gtk.Box {
    private string price;
    private Gtk.Label priceLabel;
    private Gtk.Label percentageLabel;
    private GetApiData api;

    public StockCard(string ticker, Cards cards) {
        set_orientation (Gtk.Orientation.VERTICAL);
        this.get_style_context ().add_class ("card");
        
        if (ticker == "empty") {
            CreateEmptyCard (cards);
        } else {
            CreateNewCard (ticker, cards);
        }
    }
    
    public void UpdateCard () {
        api = new GetApiData ();
        price = api.HttpGet ("AAPL", "key");
        priceLabel.set_label (price);
    }
    
    private void CreateEmptyCard (Cards cards) {
        set_spacing (8);
        
        var label = new Gtk.Label ("Add New");
        add (label);
        
        var entry = new Gtk.Entry();
        
        entry.max_length = 4;
        entry.set_max_width_chars (12);
        entry.set_width_chars (12);
        entry.xalign = (float) 0.5;
        
        entry.activate.connect (() => {
           cards.AddCard (entry.text);
           cards.AddCard ("Empty");
        });
        
        add (entry);
    }
    
    private void CreateNewCard (string ticker, Cards cards) {
        set_spacing (10);
        price = "$1000.00"; // Get Real Price soon
    
        var tickerLabel = new Gtk.Label (ticker);
        add (tickerLabel);
        
        priceLabel = new Gtk.Label (price);
        percentageLabel = new Gtk.Label ("+3.0%");
        
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        box.set_spacing (20);
        box.add (priceLabel);
        box.add (percentageLabel);
        
        tickerLabel.show ();
        priceLabel.show ();
        percentageLabel.show ();
        box.show ();
        
        add (box);
    }
}
