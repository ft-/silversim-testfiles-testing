//#!Mode:ASSL
//#!Enable:Testing

default
{
	state_entry()
	{
		float var;
		_test_Result(FALSE);
		llSay(PUBLIC_CHANNEL, var + " <= Variable");
		_test_Result(TRUE);
		_test_Shutdown();
	}
}