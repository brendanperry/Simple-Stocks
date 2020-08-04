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
        //key = "Tpk_e1eb49050d7c403496493e757960f5f2"; // sandbox key
        key = "pk_6c967fa2c1154e178644dc481cd95bc4";
        var session = new Soup.Session ();
        
        var price_message = GetData (ticker, key, "latestPrice");
        
        session.queue_message (price_message, () => {
            if (price_message.status_code == Soup.Status.OK) {
                var current_price = Round ((string) price_message.response_body.data);
                UpdateCardsWithPrice (card, current_price);
                
                var previous_price = GetData (ticker, key, "previousClose");
                
                session.queue_message (previous_price, () => {
                    if (previous_price.status_code == Soup.Status.OK) {
                        var close_price = Round ((string) previous_price.response_body.data);
                        UpdateCardsWithPercentage (card, close_price);
                        
                    } else {
                        HandleError ((int) previous_price.status_code, card);
                    }
                });
            } else {
                HandleError ((int) price_message.status_code, card);
            }
        });
    }

    private Soup.Message GetData (string ticker, string key, string item) {
        if (ticker == "") {
            ticker = "-";
        }
        
        var api = 
            "https://cloud.iexapis.com/stable/stock/" 
            + ticker 
            + "/quote/"
            + item 
            + "?token=" 
            + key;
            
        var message = new Soup.Message (
            "GET",
            api
        );
        
        message.request_headers.append (
            "Content-Type", 
            "application/json; charset=utf-8"
        );

        return message;
    }

    private void HandleError (int status, StockCard card) {
        string message;
        
        switch (status) {
            case 400:
                message = "Incorrect Values";
                break;
            case 402:
                message = "API Limit Reached";
                break;
            case 403:
                message = "Invalid API Token";
                break;
            case 404: 
                message = "Resource Not Found";
                break;
            case 500:
                message = "Server Failure";
                break;
            default:
                message = "Something Went Wrong";
                break;
        }
        
        card.GetCards ().GetApp ().ShowInfoBar (message);
    }

    private string Round (string price) {
        char[] newString = new char[25];
        
        /*
            We have to check for a period because doubles lose the
            .00 when converted to a string
        */
        var j = 0;
        var hasPeriod = false;
        while (j < price.length) {
            if ((char) price.get_char (j) == '.') {
                hasPeriod = true;
            }
            j++;
        }
        
        int i = 0;
        if (hasPeriod) {
            while (price.get_char (i) != '.') {
                newString[i] = (char) price.get_char (i);
                i++;
            }
            
            newString[i] = '.';
            newString[i + 1] = (char) price.get_char (i + 1);
            newString[i + 2] = (char) price.get_char (i + 2);
        } else {
            while (i < price.length) {
                newString[i] = (char) price.get_char (i);
                i++;
            }
            
            newString[i] = '.';
            newString[i + 1] = '0';
            newString[i + 2] = '0';
        }

        return ((string) newString);
    }

    private void UpdateCardsWithPrice (StockCard card, string price) {
        card.SetPrice (price);
    }
    
    private void UpdateCardsWithPercentage (StockCard card, string close_price) {
        var chars = card.GetPrice ().length;
        var price = card.GetPrice ().substring (1, chars - 1);

        var price_double = double.parse (price);
        var close_double = double.parse (close_price);
        
        double percent = ((price_double - close_double) / close_double) * 100;
        char[] buf = new char[double.DTOSTR_BUF_SIZE];
        string string_double = percent.to_str (buf);
        string rounded_percent = Round (string_double);
        string final_percent;
        
        if (percent > 0) {
            final_percent = "+" + rounded_percent + "%";
        } else if (percent < 0) {
            final_percent = "-" + rounded_percent + "%";
        } else {
            final_percent = rounded_percent + "%";
        }
        
        card.UpdatePercentage (final_percent);
    }
}
