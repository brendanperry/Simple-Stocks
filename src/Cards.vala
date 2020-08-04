public class Cards {
    private Array<StockCard> cards;
    CardGrid grid;
    MyApp app;
    
    public Cards (CardGrid grid, MyApp app) {
        cards = new Array<StockCard> ();
        this.app = app;
        this.grid = grid;
    }

    public void AddCard(string ticker) {
        var new_card = new StockCard (ticker, this);
        
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
        } 
    }
    
    public int GetLength () {
        return (int) cards.length;
    }
    
    public MyApp GetApp () {
        return app;
    }
}
