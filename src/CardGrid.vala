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

public class CardGrid : Gtk.Grid {
    private Gtk.Widget lastWidget;
    
    public void AttachFirst (Gtk.Widget widget) {
        this.attach (widget, 0, 0, 1, 1);
        lastWidget = widget;
    }
    
    public void Attach (Gtk.Widget widget) {
        this.attach_next_to (widget, lastWidget, Gtk.PositionType.RIGHT, 1, 1);
        lastWidget = widget;
    }
}
