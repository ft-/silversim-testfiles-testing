default
{
	state_entry()
	{
		osRegionNotice("Hello");
		osRegionRestart(120f);
		osConsoleCommand("help");
	}
}