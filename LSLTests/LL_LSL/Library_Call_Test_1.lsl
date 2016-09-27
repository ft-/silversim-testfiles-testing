 
integer gTests = 0;
 
test(string name)
{
    ++gTests;
    //llSay(0, name);
}
 
tests()
{
    float floatResult;
    integer integerResult;
    string stringResult;
    key keyResult;
    vector vectorResult;
    rotation rotationResult;
    list listResult;
 
    test("llSin"); floatResult = llSin(0.5);
    test("llCos"); floatResult = llCos(0.5);
    test("llTan"); floatResult = llTan(0.5);
    test("llAtan2"); floatResult = llAtan2(0.5, 0.5);
    test("llSqrt"); floatResult = llSqrt(0.5);
    test("llPow"); floatResult = llPow(0.5, 0.5);
    test("llAbs"); integerResult = llAbs(42);
    test("llFabs"); floatResult = llFabs(0.5);
    test("llFrand"); floatResult = llFrand(0.5);
    test("llFloor"); integerResult = llFloor(0.5);
    test("llCeil"); integerResult = llCeil(0.5);
    test("llRound"); integerResult = llRound(0.5);
    test("llVecMag"); floatResult = llVecMag(<1.1,2.2,3.3>);
    test("llVecNorm"); vectorResult = llVecNorm(<1.1,2.2,3.3>);
    test("llVecDist"); floatResult = llVecDist(<1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llRot2Euler"); vectorResult = llRot2Euler(<1.1,2.2,3.3,4.4>);
    test("llEuler2Rot"); rotationResult = llEuler2Rot(<1.1,2.2,3.3>);
    test("llAxes2Rot"); rotationResult = llAxes2Rot(<1.1,2.2,3.3>, <1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llRot2Fwd"); vectorResult = llRot2Fwd(<1.1,2.2,3.3,4.4>);
    test("llRot2Left"); vectorResult = llRot2Left(<1.1,2.2,3.3,4.4>);
    test("llRot2Up"); vectorResult = llRot2Up(<1.1,2.2,3.3,4.4>);
    test("llRotBetween"); rotationResult = llRotBetween(<1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llWhisper"); llWhisper(42, "foo");
    test("llSay"); llSay(42, "foo");
    test("llShout"); llShout(42, "foo");
    test("llListen"); integerResult = llListen(42, "foo", NULL_KEY, "foo");
    test("llListenControl"); llListenControl(42, 42);
    test("llListenRemove"); llListenRemove(42);
    test("llSensor"); llSensor("foo", NULL_KEY, 42, 0.5, 0.5);
    test("llSensorRepeat"); llSensorRepeat("foo", NULL_KEY, 42, 0.5, 0.5, 0.5);
    test("llSensorRemove"); llSensorRemove();
    test("llDetectedName"); stringResult = llDetectedName(42);
    test("llDetectedKey"); keyResult = llDetectedKey(42);
    test("llDetectedOwner"); keyResult = llDetectedOwner(42);
    test("llDetectedType"); integerResult = llDetectedType(42);
    test("llDetectedPos"); vectorResult = llDetectedPos(42);
    test("llDetectedVel"); vectorResult = llDetectedVel(42);
    test("llDetectedGrab"); vectorResult = llDetectedGrab(42);
    test("llDetectedRot"); rotationResult = llDetectedRot(42);
    test("llDetectedGroup"); integerResult = llDetectedGroup(42);
    test("llDetectedLinkNumber"); integerResult = llDetectedLinkNumber(42);
    test("llDie"); //llDie();
    test("llGround"); floatResult = llGround(<1.1,2.2,3.3>);
    test("llCloud"); floatResult = llCloud(<1.1,2.2,3.3>);
    test("llWind"); vectorResult = llWind(<1.1,2.2,3.3>);
    test("llSetStatus"); llSetStatus(42, 42);
    test("llGetStatus"); integerResult = llGetStatus(42);
    test("llSetScale"); llSetScale(<1.1,2.2,3.3>);
    test("llGetScale"); vectorResult = llGetScale();
    test("llSetColor"); llSetColor(<1.1,2.2,3.3>, 42);
    test("llGetColor"); vectorResult = llGetColor(0);
    test("llSetAlpha"); llSetAlpha(0.5, 42);
    test("llGetAlpha"); floatResult = llGetAlpha(42);
    test("llSetTexture"); llSetTexture("foo", 42);
    test("llScaleTexture"); llScaleTexture(0.5, 0.5, 42);
    test("llOffsetTexture"); llOffsetTexture(0.5, 0.5, 42);
    test("llRotateTexture"); llRotateTexture(0.5, 42);
    test("llGetTexture"); stringResult = llGetTexture(42);
    test("llSetPos"); //llSetPos(<1.1,2.2,3.3>);
    test("llGetPos"); vectorResult = llGetPos();
    test("llGetLocalPos"); vectorResult = llGetLocalPos();
    test("llSetRot"); llSetRot(<1.1,2.2,3.3,4.4>);
    test("llGetRot"); rotationResult = llGetRot();
    test("llGetLocalRot"); rotationResult = llGetLocalRot();
    test("llSetForce"); llSetForce(<1.1,2.2,3.3>, 42);
    test("llGetForce"); vectorResult = llGetForce();
    test("llMoveToTarget"); llMoveToTarget(<1.1,2.2,3.3>, 0.5);
    test("llStopMoveToTarget"); llStopMoveToTarget();
    test("llTarget"); integerResult = llTarget(<1.1,2.2,3.3>, 0.5);
    test("llTargetRemove"); llTargetRemove(42);
    test("llRotTarget"); integerResult = llRotTarget(<1.1,2.2,3.3,4.4>, 0.5);
    test("llRotTargetRemove"); llRotTargetRemove(42);
    test("llApplyImpulse"); llApplyImpulse(<1.1,2.2,3.3>, 42);
    test("llApplyRotationalImpulse"); llApplyRotationalImpulse(<1.1,2.2,3.3>, 42);
    test("llSetTorque"); llSetTorque(<1.1,2.2,3.3>, 42);
    test("llGetTorque"); vectorResult = llGetTorque();
    test("llSetForceAndTorque"); llSetForceAndTorque(<1.1,2.2,3.3>, <1.1,2.2,3.3>, 42);
    test("llGetVel"); vectorResult = llGetVel();
    test("llGetAccel"); vectorResult = llGetAccel();
    test("llGetOmega"); vectorResult = llGetOmega();
    test("llGetTimeOfDay"); floatResult = llGetTimeOfDay();
    test("llGetWallclock"); floatResult = llGetWallclock();
    test("llGetTime"); floatResult = llGetTime();
    test("llResetTime"); //llResetTime();
    test("llGetAndResetTime"); //floatResult = llGetAndResetTime();
    test("llSound"); llSound("foo", 0.5, 42, 42);
    test("llPlaySound"); llPlaySound(NULL_KEY, 0.5);
    test("llLoopSound"); llLoopSound("foo", 0.5);
    test("llLoopSoundMaster"); llLoopSoundMaster("foo", 0.5);
    test("llLoopSoundSlave"); llLoopSoundSlave("foo", 0.5);
    test("llPlaySoundSlave"); llPlaySoundSlave("foo", 0.5);
    test("llTriggerSound"); llTriggerSound(NULL_KEY, 0.5);
    test("llStopSound"); llStopSound();
    test("llPreloadSound"); llPreloadSound("foo");
    test("llGetSubString"); stringResult = llGetSubString("foo", 42, 42);
    test("llDeleteSubString"); stringResult = llDeleteSubString("foo", 42, 42);
    test("llInsertString"); stringResult = llInsertString("foo", 42, "foo");
    test("llToUpper"); stringResult = llToUpper("foo");
    test("llToLower"); stringResult = llToLower("foo");
    test("llGiveMoney"); integerResult = llGiveMoney(NULL_KEY, 42);
    test("llMakeExplosion"); llMakeExplosion(42, 0.5, 0.5, 0.5, 0.5, "foo", <1.1,2.2,3.3>);
    test("llMakeFountain"); llMakeFountain(42, 0.5, 0.5, 0.5, 0.5, 1,"foo", <1.1,2.2,3.3>, 0);
    test("llMakeSmoke"); llMakeSmoke(42, 0.5, 0.5, 0.5, 0.5, "foo", <1.1,2.2,3.3>);
    test("llMakeFire"); llMakeFire(42, 0.5, 0.5, 0.5, 0.5, "foo", <1.1,2.2,3.3>);
    test("llRezObject"); llRezObject("foo", <1.1,2.2,3.3>, <1.1,2.2,3.3>, <1.1,2.2,3.3,4.4>, 42);
    test("llLookAt"); llLookAt(<1.1,2.2,3.3>, 0.5, 0.5);
    test("llStopLookAt"); llStopLookAt();
    test("llSetTimerEvent"); llSetTimerEvent(0.5);
    test("llSleep"); llSleep(0.5);
    test("llGetMass"); floatResult = llGetMass();
    test("llCollisionFilter"); llCollisionFilter("foo", NULL_KEY, 42);
    test("llTakeControls"); llTakeControls(42, 42, 42);
    test("llReleaseControls"); llReleaseControls();
    test("llAttachToAvatar"); llAttachToAvatar(42);
    test("llDetachFromAvatar"); llDetachFromAvatar();
    test("llGetOwner"); keyResult = llGetOwner();
    test("llInstantMessage"); llInstantMessage(NULL_KEY, "foo");
    test("llEmail"); llEmail("foo", "foo", "foo");
    test("llGetNextEmail"); llGetNextEmail("foo", "foo");
    test("llGetKey"); keyResult = llGetKey();
    test("llSetBuoyancy"); llSetBuoyancy(0.5);
    test("llSetHoverHeight"); llSetHoverHeight(0.5, 42, 0.5);
    test("llStopHover"); llStopHover();
    test("llMinEventDelay"); llMinEventDelay(0.5);
    test("llSoundPreload"); llSoundPreload(NULL_KEY);
    test("llRotLookAt"); llRotLookAt(<1.1,2.2,3.3,4.4>, 0.5, 0.5);
    test("llStringLength"); integerResult = llStringLength("foo");
    test("llStartAnimation"); llStartAnimation("foo");
    test("llStopAnimation"); llStopAnimation("foo");
    test("llPointAt"); llPointAt(<1.1,2.2,3.3>);
    test("llStopPointAt"); llStopPointAt();
    test("llTargetOmega"); llTargetOmega(<1.1,2.2,3.3>, 0.5, 0.5);
    test("llGetStartParameter"); integerResult = llGetStartParameter();
    //test("llGodLikeRezObject"); llGodLikeRezObject(NULL_KEY, <1.1,2.2,3.3>);
    test("llRequestPermissions"); llRequestPermissions(NULL_KEY, 42);
    test("llGetPermissionsKey"); keyResult = llGetPermissionsKey();
    test("llGetPermissions"); integerResult = llGetPermissions();
    test("llGetLinkNumber"); integerResult = llGetLinkNumber();
    test("llSetLinkColor"); llSetLinkColor(42, <1.1,2.2,3.3>, 42);
    test("llCreateLink"); llCreateLink(NULL_KEY, 42);
    test("llBreakLink"); llBreakLink(42);
    test("llLinks"); llBreakAllLinks();
    test("llGetLinkKey"); keyResult = llGetLinkKey(42);
    test("llGetLinkName"); stringResult = llGetLinkName(42);
    test("llGetInventoryNumber"); integerResult = llGetInventoryNumber(42);
    test("llGetInventoryName"); stringResult = llGetInventoryName(42, 42);
    test("llSetScriptState"); llSetScriptState("foo", 42);
    test("llGetEnergy"); floatResult = llGetEnergy();
    test("llGiveInventory"); llGiveInventory(NULL_KEY, "foo");
    test("llRemoveInventory"); llRemoveInventory("foo");
    test("llSetText"); llSetText("foo", <1.1,2.2,3.3>, 0.5);
    test("llWater"); floatResult = llWater(<1.1,2.2,3.3>);
    test("llPassTouches"); llPassTouches(42);
    test("llRequestAgentData"); keyResult = llRequestAgentData(NULL_KEY, 42);
    test("llRequestInventoryData"); keyResult = llRequestInventoryData("foo");
    test("llSetDamage"); llSetDamage(0.5);
    test("llTeleportAgentHome"); llTeleportAgentHome(NULL_KEY);
    test("llModifyLand"); llModifyLand(42, 42);
    test("llCollisionSound"); llCollisionSound("foo", 0.5);
    test("llCollisionSprite"); llCollisionSprite("foo");
    test("llGetAnimation"); stringResult = llGetAnimation(NULL_KEY);
    test("llGetAnimationList"); listResult = llGetAnimationList(NULL_KEY);
    //test("llResetScript"); llResetScript();
    test("llMessageLinked"); llMessageLinked(42, 42, "foo", NULL_KEY);
    test("llPushObject"); llPushObject(NULL_KEY, <1.1,2.2,3.3>, <1.1,2.2,3.3>, 42);
    test("llPassCollisions"); llPassCollisions(42);
    test("llGetScriptName"); stringResult = llGetScriptName();
    test("llGetNumberOfSides"); integerResult = llGetNumberOfSides();
    test("llAxisAngle2Rot"); rotationResult = llAxisAngle2Rot(<1.1,2.2,3.3>, 0.5);
    test("llRot2Axis"); vectorResult = llRot2Axis(<1.1,2.2,3.3,4.4>);
    test("llRot2Angle"); floatResult = llRot2Angle(<1.1,2.2,3.3,4.4>);
    test("llAcos"); floatResult = llAcos(0.5);
    test("llAsin"); floatResult = llAsin(0.5);
    test("llAngleBetween"); floatResult = llAngleBetween(<1.1,2.2,3.3,4.4>, <1.1,2.2,3.3,4.4>);
}
 
default
{
    touch_start(integer total_number)
    {
        llResetTime();
        tests();
        llSay(0, "Ran " + (string) gTests + " tests in " + (string) llGetTime() + " seconds");
        gTests = 0;
    }
}