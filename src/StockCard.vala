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
    private GetApiData api;

    public StockCard(string ticker) {
        set_orientation (Gtk.Orientation.VERTICAL);
        this.get_style_context ().add_class ("card");
        
        price = "Loading Data";
        
        var tickerLabel = new Gtk.Label (ticker);
        priceLabel = new Gtk.Label (price);
        
        add (tickerLabel);
        add (priceLabel);
    }
    
    public void UpdateCard () {
        api = new GetApiData ();
        price = api.HttpGet ("AAPL", "key");
        priceLabel.set_label (price);
    }
}
