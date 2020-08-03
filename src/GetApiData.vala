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

public class GetApiData {
    public void HttpGet (StockCard card, string ticker, string key) {
        key = "Tpk_e1eb49050d7c403496493e757960f5f2"; // sandbox key
        var session = new Soup.Session ();
        var api = "https://sandbox.iexapis.com/stable/stock/XOM/quote?token=" + key;

        var message = new Soup.Message (
        "GET",
        api
        );

        message.request_headers.append ("Content-Type", "application/json; charset=utf-8");
        
        session.queue_message (message, () => {
            if (message.status_code == Soup.Status.OK) {
                var current_price = GetCurrentPrice (message);
                UpdateCardsWithPrice (card, current_price);
            } else {
                DisplayErrorInfoBar ();
            }
        });
    }

    private string GetCurrentPrice (Soup.Message msg) {
        var parser = new Json.Parser ();
        parser.load_from_data ((string) msg.response_body.data);

        var obj = parser.get_root ().get_object ();
        
        double price_decimal = obj.get_double_member ("latestPrice");

        char[] buf = new char [10];
        string str = price_decimal.to_str (buf);
        
        RoundPrice (str);

        return (RoundPrice (str));
    }
    
    private void DisplayErrorInfoBar () {
        print ("Unable to Connect");
    }
    
    private string RoundPrice (string price) {
        int i = 0;
        char[] newString = new char[10];
        
        while (price.get_char (i) != '.') {
            
            newString[i] = (char) price.get_char (i);
            i++;
        }
        
        newString[i] = '.';
        newString[i + 1] = (char) price.get_char (i + 1);
        newString[i + 2] = (char) price.get_char (i + 2);
        
        return ((string) newString);
    }
    
    private void UpdateCardsWithPrice (StockCard card, string price) {
        card.SetPrice (price);
    }
}

/*
round price
make sure all stocks can be added like BRK-A
check if stocks are valid or not, handle get req probably
popup for when connection fails
style everything up
add dark mode
*/
