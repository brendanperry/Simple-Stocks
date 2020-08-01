public class Cards {
    private Array<StockCard> cards;
    CardGrid grid;
    
    public Cards (CardGrid grid) {
        cards = new Array<StockCard> ();
        this.grid = grid;
    }

    public void AddCard(string ticker) {
        var newCard = new StockCard (ticker, this);
        newCard.show ();
        cards.append_val (newCard);
        grid.Attach (newCard);
    }
    
    public int GetLength () {
        return (int) cards.length;
    }
}
