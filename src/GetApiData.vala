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
    public string HttpGet (string ticker, string key) {
        key = "Tpk_e1eb49050d7c403496493e757960f5f2"; // sandbox key
        var session = new Soup.Session ();
        var api = "https://sandbox.iexapis.com/stable/stock/XOM/quote?token=" + key;

        var message = new Soup.Message (
        "GET",
        api
        );

        message.request_headers.append ("Content-Type", "application/json; charset=utf-8");

        var current_price = "Loading";
        
        session.queue_message (message, () => {
            if (message.status_code == Soup.Status.OK) {
                current_price = GetCurrentPrice (message);
                UpdateCardsWithPrice (currentPrice);
            } else {
                UpdateCardsWithFailure ();
            }
        });
        
        return current_price;
    }

    private string GetCurrentPrice (Soup.Message msg) {
        var parser = new Json.Parser ();
        parser.load_from_data ( (string) msg.response_body.data);

        var obj = parser.get_root ().get_object ();

        double price_decimal = obj.get_double_member ("latestPrice");

        char[] buf = new char [double.DTOSTR_BUF_SIZE];
        string str = price_decimal.to_str (buf);

        return (str);
    }
    
    private void UpdateCardsWithFailure () {
        print ("We failed bois");
        /*
            This will set the card to a failed state
        */
    }
    
    private void UpdateCardsWithPrice (string price) {
        print (price);
        /*
            This will update the cards once the information has loaded from the api
        */
    }
}
