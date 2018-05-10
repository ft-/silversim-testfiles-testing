//settings
integer SHOW_DESCRIPTIONS=FALSE;
integer SHOW_SENDER_NUM=FALSE;
integer SHOW_UNKNOW_NUM=TRUE;
integer USE_OWNER_SAY=TRUE; //llWhispher tends to shuffel the messages more than llOwnerSay, so I suggest to set this to TRUE;

//blacklist filter
list BLACKLIST_SENDER_NUM=[];
list BLACKLIST_NUM=[];
list BLACKLIST_STR=[];
list BLACKLIST_ID=[];

//additional informations
list REPLACE_SENDER_NUM=[];
list REPLACE_NUM=[
	//format: number, numberName, description
	//INTERNAL TO nPose BASIC SCRIPTS
	1, "SEND_CHATCHANNEL", "core sent out chatChannel", 
	2, "REZ_ADJUSTERS", "menu sending a request to slave to rez all adjusters", 
	3, "ADJUSTER_REPORT", "core got info from adjuster and is forwarding it to the slave for reporting", 
	
	200, "DOPOSE", "core is generated in the core when notecard or data from data store line starts with ANIM", 
	201, "ADJUST", "menu to core.  The core rezzes adjuster prims.", 
	202, "SWAP", "menu to core.  This triggers the swap of AV's.", 
	203, "KEYBOARD_CONTROL", "TODO: need to look at this", 
	204, "DUMP", "menu to core to have core chat out in local the current pose set data.  This is used to trigger the core event which saves current in memory data", 
	205, "STOPADJUST", "menu to core as a menu selection to stop adjusting.  The core send out chat to kill the adjusters.", 
	206, "SYNC", "menu sends out used by the core and linked out to slaves.  The slaves do the actual sync.", 
	207, "DOBUTTON (depecated)", "Use DOPOSE instead", 
	208, "ADJUSTOFFSET", "menu to core call used only for adjusting offsets to correct AV size.", 
	209, "SETOFFSET", "menu to core call used only for adjusting offsets to correct AV size.", 
	210, "SWAPTO", "menu to core to change seats.", 
	212, "DUMPALL", "menu call to core used to signal in memory data dump of all saved pose sets to owner's local chat. This chat is used to permanently update the .config notecard.", 
	221, "PREPARE_MENU_STEP3_READER", "This message is sent from the NC Reader to the core to initiate a remenu operation",
	222, "DOPOSE_READER", "With the addition of 'nPose NC Reader' script for cache of pose set button selections, this is used to send the pose command to the core.", 
	223, "DOBUTTON_READER", "With the addition of 'nPose NC Reader' script for cache of pose set button selections, this is used to send the button command to the core.", 
	224, "NC_READER_REQUEST", "Used by NC Reader script.  Someone sent a request to use the Reader", 
	225, "NC_READER_RESPONSE", "Used by NC Reader script.  Script is returning the data requested by NC_READER_REQUEST", 
	300, "CORERELAY", " to the core. This triggers chat to props directly from the core.  There must be a custom receiver script in the props to interpret and act on this message.", 
	310, "PLUGIN_COMMAND_REGISTER", "registers a new NC command",
	311, "UNKNOWN_COMMAND", "If the core parses a line with an unknown command, it will send out the line for debugging or other purposes.",

	
	34333, "SLOT_UPDATE (deprecated)", "from the core when PosDump is clicked to save new positions to memory of the in memory plugin.", 
	34334, "MEMORY_USAGE", "Sends out a request to all script so they can report their memory stats.", 
	35353, "SEAT_UPDATE", " core sends out to update everyone when the slots list has changed in any way.  changed seats or new pose.", 
	35354, "SEAT_BUTTONS (Deprecated)", "menu received seat buttons list", 
	999999, "REQUEST_CHATCHANNEL", "slave sent request to core to get chatChannel", 
	69696969, "myChannel", "adjuster hud is on this channel and communicates with the receiver/sender script in the adjuster prim.", 
	
	-222, "UNSIT", "Unsits an avatar",
	-240, "OPTIONS", "a global option string", 
	-241, "FACIALS_FLAG", "any string received by the slave with arb number -241 will be assigned to the permissions.  This should either be 'on' or 'off'.", 
	-242, "DEFAULT_CARD", "",
//eventHandling -700 - -799
	-700, "ON_SAT", "generic event",
	-701, "ON_NOT_SAT", "generic event",
	-702, "ON_NEW", "generic event",
	-703, "ON_CHANGE", "generic event",
	-704, "ON_LOST", "generic event",
	-705, "ON_EMPTY", "generic event",
	-706, "ON_NOT_EMPTY", "generic event",
	-707, "ON_FULL", "generic event",
	-708, "ON_NOT_FULL", "generic event",
	-719, "ON_INVALID", "generic event",
	-790, "ON_PROP_REZZED", "generic event",

	-800, "DOMENU", "call to menu to pull menu dialog.", 
	-801, "DOMENU_ACCESSCTRL (Deprecated)", "Instead use DOMENU", 
	-802, "arbNum (Deprecated)", "used to send out the current path to be used when a plugin menu returns to nPose menu.  This path can be used to bring back the same menu that called the plugin's menu in the beginning.", 
	-804, "UDPBOOL", "With this message you can define a 'user defined permission' for use inside the menu format: name=0|1[|name=0|1...]",
	-805, "UDPLIST", "With this message you can define a 'user defined permission' for use inside the menu format: name=listOfUuids[|name=listOfUuids...]",
	-806, "USER_PERMISSION_UPDATE (deprecated)", "Use UDPLIST or UDPBOOL instead.",
	-807, "MACRO", "Used to set macro.",
	-810, "PLUGIN_MENU_REGISTER", "A method to inject menus created by a plugin into the nPose menu tree.",
	-815, "MENU_SHOW", "The final step in the creation of a menu.",
	-820, "PREPARE_MENU_STEP1", "internal message for menu creation.",
	-821, "PREPARE_MENU_STEP2", "internal message for menu creation.",
	-822, "PREPARE_MENU_STEP3", "internal message for menu creation.",
	-830, "PLUGIN_ACTION", "This message is used to inform a plugin to do its actions.",
	-831, "PLUGIN_ACTION_DONE", "Plugin did its actions.",
	-832, "PLUGIN_MENU", "This message is used to inform a plugin to generate its menu.",
	-833, "PLUGIN_MENU_DONE", "Plugin menu is generated.",
	-888, "EXTERNAL_UTIL_REQUEST (deprecated)", "menu functions such as ChangeSeats, Sync, Offsets, Admin menu.  See Utilities notecards for usage.", 
	-900, "DIALOG", "dialog script call to and from menu", 
	-901, "DIALOG_RESPONSE", "dialog script call to menu to deliver user clicked response", 
	-902, "DIALOG_TIMEOUT", "dialog call to menu when dialog has timed out with no response from user", 
	-999, "HUD_REQUEST", "rez or detach admin hud",
	
	//PLUGIN SPECIFIC
	1334, "nPose Giver Script:LnkMsgNo", "giver plugin used for sending information to use the giver",
	1337, "RLV Timer Plugin (deprecated):RLV Timer Release", "LINKMSG|1337|10|%AVKEY%  where 10 is the number of minutes before releasing a captured victim",
	1338, "RLV Timer Plugin (deprecated):???", "",
	1444, "nPose plugin AnimSoundOnce:???", "",
	2732, "nPose LM/LG chains plugin (plugin_lockmeister_lockguard):gCMD_SET_CHAINS", "",
	2733, "nPose LM/LG chains plugin (plugin_lockmeister_lockguard):gCMD_REM_CHAINS", "",
	2734, "nPose LM/LG chains plugin V0.02+:gCMD_CONFIG", "Config for the chain particle",
	7200, "nPose Chain Point Plugin:STARTCHAIN", "channel relayed out to chain point to start chains.", 
	7201, "nPose Chain Point Plugin:STOPCHAIN", "channel relayed out to chain point to stop chains.", 
	27130, "plugin_movePrims:gCMD_GET_PRIMS", "",
	27131, "plugin_movePrims:gCMD_SET_PRIMS", "",
	98132, "morph plugin:arbNum", "Used to send notecard name to the morph plugin",

	-123, "Rygel sequencer plugin:MENU_LINK", "used for menu", 
	-125, "Rygel sequencer plugin:MENU_LINK", "used to let core know it is time for next sequence",
	-233, "RLV:SENSOR_START (deprecated)", "",
	-234, "RLV:SENSOR_END (deprecated)", "",
	-237, "RLV:SEND_CURRENT_VICTIMS (deprecated)", "",
	-238, "RLV:VICTIMS_LIST (deprecated)", "old RLV plugin sent the victims list to the menu.", 
	-239, "RLV:???(change current victim)(deprecated)", "",
	
	-1011, "vehicle plugin:SIT_BUTTON", "", 
	-1012, "vehicle plugin:STAND_BUTTON", "", 
	-1200, "vehicle plugin:SPEED_SET", "signal speed change", 
	-1201, "vehicle plugin:VEHICLETYPE", "used to select vehicle type", 
	-2241, "nPose Sequencer:???", "",
	-2344, "sound plugin:arbNum", "message to stop sound",
	-2345, "sound plugin:arbNum", "message to start sound",
	-6000, "Updater:listenChannel", "channel used by the updater to chat with the updater script within the nPose update target",
	-6001, "giver relay plugin:listenChannel", "link message to giver relay plugin and used as the channel to chat with item to temp attach",
	-6002, "TempAttach plugin:listenChannel", "listen channel for the TempAttach plugin menu dialog selection.", 
	//-8000 - -8050 reserverd for Leona (slmember1 Resident)
	-8000, "RLV+:RLV_MENU_COMMAND", "https://github.com/LeonaMorro/nPose-RLV-Plugin/wiki/Link-messages", 
	-8010, "RLV+:RLV_CORE_COMMAND", "https://github.com/LeonaMorro/nPose-RLV-Plugin/wiki/Link-messages", 
	-8012, "RLV+:RLV_CHANGE_SELECTED_VICTIM", "https://github.com/LeonaMorro/nPose-RLV-Plugin/wiki/Link-messages", 
	-8013, "RLV+:RLV_VICTIMS_LIST_UPDATE", "https://github.com/LeonaMorro/nPose-RLV-Plugin/wiki/Link-messages", 
	-8040, "Xcite! Plugin:XCITE_COMMAND", "https://github.com/LeonaMorro/nPose-Xcite-plugin/wiki/Link-messages",
	-8050, "nPose Prim Params Editor plugin", "https://github.com/nPoseTeam/Prim-Params-Editor-plugin",
	//
	-888888, "tip jar plugin:arb number", "exclusive to the tip jar to send parameters needed in this plugin.", 
	-22452987, "color/texture changer plugin:arbNum (deprecated, doesn't work with nPose V3)", "The plugin uses this to identify when it is supposed to act on the message.  It accepts the message and relays out to prims using this number as a listen channel.  This same script located in props receives the info and does the retexturing of prims.", 
	-22452988, "color/texture changer plugin:arbNum+1 (deprecated, doesn't work with nPose V3)", "The plugin uses this to identify when it is supposed to act on the message.  It accepts the message and relays out to prims using this number as a listen channel.  This same script located in props receives the info and does the retexturing of prims.", 
	-1812221819, "RLV plugin (deprecated):relaychannel", "RLV channel"
];

list REPLACE_STR=[];
list REPLACE_ID=[
	NULL_KEY, "NULL_KEY"
];

speak(string str) {
	if(USE_OWNER_SAY) {
		llOwnerSay(str);
	}
	else {
		llWhisper(0, str);
	}
}

default {
	state_entry() {
		llOwnerSay(llGetScriptName() + " up and running. " + (string)llGetFreeMemory() + " Bytes free.");
	}
	link_message(integer sender_num, integer num, string str, key id) {
		if(!~llListFindList(BLACKLIST_NUM, [num])) {
			if(!~llListFindList(BLACKLIST_ID, [(string)id])) {
				if(!~llListFindList(BLACKLIST_SENDER_NUM, [sender_num])) {
					if(!~llListFindList(BLACKLIST_STR, [str])) {
						integer isKnownNum;
						string sSender_num=(string)sender_num;
						string sNum=(string)num;
						string sStr=(string)str;
						string sId=(string)id;
						string sDesc;
						integer index;
						if(~(index=llListFindList(REPLACE_SENDER_NUM, [sender_num]))) {
							sSender_num=llList2String(REPLACE_SENDER_NUM, index+1);
						}
						if(~(index=llListFindList(REPLACE_NUM, [num]))) {
							sNum=llList2String(REPLACE_NUM, index+1) + " (" + sNum + ")";
							sDesc=llList2String(REPLACE_NUM, index+1) + " " + llList2String(REPLACE_NUM, index+2);
							isKnownNum=TRUE;
						}
						if(~(index=llListFindList(REPLACE_STR, [str]))) {
							sStr=llList2String(REPLACE_STR, index+1);
						}
						if(~(index=llListFindList(REPLACE_ID, [(string)id]))) {
							sId=llList2String(REPLACE_ID, index+1);
						}
						if(SHOW_UNKNOW_NUM || isKnownNum) {
							if(SHOW_SENDER_NUM) {
								speak("\n#>" + llDumpList2String([sSender_num, sNum, sStr, sId], "\n#>"));
							}
							else {
								speak("\n#>" + llDumpList2String([sNum, sStr, sId], "\n#>"));
							}
							if(SHOW_DESCRIPTIONS) {
								speak("\n" + sDesc);
							}
						}
					}
				}
			}
		}
	}
}