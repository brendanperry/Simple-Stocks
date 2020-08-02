public class Cards {
    private Array<Gtk.EventBox> cards;
    CardGrid grid;
    
    public Cards (CardGrid grid) {
        cards = new Array<Gtk.EventBox> ();
        this.grid = grid;
    }

    public void AddCard(string ticker) {
        var new_card = new StockCard (ticker, this);
        
        var event_box = new Gtk.EventBox ();
        
        event_box.button_press_event.connect (() => {
            
            return true;
        });
        new_card.show ();
        event_box.add (new_card);
        
        event_box.show ();
        
        cards.append_val (event_box);
        grid.Attach (event_box);
        new_card.SetEntryFocus (ticker);
    }
    
    public void Remove (int index) {    
        for (int i = 0; i < cards.length; i++) {
            grid.remove (cards.index (i));
        }
        
        grid.Reset ();
        cards.remove_index (index);
        
        for (int i = 0; i < cards.length; i++) {
            grid.Attach (cards.index (i));
        }
    }
    
    public int GetLength () {
        return (int) cards.length;
    }
}
