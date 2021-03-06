// LSL script generated: FSZHAO.lslp Sun Jan 24 18:17:35 Mitteleuropäische Zeit 2016

integer typingStatus = FALSE;
integer numTyping;
integer numStands;
integer randomStands = FALSE;
integer curStandIndex;
string curStandAnim = "";
string curSitAnim = "";
string curWalkAnim = "";
string curGsitAnim = "";
string curTypingAnim = "";
list overrides = [];
key notecardLineKey = NULL_KEY;
integer notecardIndex = 0;
string lastAnim = "";
string lastAnimSet = "";
integer lastAnimIndex = 0;
string lastAnimState = "";
integer dialogStandTime = 30;
integer standTime = 30;
integer animOverrideOn = FALSE;
integer gotPermission = FALSE;
integer haveWalkingAnim = FALSE;
integer sitOverride = TRUE;
integer standOverride = TRUE;
integer typingOverrideOn = TRUE;
integer typingKill = FALSE;
integer sitAnywhereOn = FALSE;
integer listenState = 0;
integer loadInProgress = FALSE;
string notecardName = "";
key Owner = NULL_KEY;
string EMPTY = "";
string TRYAGAIN = "Please correct the notecard and try again.";
string S_SIT = "Sit override: ";
string S_SIT_AW = "Sit anywhere: ";
string S_TYPING = "Typing override: ";
string S_TKILL_ON = "Typing killer: On - This also removes custom typing animations!";
string S_TKILL_OFF = "Typing killer: Off";
integer counter;
integer chatMessageOn = TRUE;
startAnimationList(string _csvAnims){
    list anims = llCSV2List(_csvAnims);
    integer i;
    for ((i = 0); (i < llGetListLength(anims)); (i++)) {
        llStartAnimation(llList2String(anims,i));
    }
}
stopAnimationList(string _csvAnims){
    list anims = llCSV2List(_csvAnims);
    integer i;
    for ((i = 0); (i < llGetListLength(anims)); (i++)) {
        llStopAnimation(llList2String(anims,i));
    }
}
startNewAnimation(string _anim,integer _animIndex,string _state){
    if ((_anim != lastAnimSet)) {
        string newAnim;
        if ((lastAnim != EMPTY)) stopAnimationList(lastAnim);
        if ((_anim != EMPTY)) {
            list newAnimSet = llParseStringKeepNulls(_anim,["|"],[]);
            (newAnim = llList2String(newAnimSet,((integer)llFloor(llFrand(llGetListLength(newAnimSet))))));
            startAnimationList(newAnim);
            if ((llListFindList([5,6,19],[_animIndex]) != (-1))) {
                if ((lastAnim != EMPTY)) {
                    stopAnimationList(lastAnim);
                    (lastAnim = EMPTY);
                }
                llSleep((15 / 10.0));
                stopAnimationList(_anim);
            }
        }
        (lastAnim = newAnim);
        (lastAnimSet = _anim);
    }
    (lastAnimIndex = _animIndex);
    (lastAnimState = _state);
}
animOverride(){
    string curAnimState = llGetAnimation(Owner);
    integer curAnimIndex;
    integer underwaterAnimIndex;
    if ((curAnimState == "Striding")) {
        (curAnimState = "Walking");
    }
    else  if ((curAnimState == "Soft Landing")) {
        (curAnimState = "Landing");
    }
    if ((curAnimState == "CrouchWalking")) {
        if ((llVecMag(llGetVel()) < 0.5)) (curAnimState = "Crouching");
    }
    string _curAnimState = curAnimState;
    vector curPos = llGetPos();
    integer underwater = (llWater(ZERO_VECTOR) > curPos.z);
    if (underwater) {
        if ((curAnimState == "Flying")) (_curAnimState = "Swimming Forward");
        else  if ((curAnimState == "Hovering Up")) (_curAnimState = "Swimming Up");
        else  if ((curAnimState == "Hovering Down")) (_curAnimState = "Swimming Down");
        else  if ((curAnimState == "Hovering")) (_curAnimState = "Floating");
    }
    if (((_curAnimState == lastAnimState) && (_curAnimState != "Walking"))) {
        return;
    }
    (curAnimIndex = llListFindList(["Sitting on Ground","Sitting","Striding","Crouching","CrouchWalking","Soft Landing","Standing Up","Falling Down","Hovering Down","Hovering Up","FlyingSlow","Flying","Hovering","Jumping","PreJumping","Running","Turning Right","Turning Left","Walking","Landing","Standing"],[curAnimState]));
    (underwaterAnimIndex = llListFindList([12,11,10,9,8],[curAnimIndex]));
    if ((curAnimIndex == 20)) {
        if (sitAnywhereOn) {
            startNewAnimation(curGsitAnim,0,_curAnimState);
        }
        else  {
            if (standOverride) startNewAnimation(curStandAnim,20,_curAnimState);
            else  startNewAnimation(EMPTY,(-1),_curAnimState);
        }
    }
    else  if ((curAnimIndex == 1)) {
        if (((sitOverride == FALSE) && (curAnimState == "Sitting"))) startNewAnimation(EMPTY,(-1),_curAnimState);
        else  startNewAnimation(curSitAnim,1,_curAnimState);
    }
    else  if ((curAnimIndex == 18)) {
        startNewAnimation(curWalkAnim,18,_curAnimState);
    }
    else  if ((curAnimIndex == 0)) {
        startNewAnimation(curGsitAnim,0,_curAnimState);
    }
    else  {
        if ((underwaterAnimIndex != (-1))) {
            if (underwater) {
                (curAnimIndex = llList2Integer([24,23,23,22,21],underwaterAnimIndex));
            }
        }
        startNewAnimation(llList2String(overrides,curAnimIndex),curAnimIndex,_curAnimState);
    }
}
doNextStand(integer fromUI){
    if ((numStands > 0)) {
        if (((!sitAnywhereOn) && standOverride)) {
            if (randomStands) {
                (curStandIndex = llFloor(llFrand(numStands)));
            }
            else  {
                (curStandIndex = ((curStandIndex + 1) % numStands));
            }
            (curStandAnim = findMultiAnim(20,curStandIndex));
            if ((lastAnimState == "Standing")) startNewAnimation(curStandAnim,20,lastAnimState);
            if ((fromUI == TRUE)) {
                string newAnimName = curStandAnim;
                OwnerSay((("Switching to stand '" + newAnimName) + "'."));
            }
        }
    }
    else  {
        if ((fromUI == TRUE)) {
            OwnerSay("No stand animations configured.");
        }
    }
    llResetTime();
}
typingOverride(integer isTyping){
    if (isTyping) {
        if (typingKill) {
            llStopAnimation("type");
        }
        else  {
            integer curTypingIndex = 0;
            if ((numTyping > 1)) {
                (curTypingIndex = llFloor(llFrand(numTyping)));
            }
            (curTypingAnim = findMultiAnim(25,curTypingIndex));
            startAnimationList(curTypingAnim);
        }
    }
    else  if ((!typingKill)) {
        stopAnimationList(curTypingAnim);
    }
}
doMultiAnimMenu(integer _animIndex,string _animType,string _currentAnim){
    list anims = llParseString2List(llList2String(overrides,_animIndex),["|"],[]);
    integer numAnims = llGetListLength(anims);
    if ((numAnims > 30)) {
        OwnerSay((("Too many animations, only the first " + ((string)30)) + " will be displayed."));
        (numAnims = 30);
    }
    integer i;
    string animNames = EMPTY;
    for ((i = 0); (i < numAnims); (i++)) {
        (animNames += ((((llList2String(anims,i) + "|") + ((string)12123419)) + "|") + ((string)i)));
        if ((i != (numAnims - 1))) (animNames += "|||");
    }
    if ((animNames == EMPTY)) {
        llOwnerSay("No overrides have been configured.");
        return;
    }
    llMessageLinked(LINK_THIS,12123408,llDumpList2String(["ITEMS",_animType,numAnims,0,0,12123419],"|"),((key)animNames));
}
string findMultiAnim(integer _animIndex,integer _multiAnimIndex){
    list animsList = llParseString2List(llList2String(overrides,_animIndex),["|"],[]);
    return llList2String(animsList,_multiAnimIndex);
}
integer checkAndOverride(){
    if ((animOverrideOn && gotPermission)) {
        animOverride();
        return TRUE;
    }
    return FALSE;
}
loadNoteCard(){
    if ((llGetInventoryKey(notecardName) == NULL_KEY)) {
        OwnerSay((("Notecard '" + notecardName) + "' does not exist, or does not have full permissions."));
        (notecardName = EMPTY);
        (loadInProgress = FALSE);
        return;
    }
    else  {
        (loadInProgress = TRUE);
        (overrides = []);
        integer i;
        for ((i = 0); (i < 27); (i++)) (overrides += [EMPTY]);
        (curStandIndex = 0);
        (curStandAnim = EMPTY);
        (curSitAnim = EMPTY);
        (curWalkAnim = EMPTY);
        (curGsitAnim = EMPTY);
        OwnerSay((("Loading AO notecard '" + notecardName) + "'..."));
        (counter = 0);
        (notecardIndex = 0);
        (notecardLineKey = llGetNotecardLine(notecardName,notecardIndex));
    }
}
checkAnimInInventory(string _csvAnims){
    list anims = llCSV2List(_csvAnims);
    integer i;
    for ((i = 0); (i < llGetListLength(anims)); (i++)) {
        if ((llGetInventoryType(llList2String(anims,i)) != INVENTORY_ANIMATION)) OwnerSay((("Warning: Couldn't find animation '" + llList2String(anims,i)) + "' in inventory."));
    }
}
endNotecardLoad(integer success){
    if (success) {
        OwnerSay((((string)counter) + " animation entries found in AO notecard."));
        if ((llList2String(overrides,18) != EMPTY)) {
            (haveWalkingAnim = TRUE);
        }
        (curStandIndex = 0);
        (numStands = llGetListLength(llParseString2List(llList2String(overrides,20),["|"],[])));
        (numTyping = llGetListLength(llParseString2List(llList2String(overrides,25),["|"],[])));
        (curStandAnim = findMultiAnim(20,0));
        (curWalkAnim = findMultiAnim(18,0));
        (curSitAnim = findMultiAnim(1,0));
        (curGsitAnim = findMultiAnim(0,0));
        startNewAnimation(EMPTY,(-1),lastAnimState);
        (lastAnim = EMPTY);
        (lastAnimSet = EMPTY);
        (lastAnimIndex = (-1));
        (lastAnimState = EMPTY);
        OwnerSay((("Finished reading AO notecard '" + notecardName) + "'."));
        llMessageLinked(LINK_THIS,12123410,llDumpList2String([112,notecardName],"|"),"");
    }
    (loadInProgress = FALSE);
    (notecardName = EMPTY);
    llMinEventDelay(0.25);
}
initialize(){
    (Owner = llGetOwner());
    llSetTimerEvent(0.0);
    if (animOverrideOn) llSetTimerEvent(0.25);
    (lastAnim = EMPTY);
    (lastAnimSet = EMPTY);
    (lastAnimIndex = (-1));
    (lastAnimState = EMPTY);
    (gotPermission = FALSE);
}
OwnerSay(string data){
    if (chatMessageOn) llOwnerSay(data);
}
default {

    state_entry() {
        integer i;
        (Owner = llGetOwner());
        if (llGetAttached()) llRequestPermissions(llGetOwner(),(PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS));
        (overrides = []);
        for ((i = 0); (i < 27); (i++)) {
            (overrides += [EMPTY]);
        }
        (randomStands = FALSE);
        initialize();
        llResetTime();
        llSetRemoteScriptAccessPin(0);
    }

    on_rez(integer _code) {
        initialize();
    }

    attach(key _k) {
        if ((_k != NULL_KEY)) llRequestPermissions(llGetOwner(),(PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS));
    }

    run_time_permissions(integer _perm) {
        if ((_perm != (PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS))) (gotPermission = FALSE);
        else  {
            llTakeControls((CONTROL_BACK | CONTROL_FWD),TRUE,TRUE);
            (gotPermission = TRUE);
        }
    }

    link_message(integer _sender,integer _num,string _message,key _id) {
        if (((-1) == llListFindList([12123409,12123419,0],[_num]))) {
            return;
        }
        if (((_num == 0) && (_message == "RESET"))) {
            if (gotPermission) {
                if ((lastAnim != EMPTY)) stopAnimationList(lastAnim);
                if ((curTypingAnim != EMPTY)) stopAnimationList(curTypingAnim);
            }
            llResetScript();
            return;
        }
        if ((12123409 == _num)) {
            if ((_message == "ZHAO_AOON")) {
                llSetTimerEvent(0.25);
                (animOverrideOn = TRUE);
                checkAndOverride();
                return;
            }
            if ((_message == "ZHAO_AOOFF")) {
                llSetTimerEvent(0.0);
                (animOverrideOn = FALSE);
                startNewAnimation(EMPTY,(-1),lastAnimState);
                (lastAnim = EMPTY);
                (lastAnimSet = EMPTY);
                (lastAnimIndex = (-1));
                (lastAnimState = EMPTY);
                return;
            }
            if ((_message == "CHAT_ON")) {
                (chatMessageOn = TRUE);
                return;
            }
            if ((_message == "CHAT_OFF")) {
                (chatMessageOn = FALSE);
                return;
            }
            if ((_message == "ZHAO_STANDON")) {
                (standOverride = TRUE);
                OwnerSay("Stand AO On");
                if ((lastAnimState == "Standing")) startNewAnimation(curStandAnim,20,lastAnimState);
                return;
            }
            if ((_message == "ZHAO_STANDOFF")) {
                (standOverride = FALSE);
                OwnerSay("Stand AO Off");
                if ((lastAnimState == "Standing")) startNewAnimation(EMPTY,(-1),lastAnimState);
                return;
            }
            if ((_message == "ZHAO_SITON")) {
                (sitOverride = TRUE);
                OwnerSay((S_SIT + "On"));
                if ((lastAnimState == "Sitting")) startNewAnimation(curSitAnim,1,lastAnimState);
                return;
            }
            if ((_message == "ZHAO_SITOFF")) {
                (sitOverride = FALSE);
                OwnerSay((S_SIT + "Off"));
                if ((lastAnimState == "Sitting")) startNewAnimation(EMPTY,(-1),lastAnimState);
                return;
            }
            if ((_message == "ZHAO_SITANYWHERE_ON")) {
                (sitAnywhereOn = TRUE);
                OwnerSay((S_SIT_AW + "On"));
                if ((lastAnimState == "Standing")) startNewAnimation(curGsitAnim,0,lastAnimState);
                return;
            }
            if ((_message == "ZHAO_SITANYWHERE_OFF")) {
                (sitAnywhereOn = FALSE);
                OwnerSay((S_SIT_AW + "Off"));
                if ((lastAnimState == "Standing")) startNewAnimation(curStandAnim,20,lastAnimState);
                return;
            }
            if ((_message == "ZHAO_TYPEAO_ON")) {
                (typingOverrideOn = TRUE);
                OwnerSay((S_TYPING + "On"));
                (typingStatus = FALSE);
                return;
            }
            if ((_message == "ZHAO_TYPEAO_OFF")) {
                (typingOverrideOn = FALSE);
                OwnerSay((S_TYPING + "Off"));
                if ((typingStatus && (!typingKill))) {
                    stopAnimationList(curTypingAnim);
                    (typingStatus = FALSE);
                }
                return;
            }
            if ((_message == "ZHAO_TYPEKILL_ON")) {
                (typingKill = TRUE);
                OwnerSay(S_TKILL_ON);
                (typingStatus = FALSE);
                return;
            }
            if ((_message == "ZHAO_TYPEKILL_OFF")) {
                (typingKill = FALSE);
                OwnerSay(S_TKILL_OFF);
                (typingStatus = FALSE);
                return;
            }
            if ((_message == "ZHAO_RANDOMSTANDS")) {
                (randomStands = TRUE);
                OwnerSay("Stand cycling: Random");
                return;
            }
            if ((_message == "ZHAO_SEQUENTIALSTANDS")) {
                (randomStands = FALSE);
                OwnerSay("Stand cycling: Sequential");
                return;
            }
            if ((_message == "ZHAO_SETTINGS")) {
                if (sitOverride) {
                    OwnerSay((S_SIT + "On"));
                }
                else  {
                    OwnerSay((S_SIT + "Off"));
                }
                if (sitAnywhereOn) {
                    OwnerSay((S_SIT_AW + "On"));
                }
                else  {
                    OwnerSay((S_SIT_AW + "Off"));
                }
                if (typingOverrideOn) {
                    OwnerSay((S_TYPING + "On"));
                }
                else  {
                    OwnerSay((S_TYPING + "Off"));
                }
                if (typingKill) {
                    OwnerSay(S_TKILL_ON);
                }
                else  {
                    OwnerSay(S_TKILL_OFF);
                }
                if (randomStands) {
                    OwnerSay("Stand cycling: Random");
                }
                else  {
                    OwnerSay("Stand cycling: Sequential");
                }
                OwnerSay((("Stand cycle time: " + ((string)dialogStandTime)) + " seconds"));
                return;
            }
            if ((_message == "ZHAO_NEXTSTAND")) {
                doNextStand(TRUE);
                return;
            }
            if ((llGetSubString(_message,0,14) == "ZHAO_STANDTIME|")) {
                (dialogStandTime = ((integer)llGetSubString(_message,15,(-1))));
                OwnerSay((("Stand cycle time: " + ((string)dialogStandTime)) + " seconds"));
                return;
            }
            if ((llGetSubString(_message,0,9) == "ZHAO_LOAD|")) {
                if ((loadInProgress == TRUE)) {
                    OwnerSay((("Cannot load new notecard, still reading notecard '" + notecardName) + "'"));
                    return;
                }
                (notecardName = llGetSubString(_message,10,(-1)));
                loadNoteCard();
                return;
            }
            if ((_message == "ZHAO_SITS")) {
                doMultiAnimMenu(1,"Sitting",curSitAnim);
                (listenState = 1);
                return;
            }
            if ((_message == "ZHAO_WALKS")) {
                doMultiAnimMenu(18,"Walking",curWalkAnim);
                (listenState = 2);
                return;
            }
            if ((_message == "ZHAO_GROUNDSITS")) {
                doMultiAnimMenu(0,"Sitting On Ground",curGsitAnim);
                (listenState = 3);
                return;
            }
        }
        if ((12123419 == _num)) {
            list p = llParseString2List(_message,["|"],[]);
            if ((listenState == 1)) {
                (curSitAnim = findMultiAnim(1,llList2Integer(p,1)));
                if ((lastAnimState == "Sitting")) {
                    startNewAnimation(curSitAnim,1,lastAnimState);
                }
                OwnerSay(("New sitting animation: " + curSitAnim));
            }
            else  if ((listenState == 2)) {
                (curWalkAnim = findMultiAnim(18,llList2Integer(p,1)));
                if ((lastAnimState == "Walking")) {
                    startNewAnimation(curWalkAnim,18,lastAnimState);
                }
                OwnerSay(("New walking animation: " + curWalkAnim));
            }
            else  if ((listenState == 3)) {
                (curGsitAnim = findMultiAnim(0,llList2Integer(p,1)));
                if (((lastAnimState == "Sitting on Ground") || ((lastAnimState == "Standing") && sitAnywhereOn))) {
                    startNewAnimation(curGsitAnim,0,lastAnimState);
                }
                OwnerSay(("New sitting on ground animation: " + curGsitAnim));
            }
            llMessageLinked(LINK_THIS,12123408,((string)2),((key)((string)12123410)));
        }
    }

    changed(integer _change) {
        if ((_change & CHANGED_TELEPORT)) {
            (lastAnimSet = EMPTY);
            (lastAnimState = EMPTY);
            checkAndOverride();
        }
    }

    collision_start(integer _num) {
        checkAndOverride();
    }

    collision(integer _num) {
    }

    collision_end(integer _num) {
        checkAndOverride();
    }

    control(key _id,integer _level,integer _edge) {
        if (_edge) {
            if ((animOverrideOn && (llGetAnimation(Owner) == "Walking"))) {
                if (((_level & _edge) & (CONTROL_BACK | CONTROL_FWD))) {
                    if (haveWalkingAnim) {
                        llStopAnimation("walk");
                        llStopAnimation("female_walk");
                    }
                }
            }
            checkAndOverride();
        }
    }

    timer() {
        if ((((numTyping > 0) && typingOverrideOn) || typingKill)) {
            integer typingTemp = (llGetAgentInfo(Owner) & AGENT_TYPING);
            if ((typingTemp != typingStatus)) {
                typingOverride(typingTemp);
                (typingStatus = typingTemp);
            }
        }
        if (checkAndOverride()) {
            if (((standTime != 0) && (llGetTime() > standTime))) {
                if ((!typingStatus)) doNextStand(FALSE);
            }
        }
    }

    dataserver(key _query_id,string _data) {
        if ((_query_id != notecardLineKey)) {
            return;
        }
        if ((_data == EOF)) {
            endNotecardLoad(TRUE);
            return;
        }
        if (((_data == EMPTY) || (llGetSubString(_data,0,0) == "#"))) {
            (notecardLineKey = llGetNotecardLine(notecardName,(++notecardIndex)));
            return;
        }
        integer i;
        integer found = FALSE;
        for ((i = 0); ((i < 27) && (!found)); (i++)) {
            string token = llList2String(["[ Sitting On Ground ]","[ Sitting ]","","[ Crouching ]","[ Crouch Walking ]","","[ Standing Up ]","[ Falling ]","[ Flying Down ]","[ Flying Up ]","[ Flying Slow ]","[ Flying ]","[ Hovering ]","[ Jumping ]","[ Pre Jumping ]","[ Running ]","[ Turning Right ]","[ Turning Left ]","[ Walking ]","[ Landing ]","[ Standing ]","[ Swimming Down ]","[ Swimming Up ]","[ Swimming Forward ]","[ Floating ]","[ Typing ]"],i);
            if (((token != EMPTY) && (llGetSubString(_data,0,(llStringLength(token) - 1)) == token))) {
                (found = TRUE);
                if ((_data != token)) {
                    string animPart = llGetSubString(_data,llStringLength(token),(-1));
                    list anims2Add = llParseString2List(animPart,["|"],[]);
                    integer j;
                    for ((j = 0); (j < llGetListLength(anims2Add)); (j++)) {
                        string newAnimName = llList2String(anims2Add,j);
                        checkAnimInInventory(newAnimName);
                        (++counter);
                    }
                    string s = llList2String(overrides,i);
                    if ((s != EMPTY)) {
                        list currentAnimsList = llParseString2List(s,["|"],[]);
                        (currentAnimsList = (((currentAnimsList = []) + currentAnimsList) + anims2Add));
                        (overrides = llListReplaceList(overrides,[llDumpList2String(currentAnimsList,"|")],i,i));
                    }
                    else  (overrides = llListReplaceList(overrides,[animPart],i,i));
                }
            }
        }
        if ((!found)) {
            OwnerSay(((((("Could not recognize token on line " + ((string)notecardIndex)) + ": ") + _data) + ". ") + TRYAGAIN));
            endNotecardLoad(FALSE);
            return;
        }
        (notecardLineKey = llGetNotecardLine(notecardName,(++notecardIndex)));
        return;
    }
}
