//#!Mode:ASSL
//#!Enable:ViewerControl
//#!Enable:Testing

vieweragent vagent;
key agentid;
integer result = TRUE;

integer localid;

default
{
    integer localid_received = FALSE;
    integer msg_regionhandshake_received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Logging in agent");
        _test_Result(FALSE);
        localid = _test_ObjectKey2LocalId("11223344-1122-1122-1122-000000000000");
        
        agentid = llGetOwner();
        
        vagent = vcLoginAgent((integer)llFrand(100000) + 100000, 
                "39702429-6b4f-4333-bac2-cd7ea688753e", 
                agentid,
                llGenerateKey(),
                llGenerateKey(),
                "Test Viewer",
                "Test Viewer",
                llMD5String(llGenerateKey(), 0),
                llMD5String(llGenerateKey(), 0),
                TELEPORT_FLAGS_VIALOGIN,
                <128, 128, 23>,
                <1, 0, 0>);
        if(!vagent)
        {
            llSay(PUBLIC_CHANNEL, "Login failed");
            _test_Shutdown();
            return;
        }
    }
    
    regionhandshake_received(agentinfo agent, key regionid, regionhandshakedata handshakedata)
    {
        llSay(PUBLIC_CHANNEL, "Sending CompleteAgentMovement");
        vagent.SendCompleteAgentMovement();
        msg_regionhandshake_received = TRUE;
        if(msg_regionhandshake_received && localid_received)
        {
            state test1;
        }
    }
    
    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                localid_received = TRUE;
            }
        }
        if(msg_regionhandshake_received && localid_received)
        {
            state test1;
        }
    }    
}

state test1
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 1: Setting particle system");
        asParticleSystem([PSYS_PART_FLAGS, PSYS_PART_WIND_MASK | PSYS_PART_EMISSIVE_MASK,
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE, 
                        PSYS_PART_START_COLOR, <1.0, 0.0, 0.0>]);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.ParticleSystem.PartDataFlags != (PSYS_PART_WIND_MASK | PSYS_PART_EMISSIVE_MASK) ||
                    objdata.ParticleSystem.SourcePattern != PSYS_SRC_PATTERN_EXPLODE ||
                    objdata.ParticleSystem.PartStartColor != <1,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 1: failed");
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test2;
            }
        }
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 1: No prim update received");
        result = FALSE;
        state test2;
    }
}

state test2
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 2: Setting particle system");
        asParticleSystem([PSYS_PART_FLAGS, PSYS_PART_WIND_MASK | PSYS_PART_EMISSIVE_MASK,
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE, 
                        PSYS_PART_START_COLOR, <1.0, 0.0, 0.0>]);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.ParticleSystem.PartDataFlags != (PSYS_PART_WIND_MASK | PSYS_PART_EMISSIVE_MASK) ||
                    objdata.ParticleSystem.SourcePattern != PSYS_SRC_PATTERN_ANGLE ||
                    objdata.ParticleSystem.PartStartColor != <1,0,0>)
                {
                    llSay(PUBLIC_CHANNEL, "Test 2: failed");
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state test3;
            }
        }
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 2: No prim update received");
        result = FALSE;
        state test3;
    }
}

state test3
{
    integer received = FALSE;
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Test 3: Clearing particle system");
        asParticleSystem([]);
        llSetTimerEvent(1.0);
    }

    objectupdate_received(agentinfo agent, float timedilation, objectdatalist objectlist)
    {
        foreach(objdata in objectlist)
        {
            if(objdata.LocalID == localid)
            {
                received = TRUE;
                if(objdata.ParticleSystem)
                {
                    llSay(PUBLIC_CHANNEL, "Test 3: failed");
                    result = FALSE;
                }
                llSetTimerEvent(0);
                state logout;
            }
        }
    }    
    
    timer()
    {
        llSay(PUBLIC_CHANNEL, "Test 3: No prim update received");
        result = FALSE;
        state logout;
    }
}

state logout
{
    state_entry()
    {
        llSay(PUBLIC_CHANNEL, "Requesting logout");
        llSetTimerEvent(1);
        vagent.Logout();
    }
    
    logoutreply_received(agentinfo agent)
    {
        llSay(PUBLIC_CHANNEL, "Logout confirmed");
        _test_Result(result);
        llSetTimerEvent(1);
    }
    
    timer()
    {
        llSetTimerEvent(0);
        _test_Shutdown();
    }
}