// Proximity plugin for RealFire
// A simple example script for creating your own plugin
//
// Automatically switches on when an avatar comes within 10 meters
// Automatically switches off after one minute when no avatars are in range

///////////////////////////////////////////////////////////////////////////////
// HOW TO USE: drop this into the same prim where the FIRE SCRIPT is located //
///////////////////////////////////////////////////////////////////////////////

key owner;                // object owner
integer number = 10959;   // number part of link message
float range = 10.0;       // scan range in meters
float rate = 10.0;        // scan rate in seconds

default
{
    state_entry()
    {
        owner = llGetOwner();
        llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }

    sensor(integer total_number)
    {
        rate = 60.0;
        llMessageLinked(LINK_THIS, number, "on", owner);
        llSensorRemove();
        llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
    }

    no_sensor()
    {
        rate = 10.0;
        llMessageLinked(LINK_THIS, number, "off", owner);
        llSensorRemove();
        llSensorRepeat("", "", AGENT_BY_USERNAME, range, PI, rate);
    }
}
