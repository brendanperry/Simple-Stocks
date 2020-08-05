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
