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

public class CardGrid : Gtk.FlowBox {
    private Gtk.Widget lastWidget;
    private bool attach_left = true;
    private int rows = 0;
    
    public CardGrid () {
        set_margin_start (40);
        set_margin_end (40);
        set_margin_top (40);
        set_margin_bottom (40);
        set_column_spacing (40);
        set_row_spacing (40);
    }
    
    public void Attach (Gtk.Widget widget) {
        add (widget);
    }
    
    /*
    public void Attach (Gtk.Widget widget) {
        if (attach_left) {
            this.attach (widget, 0, rows, 1, 1);
            attach_left = false;
        } else {
            this.attach (widget, 1, rows++, 1, 1);
            attach_left = true;
        }
    }
    
    public void RemoveLast () {
        
    }*/
}
