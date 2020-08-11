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

public class Local {
    public static void SaveCards (Array<StockCard> cards) {
        var builder = new Json.Builder ();
        
        builder.begin_array ();
        
        for (int i = 0; i < cards.length; i++) {
            if (cards.index (i).GetTicker () != "Add New") {
                SaveObjectToBuilder (builder, cards, i);
            }
        }
        
        builder.end_array ();
        
        var generator = new Json.Generator ();
        var node = builder.get_root ();
        generator.set_root (node);
        
        generator.to_file ("stock-list.json");
    }
    
    private static void SaveObjectToBuilder (Json.Builder builder, Array<StockCard> cards, int i) {
        builder.begin_object ();
        
        builder.set_member_name ("ticker");
        builder.add_string_value (cards.index (i).GetTicker ());
        
        builder.set_member_name ("price");
        builder.add_string_value (cards.index (i).GetPrice ());
        
        builder.set_member_name ("percent");
        builder.add_string_value (cards.index (i).GetPercentage ());
        
        builder.end_object ();
    }
    
    public static static void LoadCards (Cards cards) {
        var parser = new Json.Parser ();
        
        try {
            parser.load_from_file ("stock-list.json");
            var node = parser.get_root ();
            
            if (node != null) {
                AddItemsFromArray (cards, node.get_array());
            }
        } catch (Error e) {
            print ("No saved stocks found.");
        }
    }
    
    private static void AddItemsFromArray (Cards cards, Json.Array array) {
        foreach (Json.Node item in array.get_elements ()) {
            var obj = item.get_object ();
            
            var ticker = obj.get_string_member ("ticker");
            var price = obj.get_string_member ("price");
            var percent = obj.get_string_member ("percent");
            
            cards.AddCard (ticker, price, percent);
        }
    }
}
