//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        q = llRequestInventoryData("Landmark");
    }
    
    dataserver(key r, string data)
    {
        if(r != q)
        {
            llSay(PUBLIC_CHANNEL, "Invalid query response: " + r + "!=" + q);
            _test_Shutdown();
            return;
        }
    
        llSay(PUBLIC_CHANNEL, data);
        _test_Result(data=="<-8867.8408,-8869.0385,21.26741>");
        _test_Shutdown();
    }
}
