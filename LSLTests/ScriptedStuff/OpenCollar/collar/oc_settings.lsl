//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//              ____                   ______      ____                     //
//             / __ \____  ___  ____  / ____/___  / / /___ ______           //
//            / / / / __ \/ _ \/ __ \/ /   / __ \/ / / __ `/ ___/           //
//           / /_/ / /_/ /  __/ / / / /___/ /_/ / / / /_/ / /               //
//           \____/ .___/\___/_/ /_/\____/\____/_/_/\__,_/_/                //
//               /_/                                                        //
//                                                                          //
//                        ,^~~~-.         .-~~~"-.                          //
//                       :  .--. \       /  .--.  \                         //
//                       : (    .-`<^~~~-: :    )  :                        //
//                       `. `-,~            ^- '  .'                        //
//                         `-:                ,.-~                          //
//                          .'                  `.                          //
//                         ,'   @   @            |                          //
//                         :    __               ;                          //
//                      ...{   (__)          ,----.                         //
//                     /   `.              ,' ,--. `.                       //
//                    |      `.,___   ,      :    : :                       //
//                    |     .'    ~~~~       \    / :                       //
//                     \.. /               `. `--' .'                       //
//                        |                  ~----~                         //
//                          Settings - 151115.1                             //
// ------------------------------------------------------------------------ //
//  Copyright (c) 2008 - 2015 Nandana Singh, Cleo Collins, Master Starship, //
//  Satomi Ahn, Garvin Twine, Joy Stipe, Alex Carpenter, Xenhat Liamano,    //
//  Wendy Starfall, Medea Destiny, Rebbie, Romka Swallowtail,               //
//  littlemousy et al.                                                      //
// ------------------------------------------------------------------------ //
//  This script is free software: you can redistribute it and/or modify     //
//  it under the terms of the GNU General Public License as published       //
//  by the Free Software Foundation, version 2.                             //
//                                                                          //
//  This script is distributed in the hope that it will be useful,          //
//  but WITHOUT ANY WARRANTY; without even the implied warranty of          //
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the            //
//  GNU General Public License for more details.                            //
//                                                                          //
//  You should have received a copy of the GNU General Public License       //
//  along with this script; if not, see www.gnu.org/licenses/gpl-2.0        //
// ------------------------------------------------------------------------ //
//  This script and any derivatives based on it must remain "full perms".   //
//                                                                          //
//  "Full perms" means maintaining MODIFY, COPY, and TRANSFER permissions   //
//  in Second Life(R), OpenSimulator and the Metaverse.                     //
//                                                                          //
//  If these platforms should allow more fine-grained permissions in the    //
//  future, then "full perms" will mean the most permissive possible set    //
//  of permissions allowed by the platform.                                 //
// ------------------------------------------------------------------------ //
//         github.com/OpenCollar/opencollar/tree/master/src/collar          //
// ------------------------------------------------------------------------ //
//////////////////////////////////////////////////////////////////////////////

// Central storage for settings of other plugins in the device.

string g_sCard = ".settings";
string g_sSplitLine; // to parse lines that were split due to lsl constraints
integer g_iLineNr = 0;
key g_kLineID;
key g_kCardID = NULL_KEY; //needed for change event check if no .settings card is in the inventory
key g_kWearer;

//string g_sSettingToken = "settings_";
//string g_sGlobalToken = "global_";

//MESSAGE MAP
//integer CMD_ZERO = 0;
integer CMD_OWNER = 500;
//integer CMD_TRUSTED = 501;
//integer CMD_GROUP = 502;
integer CMD_WEARER = 503;
//integer CMD_EVERYONE = 504;
//integer CMD_RLV_RELAY = 507;
//integer CMD_SAFEWORD = 510;
//integer CMD_RELAY_SAFEWORD = 511;
//integer CMD_BLOCKED = 520;

//integer POPUP_HELP = 1001;
integer NOTIFY=1002;
//integer SAY = 1004;
integer LM_SETTING_SAVE = 2000;
integer LM_SETTING_REQUEST = 2001;
integer LM_SETTING_RESPONSE = 2002;
integer LM_SETTING_DELETE = 2003;
integer LM_SETTING_EMPTY = 2004;

integer DIALOG = -9000;
integer DIALOG_RESPONSE = -9001;
integer LINK_DIALOG = 3;
integer INTEGRITY = -1050;
integer REBOOT = -1000;
integer LOADPIN = -1904;
integer g_iRebootConfirmed;
key g_kConfirmDialogID;

//string WIKI_URL = "http://www.opencollar.at/user-guide.html";
list g_lSettings;

integer g_iSayLimit = 1024; // lsl "say" string limit
integer g_iCardLimit = 255; // lsl card-line string limit
string g_sDelimiter = "\\";

// Get Group or Token, 0=Group, 1=Token
string SplitToken(string sIn, integer iSlot) {
    integer i = llSubStringIndex(sIn, "_");
    if (!iSlot) return llGetSubString(sIn, 0, i - 1);
    return llGetSubString(sIn, i + 1, -1);
}
// To add new entries at the end of Groupings
integer GroupIndex(list lCache, string sToken) {
    string sGroup = SplitToken(sToken, 0);
    integer i = llGetListLength(lCache) - 1;
    // start from the end to find last instance, +2 to get behind the value
    for (; ~i ; i -= 2) {
        if (SplitToken(llList2String(lCache, i - 1), 0) == sGroup) return i + 1;
    }
    return -1;
}
integer SettingExists(string sToken) {
    if (~llListFindList(g_lSettings, [sToken])) return TRUE;
    return FALSE;
}

list SetSetting(list lCache, string sToken, string sValue) {
    integer idx = llListFindList(lCache, [sToken]);
    if (~idx) return llListReplaceList(lCache, [sValue], idx + 1, idx + 1);
    idx = GroupIndex(lCache, sToken);
    if (~idx) return llListInsertList(lCache, [sToken, sValue], idx);
    return lCache + [sToken, sValue];
}

// like SetSetting, but only sets the value if there's not one already there.
list AddSetting(list lCache, string sToken, string sValue) {
    integer i = llListFindList(lCache, [sToken]);
    if (~i) return lCache;
    i = GroupIndex(lCache, sToken);
    if (~i) return llListInsertList(lCache, [sToken, sValue], i);
    return lCache + [sToken, sValue];
}

string GetSetting(string sToken) {
    integer i = llListFindList(g_lSettings, [sToken]);
    return llList2String(g_lSettings, i + 1);
}
// per = number of entries to put in each bracket
list ListCombineEntries(list lIn, string sAdd, integer iPer) {
    list lOut;
    while (llGetListLength(lIn)) {
        list lItem;
        integer i;
        for (; i < iPer; i++) lItem += llList2List(lIn, i, i);
        lOut += [llDumpList2String(lItem, sAdd)];
        lIn = llDeleteSubList(lIn, 0, iPer - 1);
    }
    return lOut;
}

DelSetting(string sToken) { // we'll only ever delete user settings
    integer i = llGetListLength(g_lSettings) - 1;
    if (SplitToken(sToken, 1) == "all") {
        sToken = SplitToken(sToken, 0);
      //  string sVar;
        for (; ~i; i -= 2) {
            if (SplitToken(llList2String(g_lSettings, i - 1), 0) == sToken)
                g_lSettings = llDeleteSubList(g_lSettings, i - 1, i);
        }
        return;
    }
    i = llListFindList(g_lSettings, [sToken]);
    if (~i) g_lSettings = llDeleteSubList(g_lSettings, i, i + 1);
}

// run delimiters & add escape-characters for settings print
list Add2OutList(list lIn) {
    if (!llGetListLength(lIn)) return [];
    list lOut;// = ["#---My Settings---#"];
    string sBuffer;
    string sTemp;
    string sID;
    string sPre;
    string sGroup;
    string sToken;
    string sValue;
    integer i;

    for (i=0 ; i < llGetListLength(lIn); i += 2) {
        sToken = llList2String(lIn, i);
        sValue = llList2String(lIn, i + 1);
        //sGroup = SplitToken(sToken, 0);
        sGroup = llToUpper(SplitToken(sToken, 0));
        sToken = SplitToken(sToken, 1);
        integer bIsSplit = FALSE ;
        integer iAddedLength = llStringLength(sBuffer) + llStringLength(sValue)
            + llStringLength(sID) +2; //+llStringLength(set);
        if (sGroup != sID || llStringLength(sBuffer) == 0 || iAddedLength >= g_iCardLimit ) { // new group
            // Starting a new group.. flush the buffer to the output.
            if ( llStringLength(sBuffer) ) lOut += [sBuffer] ;
            sID = sGroup;
           // pre = "\n" + set + sid + "=";
            sPre = "\n" + sID + "=";
        }
        else sPre = sBuffer + "~";
        sTemp = sPre + sToken + "~" + sValue;
        while (llStringLength(sTemp)) {
            sBuffer = sTemp;
            if (llStringLength(sTemp) > g_iCardLimit) {
                bIsSplit = TRUE ;
                sBuffer = llGetSubString(sTemp, 0, g_iCardLimit - 2) + g_sDelimiter;
                sTemp = "\n" + llDeleteSubString(sTemp, 0, g_iCardLimit - 2);
            } else sTemp = "";
            if ( bIsSplit ) {
                // if this is either a split buffer or one of it's continuation
                // line outputs,
                lOut += [sBuffer];
                sBuffer = "" ;
            }
        }
    }
    // If there's anything left in the buffer, flush it to output.
    if ( llStringLength(sBuffer) ) lOut += [sBuffer] ;
    return lOut;
}

PrintSettings(key kID) {
    // compile everything into one list, so we can tell the user everything seamlessly
    list lOut;
    list lSay = ["\n\nEverything below this line can be copied & pasted into a notecard called \".settings\" for backup:\n"];
    lSay += Add2OutList(g_lSettings);
    string sOld;
    string sNew;
    integer i;
    while (llGetListLength(lSay)) {
        sNew = llList2String(lSay, 0);
        i = llStringLength(sOld + sNew) + 2;
        if (i > g_iSayLimit) {
            lOut += [sOld];
            sOld = "";
        }
        sOld += sNew;
        lSay = llDeleteSubList(lSay, 0, 0);
    }
    lOut += [sOld];
    while (llGetListLength(lOut)) {
        llMessageLinked(LINK_DIALOG,NOTIFY,"0"+llList2String(lOut, 0), kID);
        //Notify(kID, llList2String(lOut, 0), TRUE);
        lOut = llDeleteSubList(lOut, 0, 0);
    }
}

SendValues() {
    //Debug("Sending all settings");
    //loop through and send all the settings
    integer n;
    string sToken;
    list lOut;
    for (; n < llGetListLength(g_lSettings); n += 2) {
        sToken = llList2String(g_lSettings, n) + "=";
        sToken += llList2String(g_lSettings, n + 1);
        if (llListFindList(lOut, [sToken]) == -1) lOut += [sToken];
    }
    n = 0;
    for (; n < llGetListLength(lOut); n++)
        llMessageLinked(LINK_ALL_OTHERS, LM_SETTING_RESPONSE, llList2String(lOut, n), "");

    llMessageLinked(LINK_ALL_OTHERS, LM_SETTING_RESPONSE, "settings=sent", "");//tells scripts everything has be sentout
}

UserCommand(integer iAuth, string sStr, key kID) {
    sStr = llToLower(sStr);
    if (sStr == "settings") PrintSettings(kID);
    else if (sStr == "load") {
        g_iLineNr = 0;
        if (llGetInventoryKey(g_sCard)) g_kLineID = llGetNotecardLine(g_sCard, g_iLineNr);
    } else if (sStr == "reboot" || sStr == "reboot --f") {
        if (g_iRebootConfirmed || sStr == "reboot --f") {
            llMessageLinked(LINK_DIALOG,NOTIFY,"0"+"Rebooting your %DEVICETYPE% ....",kID);
            g_iRebootConfirmed = FALSE;
            llMessageLinked(LINK_ALL_OTHERS, REBOOT,"reboot","");
            llSetTimerEvent(2.0);
        } else {
            g_kConfirmDialogID = llGenerateKey();
            llMessageLinked(LINK_DIALOG,DIALOG,(string)kID+"|\nAre you sure you want to reboot the %DEVICETYPE%?|0|Yes`No|Cancel|"+(string)iAuth,g_kConfirmDialogID);
        }
    } else if (sStr == "show storage") {
        llSetPrimitiveParams([PRIM_TEXTURE,ALL_SIDES,TEXTURE_BLANK,<1,1,0>,ZERO_VECTOR,0.0,PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
        llMessageLinked(LINK_DIALOG,NOTIFY,"0"+"To hide the storage prim again type:\n%PREFIX% hide storage\n",kID);
    } else if (sStr == "hide storage")
        llSetPrimitiveParams([PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,0>,ZERO_VECTOR,0.0,PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    else if (sStr == "runaway") llSetTimerEvent(2.0);
}

default {
    state_entry() {
        if (llGetStartParameter()==825) llSetRemoteScriptAccessPin(0);
        // Ensure that settings resets AFTER every other script, so that they don't reset after they get settings
        llSleep(0.5);
        g_kWearer = llGetOwner();
        g_iLineNr = 0;
        if (llGetInventoryKey(g_sCard)) {
            g_kLineID = llGetNotecardLine(g_sCard, g_iLineNr);
            g_kCardID = llGetInventoryKey(g_sCard);
        }
    }

    on_rez(integer iParam) {
        if (g_kWearer == llGetOwner()) {
            llSleep(0.5); // brief wait for others to reset
            SendValues();
        } else llResetScript();
    }

    dataserver(key id, string data) {
        if (id == g_kLineID) {
            string sID;
            string sToken;
            string sValue;
            integer i;
            if (data == EOF && g_sSplitLine != "" ) {
                data = g_sSplitLine ;
                g_sSplitLine = "" ;
            }
            if (data != EOF) {
                // first we can filter out & skip blank lines & remarks
                data = llStringTrim(data, STRING_TRIM_HEAD);
                if (data == "" || llGetSubString(data, 0, 0) == "#") jump nextline;
                // check for "continued" line pieces
                if ( llStringLength(g_sSplitLine) ) {
                    data = g_sSplitLine + data ;
                    g_sSplitLine = "" ;
                }
                if ( llGetSubString( data, -1, -1) == g_sDelimiter ) {
                    g_sSplitLine = llDeleteSubString( data, -1, -1) ;
                    jump nextline ;
                }
                i = llSubStringIndex(data, "=");
                sID = llGetSubString(data, 0, i - 1);
                data = llGetSubString(data, i + 1, -1);
                if (~llSubStringIndex(llToLower(sID), "_")) jump nextline ;
                //sID += "-";
                sID = llToLower(sID)+"_";
                list lData = llParseString2List(data, ["~"], []);
                for (i = 0; i < llGetListLength(lData); i += 2) {
                    sToken = llList2String(lData, i);
                    sValue = llList2String(lData, i + 1);
                    if (sValue != "") { //if no value, nothing to do
                        if (sID == "auth_") { //if we have auth, can only be the below, else we dont care
                            sToken = llToLower(sToken);
                            if (~llListFindList(["block","trust","owner"],[sToken])) {
                                list lTest = llParseString2List(sValue,[","],[]);
                                list lOut;
                                integer n;
                                do {//sanity check for valid entries
                                    if (llList2Key(lTest,n)) {//if this is not a valid key, it's useless
                                        lOut += llList2List(lTest,n,n+1);
                                    }
                                    n = n+2;
                                } while (n < llGetListLength(lTest));
                                sValue = llDumpList2String(lOut,",");
                            } 
                        }
                        g_lSettings = SetSetting(g_lSettings, sID + sToken, sValue);
                    }
                }
                @nextline;
                g_iLineNr++;
                g_kLineID = llGetNotecardLine(g_sCard, g_iLineNr);
            } else {
                // wait a sec before sending settings, in case other scripts are
                // still resetting.
                llSleep(2.0);
                SendValues();
            }
        }
    }

    link_message(integer iLink, integer iNum, string sStr, key kID) {
        if (iNum == CMD_OWNER || kID == g_kWearer) UserCommand(iNum, sStr, kID);
        else if (iNum == LM_SETTING_SAVE) {
            //save the token, value
            list lParams = llParseString2List(sStr, ["="], []);
            string sToken = llList2String(lParams, 0);
            string sValue = llList2String(lParams, 1);
            g_lSettings = SetSetting(g_lSettings, sToken, sValue);
        }
        else if (iNum == LM_SETTING_REQUEST) {
             //check the cache for the token
            if (SettingExists(sStr)) llMessageLinked(LINK_ALL_OTHERS, LM_SETTING_RESPONSE, sStr + "=" + GetSetting(sStr), "");
            else if (sStr == "ALL") llSetTimerEvent(2.0);
            else llMessageLinked(LINK_ALL_OTHERS, LM_SETTING_EMPTY, sStr, "");
        }
        else if (iNum == LM_SETTING_DELETE) DelSetting(sStr);
        else if (iNum == DIALOG_RESPONSE && kID == g_kConfirmDialogID) {
            list lMenuParams = llParseString2List(sStr, ["|"], []);
            kID = llList2Key(lMenuParams,0);
            if (llList2String(lMenuParams,1) == "Yes") {
                g_iRebootConfirmed = TRUE;
                UserCommand(llList2Integer(lMenuParams,3),"reboot",kID);
            } else llMessageLinked(LINK_DIALOG,NOTIFY,"0"+"Reboot aborted.",kID);
        } else if (iNum == LOADPIN && sStr == llGetScriptName()) {
            integer iPin = (integer)llFrand(99999.0)+1;
            llSetRemoteScriptAccessPin(iPin);
            llMessageLinked(iLink, LOADPIN, (string)iPin+"@"+llGetScriptName(),llGetKey());
        } else if (iNum == INTEGRITY) llMessageLinked(iLink,iNum,llGetScriptName(),"");
    }

    timer() {
        llSetTimerEvent(0.0);
        SendValues();
    }

    changed(integer iChange) {
        if (iChange & CHANGED_OWNER) llResetScript();
        if (iChange & CHANGED_INVENTORY) {
            if (llGetInventoryKey(g_sCard) != g_kCardID) {
                // the .settings card changed.  Re-read it.
                g_iLineNr = 0;
                if (llGetInventoryKey(g_sCard)) {
                    g_kLineID = llGetNotecardLine(g_sCard, g_iLineNr);
                    g_kCardID = llGetInventoryKey(g_sCard);
                }
            } else {
                llSleep(1.0);   //pause, then send values if inventory changes, in case script was edited and needs its settings again
                SendValues();
            }
        }
    }
}
