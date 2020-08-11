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

public class ApiKey {
    public string Get () {
    	File file = File.new_for_path ("api-key.txt");
    	
        try {
		    FileInputStream f_stream = file.read ();
		    DataInputStream d_stream = new DataInputStream (f_stream);
		    string key = d_stream.read_line ();
		    
		    if (key == null) {
		        print ("No key found");
		        return "no-key-found";
		    }
		    
		    return key;
	    } catch (Error e) {
		    print ("Error: %s\n", e.message);
	    }
	    
	    return "no-key-found";
    }
    
    public void Set (string key) {
    	File file = File.new_for_path ("api-key.txt");
    
        try {
			FileOutputStream f_stream = file.replace (null, false, FileCreateFlags.NONE);
			DataOutputStream d_stream = new DataOutputStream (f_stream);
			d_stream.put_string (key);
		} catch (Error e) {
			print ("Error: %s\n", e.message);
		}
    }
}
