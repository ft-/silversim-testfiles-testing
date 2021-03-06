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
 
    test("llGetInventoryKey"); keyResult = llGetInventoryKey("foo");
    test("llAllowInventoryDrop"); llAllowInventoryDrop(42);
    test("llGetSunDirection"); vectorResult = llGetSunDirection();
    test("llGetTextureOffset"); vectorResult = llGetTextureOffset(42);
    test("llGetTextureScale"); vectorResult = llGetTextureScale(42);
    test("llGetTextureRot"); floatResult = llGetTextureRot(42);
    test("llSubStringIndex"); integerResult = llSubStringIndex("foo", "foo");
    test("llGetOwnerKey"); keyResult = llGetOwnerKey(NULL_KEY);
    test("llGetCenterOfMass"); vectorResult = llGetCenterOfMass();
    test("llGetListLength"); integerResult = llGetListLength([3]);
    test("llList2Integer"); integerResult = llList2Integer([3], 42);
    test("llList2Float"); floatResult = llList2Float([3], 42);
    test("llList2String"); stringResult = llList2String([3], 42);
    test("llList2Key"); keyResult = llList2Key([3], 42);
    test("llList2Vector"); vectorResult = llList2Vector([3], 42);
    test("llList2Rot"); rotationResult = llList2Rot([3], 42);
    test("llCSV2List"); listResult = llCSV2List("foo");
    test("llGetRegionCorner"); vectorResult = llGetRegionCorner();
    test("llGetObjectName"); stringResult = llGetObjectName();
    test("llSetObjectName"); llSetObjectName("foo");
    test("llGetDate"); stringResult = llGetDate();
    test("llEdgeOfWorld"); integerResult = llEdgeOfWorld(<1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llGetAgentInfo"); integerResult = llGetAgentInfo(NULL_KEY);
    test("llAdjustSoundVolume"); llAdjustSoundVolume(0.5);
    test("llSetSoundQueueing"); llSetSoundQueueing(42);
    test("llSetSoundRadius"); llSetSoundRadius(0.5);
    test("llKey2Name"); stringResult = llKey2Name(NULL_KEY);
    test("llSetTextureAnim"); llSetTextureAnim(42, 42, 42, 42, 0.5, 0.5, 0.5);
    test("llTriggerSoundLimited"); llTriggerSoundLimited("foo", 0.5, <1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llEjectFromLand"); llEjectFromLand(NULL_KEY);
    test("llOverMyLand"); integerResult = llOverMyLand(NULL_KEY);
    test("llGetLandOwnerAt"); keyResult = llGetLandOwnerAt(<1.1,2.2,3.3>);
    test("llGetNotecardLine"); keyResult = llGetNotecardLine("foo", 42);
    test("llGetAgentSize"); vectorResult = llGetAgentSize(NULL_KEY);
    test("llSameGroup"); integerResult = llSameGroup(NULL_KEY);
    test("llUnSit"); llUnSit(NULL_KEY);
    test("llGroundSlope"); vectorResult = llGroundSlope(<1.1,2.2,3.3>);
    test("llGroundNormal"); vectorResult = llGroundNormal(<1.1,2.2,3.3>);
    test("llGroundContour"); vectorResult = llGroundContour(<1.1,2.2,3.3>);
    test("llGetAttached"); integerResult = llGetAttached();
    test("llGetFreeMemory"); integerResult = llGetFreeMemory();
    test("llGetRegionName"); stringResult = llGetRegionName();
    test("llGetRegionTimeDilation"); floatResult = llGetRegionTimeDilation();
    test("llGetRegionFPS"); floatResult = llGetRegionFPS();
    test("llGroundRepel"); llGroundRepel(0.5, 42, 0.5);
    test("llScriptDanger"); integerResult = llScriptDanger(<1.1,2.2,3.3>);
    test("llSetVehicleType"); llSetVehicleType(42);
    test("llSetVehicleFloatParam"); llSetVehicleFloatParam(42, 0.5);
    test("llSetVehicleVectorParam"); llSetVehicleVectorParam(42, <1.1,2.2,3.3>);
    test("llSetVehicleRotationParam"); llSetVehicleRotationParam(42, <1.1,2.2,3.3,4.4>);
    test("llSetVehicleFlags"); llSetVehicleFlags(42);
    test("llRemoveVehicleFlags"); llRemoveVehicleFlags(42);
    test("llSitTarget"); llSitTarget(<1.1,2.2,3.3>, <1.1,2.2,3.3,4.4>);
    test("llAvatarOnSitTarget"); keyResult = llAvatarOnSitTarget();
    test("llAddToLandPassList"); llAddToLandPassList(NULL_KEY, 0.5);
    test("llSetTouchText"); llSetTouchText("foo");
    test("llSetSitText"); llSetSitText("foo");
    test("llSetCameraEyeOffset"); llSetCameraEyeOffset(<1.1,2.2,3.3>);
    test("llSetCameraAtOffset"); llSetCameraAtOffset(<1.1,2.2,3.3>);
    test("llVolumeDetect"); llVolumeDetect(42);
    test("llResetOtherScript"); llResetOtherScript("foo");
    test("llGetScriptState"); integerResult = llGetScriptState("foo");
    test("llRemoteLoadScript"); llRemoteLoadScript(NULL_KEY, "foo", 42, 42);
    test("llOpenRemoteDataChannel"); llOpenRemoteDataChannel();
    test("llSendRemoteData"); keyResult = llSendRemoteData(NULL_KEY, "foo", 42, "foo");
    test("llRemoteDataReply"); llRemoteDataReply(NULL_KEY, NULL_KEY, "foo", 42);
    test("llCloseRemoteDataChannel"); llCloseRemoteDataChannel(NULL_KEY);
    test("llMD5String"); stringResult = llMD5String("foo", 42);
    test("llStringToBase64"); stringResult = llStringToBase64("foo");
    test("llBase64ToString"); stringResult = llBase64ToString("foo");
    test("llXorBase64Strings"); stringResult = llXorBase64Strings("foo", "foo");
    test("llSetRemoteScriptAccessPin"); llSetRemoteScriptAccessPin(42);
    test("llRemoteLoadScriptPin"); llRemoteLoadScriptPin(NULL_KEY, "foo", 42, 42, 42);
    test("llRemoteDataSetRegion"); llRemoteDataSetRegion();
    test("llLog10"); floatResult = llLog10(0.5);
    test("llLog"); floatResult = llLog(0.5);
    test("llSetParcelMusicURL"); llSetParcelMusicURL("foo");
    test("llGetRootPosition"); vectorResult = llGetRootPosition();
    test("llGetRootRotation"); rotationResult = llGetRootRotation();
    test("llGetObjectDesc"); stringResult = llGetObjectDesc();
    test("llSetObjectDesc"); llSetObjectDesc("foo");
    test("llGetCreator"); keyResult = llGetCreator();
    test("llGetTimestamp"); stringResult = llGetTimestamp();
    test("llSetLinkAlpha"); llSetLinkAlpha(42, 0.5, 42);
    test("llGetNumberOfPrims"); integerResult = llGetNumberOfPrims();
    test("llGetNumberOfNotecardLines"); keyResult = llGetNumberOfNotecardLines("foo");
    test("llGetBoundingBox"); listResult = llGetBoundingBox(NULL_KEY);
    test("llGetGeometricCenter"); vectorResult = llGetGeometricCenter();
    test("llIntegerToBase64"); stringResult = llIntegerToBase64(42);
    test("llBase64ToInteger"); integerResult = llBase64ToInteger("foo");
    test("llGetGMTclock"); floatResult = llGetGMTclock();
    test("llGetSimulatorHostname"); stringResult = llGetSimulatorHostname();
    test("llSetLocalRot"); llSetLocalRot(<1.1,2.2,3.3,4.4>);
    test("llRezAtRoot"); llRezAtRoot("foo", <1.1,2.2,3.3>, <1.1,2.2,3.3>, <1.1,2.2,3.3,4.4>, 42);
    test("llGetObjectPermMask"); integerResult = llGetObjectPermMask(42);
    //test("llSetObjectPermMask"); llSetObjectPermMask(42,42);
    test("llGetInventoryPermMask"); integerResult = llGetInventoryPermMask("foo", 42);
    //test("llSetInventoryPermMask"); llSetInventoryPermMask("foo", 42, 42);
    test("llOwnerSay"); llOwnerSay("foo");
    test("llGetInventoryCreator"); keyResult = llGetInventoryCreator("foo");
    test("llRequestSimulatorData"); keyResult = llRequestSimulatorData("foo", 42);
    test("llForceMouselook"); llForceMouselook(42);
    test("llGetObjectMass"); floatResult = llGetObjectMass(NULL_KEY);
    test("llLoadURL"); llLoadURL(NULL_KEY, "foo", "foo");
    test("llModPow"); integerResult = llModPow(42, 42, 42);
    test("llGetInventoryType"); integerResult = llGetInventoryType("foo");
    test("llGetCameraPos"); vectorResult = llGetCameraPos();
    test("llGetCameraRot"); rotationResult = llGetCameraRot();
    test("llSetPrimURL"); llSetPrimURL("foo");
    test("llRefreshPrimURL"); llRefreshPrimURL();
    test("llEscapeURL"); stringResult = llEscapeURL("foo");
    test("llUnescapeURL"); stringResult = llUnescapeURL("foo");
    test("llMapDestination"); llMapDestination("foo", <1.1,2.2,3.3>, <1.1,2.2,3.3>);
    test("llAddToLandBanList"); llAddToLandBanList(NULL_KEY, 0.5);
    test("llRemoveFromLandPassList"); llRemoveFromLandPassList(NULL_KEY);
    test("llRemoveFromLandBanList"); llRemoveFromLandBanList(NULL_KEY);
    test("llResetLandBanList"); llResetLandBanList();
    test("llResetLandPassList"); llResetLandPassList();
    test("llClearCameraParams"); llClearCameraParams();
    test("llGetUnixTime"); integerResult = llGetUnixTime();
    test("llGetParcelFlags"); integerResult = llGetParcelFlags(<1.1,2.2,3.3>);
    test("llGetRegionFlags"); integerResult = llGetRegionFlags();
    test("llGetObjectPrimCount"); integerResult = llGetObjectPrimCount(NULL_KEY);
    test("llGetParcelPrimOwners"); listResult = llGetParcelPrimOwners(<1.1,2.2,3.3>); 
    test("llGetParcelPrimCount"); integerResult = llGetParcelPrimCount(<1.1,2.2,3.3>, 42, 42);
    test("llGetParcelMaxPrims"); integerResult = llGetParcelMaxPrims(<1.1,2.2,3.3>, 42);
    test("llSetLinkTexture"); llSetLinkTexture(42, "foo", 42);
    test("llStringTrim"); stringResult = llStringTrim("foo", 42);
    test("llRegionSay"); llRegionSay(42, "foo");
    test("llListSort"); listResult = llListSort([3], 42, 42);
    test("llList2List"); listResult = llList2List([3], 42, 42);
    test("llDeleteSubList"); listResult = llDeleteSubList([3], 42, 42);
    test("llGetListEntryType"); integerResult = llGetListEntryType([3], 42);
    test("llList2CSV"); stringResult = llList2CSV([3]);
    test("llListRandomize"); listResult = llListRandomize([3], 42);
    test("llList2ListStrided"); listResult = llList2ListStrided([3], 42, 42, 42);
    test("llListInsertList"); listResult = llListInsertList([3], [3], 42);
    test("llListFindList"); integerResult = llListFindList([3], [3]);
    test("llParseString2List"); listResult = llParseString2List("foo", [3], [3]);
    test("llParticleSystem"); llParticleSystem([3]);
    test("llGiveInventoryList"); llGiveInventoryList(NULL_KEY, "foo", [3]);
    test("llDumpList2String"); stringResult = llDumpList2String([3], "foo");
    test("llDialog"); llDialog(NULL_KEY, "foo", [3], 42);
    test("llSetPrimitiveParams"); llSetPrimitiveParams([3]);
    test("llGetPrimitiveParams"); listResult = llGetPrimitiveParams([3]);
    test("llParseStringKeepNulls"); listResult = llParseStringKeepNulls("foo", [3], [3]);
    test("llListReplaceList"); listResult = llListReplaceList([3], [3], 42, 42);
    test("llParcelMediaCommandList"); llParcelMediaCommandList([3]);
    test("llParcelMediaQuery"); listResult = llParcelMediaQuery([3]);
    test("llSetPayPrice"); llSetPayPrice(42, [3]);
    test("llSetCameraParams"); llSetCameraParams([3]);
    test("llListStatistics"); floatResult = llListStatistics(42, [3]);
    test("llGetParcelDetails"); listResult = llGetParcelDetails(<1.1,2.2,3.3>, [3]);
    test("llSetLinkPrimitiveParams"); llSetLinkPrimitiveParams(42, [3]);
    test("llGetObjectDetails"); listResult = llGetObjectDetails(NULL_KEY, [3]);
    test("llGetRegionAgentCount"); integerResult = llGetRegionAgentCount();
    test("llTextBox"); llTextBox(NULL_KEY, "hello text box", 0);
    test("llGetAgentLanguage"); stringResult = llGetAgentLanguage(NULL_KEY);
    test("llDetectedTouchUV"); vectorResult = llDetectedTouchUV(0);
    test("llDetectedTouchST"); vectorResult = llDetectedTouchST(0);
    test("llDetectedTouchFace"); integerResult = llDetectedTouchFace(0);
    test("llDetectedTouchPos"); vectorResult = llDetectedTouchPos(0);
    test("llDetectedTouchNormal"); vectorResult = llDetectedTouchNormal(0);
    test("llDetectedTouchBinormal"); vectorResult = llDetectedTouchBinormal(0);
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