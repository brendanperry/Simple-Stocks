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

public class Cards {
    private Array<StockCard> cards;
    CardGrid grid;
    MainPage app;
    private string key;
    
    public Cards (CardGrid grid, MainPage app, string key) {
        cards = new Array<StockCard> ();
        this.app = app;
        this.grid = grid;
        this.key = key;
    }

    public void AddCard(string ticker, string price = "$0.00", string percent = "+0.00%") {
        var new_card = new StockCard (ticker, this, price, percent, key);
        
        if (cards == null) {
            new_card.SetIndex (0);
        } else {
            new_card.SetIndex ((int) cards.length);
        }
        
        new_card.show ();
        
        cards.append_val (new_card);
        grid.Attach (new_card);
        new_card.SetEntryFocus (ticker);
        new_card.UpdatePrice ();
    }
    
    public void UpdateCardData () {
        for (int i = 0; i < cards.length; i++) {
            cards.index (i).UpdatePrice ();
        }
    }
    
    public void Remove (int index) {         
        for (int i = 0; i < cards.length; i++) {
            grid.remove (cards.index (i));
        }
        
        grid.Reset ();
        cards.remove_index (index);
        
        for (int i = 0; i < cards.length; i++) {
            grid.Attach (cards.index (i));
            cards.index (i).SetIndex (i);
        } 
        
        Local.SaveCards (cards);
    }
    
    public Array<StockCard> GetCards () {
        return cards;
    }
    
    public int GetLength () {
        return (int) cards.length;
    }
    
    public MainPage GetApp () {
        return app;
    }
}
