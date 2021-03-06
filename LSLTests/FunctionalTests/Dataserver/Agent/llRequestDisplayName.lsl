//#!Enable:testing

key q;

default
{
    state_entry()
    {
        _test_Result(FALSE);
        q = llRequestDisplayName(llGetOwner());
        llSay(PUBLIC_CHANNEL, "Query " + (string)q);
    }
    
    dataserver(key r, string data)
    {
        if(r != q)
        {
            llSay(PUBLIC_CHANNEL, "Invalid query response: " + r + "!=" + q);
        }
        else
        {
            llSay(PUBLIC_CHANNEL, "\"" + data + "\"");
            _test_Result(data == "Script Test");
        }
        _test_Shutdown();
    }
}
