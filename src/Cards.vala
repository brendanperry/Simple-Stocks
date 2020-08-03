public class Cards {
    private Array<StockCard> cards;
    private Array<Gtk.EventBox> boxes;
    CardGrid grid;
    
    public Cards (CardGrid grid) {
        cards = new Array<StockCard> ();
        boxes = new Array<Gtk.EventBox>();
        
        this.grid = grid;
    }

    public void AddCard(string ticker) {
        var new_card = new StockCard (ticker, this);
        
        if (cards == null) {
            new_card.SetIndex (0);
        } else {
            new_card.SetIndex ((int) cards.length);
        }
        
        var event_box = new Gtk.EventBox ();
        
        event_box.button_press_event.connect (() => {
            if(ticker != "empty") {
                var pop = new Gtk.Popover (new_card);
                pop.set_modal (true);
                
                var button = new Gtk.Button.with_label ("Remove");
                
                button.clicked.connect (() => {
			        Remove (new_card.GetIndex ());
		        });
		        
                pop.add (button);
                pop.show_all ();
            }
            
            return true;
        });
        
        new_card.show ();
        event_box.add (new_card);
        
        event_box.show ();
        
        cards.append_val (new_card);
        boxes.append_val (event_box);
        grid.Attach (event_box);
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
            grid.remove (boxes.index (i));
        }
        
        grid.Reset ();
        cards.remove_index (index);
        boxes.remove_index (index);
        
        for (int i = 0; i < cards.length; i++) {
            grid.Attach (boxes.index (i));
        } 
    }
    
    public int GetLength () {
        return (int) cards.length;
    }
}
