//---------------------------------------------------------------------------------//
//Copyright Info Below... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

//(c)2007 Ilobmirt Tenk

//This file is part of the FOSSL Vendor Project

//    FOSSL Vendor is free software; you can redistribute it and/or modify
//    it under the terms of the Lesser GNU General Public License as published by
//    the Free Software Foundation; either version 3 of the License, or
//    (at your option) any later version.

//    FOSSL Vendor is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    Lesser GNU General Public License for more details.

//    You should have received a copy of the Lesser GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

//---------------------------------------------------------------------------------//
//Copyright Info Above... Please Do not Remove                                     //
//---------------------------------------------------------------------------------//

//=================================================================//
//List all the global variables here...
//=================================================================//

//count of the current Notecard line to read
integer intSettingLines = 0;

//key of the notecard line to be read
key keySettingsId;

//determines if the vendor requested for this script to register if it was meant to display images
integer blnRequested = FALSE;

//determines if it is ready to make that response
integer blnReadyToPost = FALSE;

//determines if this object displays debugging output
integer blnDebug = FALSE;

//=================================================================//
//Customize the following variables
//=================================================================//

//relative category index of the vendor
integer intCategory = 0;

//relative subcategory index of the vendor
integer intSubCategory = 0;

//Is the Category of the vendor absolute (true) or relative (False)
integer blnAbsoluteCategory = FALSE;

//Is the SubCategory of the vendor absolute (true) or relative (False)
integer blnAbsoluteSubCategory = FALSE;

//does this prim display images?
integer blnImages = FALSE;

//=================================================================//
//Customize the above variables
//=================================================================//

//This displays messages to the owner if debug mode has been set to true
debugMessage(string strMessage){

    if(blnDebug == TRUE){

        llOwnerSay("FOSSLVendorLink:    " + strMessage);
        
    }
    
}

default
{

        //start reading the settings notecard upon script start
        state_entry(){
                
            //Obtain the first line of the vendor link settings
            keySettingsId = llGetNotecardLine("FOSSL_LINK_SETTINGS", intSettingLines); 

        
        }

        //Reset the script when the container object gets rezzed
        on_rez(integer intParam){
     
            llResetScript();
              
        }

        //If somehing within the vendor changed, update the setting by resetting the script
        changed(integer change){
     
        // If I change the contents of the vendor
        if(change & CHANGED_INVENTORY){ 
            
            //reset the script to make use of the changes
            llResetScript();
            
        }
              
    }

    //Read the link settings notecard. Configure the link based on each line.
    dataserver(key query_id, string data) {
        
        if (query_id == keySettingsId) {
            if (data != EOF) {    // not at the end of the notecard

                debugMessage("Notecard Line = \"" + data + "\"");
                //split the record into variable names and values
                list lstSplit = llParseString2List(data,["="],[]);
                string strVariable = llToUpper(llStringTrim(llList2String(lstSplit,0),STRING_TRIM));
                string strValue = llStringTrim(llList2String(lstSplit,1),STRING_TRIM);

                if(strVariable == "CATEGORY"){

                    intCategory = (integer) strValue;
                    debugMessage("intCategory = " + (string) intCategory);
            
            
                }
                if(strVariable == "SUBCATEGORY"){

                    intSubCategory = (integer) strValue;
                    debugMessage("intSubCategory = " + (string) intSubCategory);
            
                }
                if(strVariable == "IMAGES"){

                    blnImages = (integer) strValue;
                    debugMessage("blnImages = " + (string) blnImages);
            
                }
                if(strVariable == "ABSOLUTE CATEGORY"){

                    blnAbsoluteCategory = (integer) strValue;
                    debugMessage("blnAbsoluteCategory = " + (string) blnAbsoluteCategory);
            
                }
                if(strVariable == "ABSOLUTE SUBCATEGORY"){

                    blnAbsoluteSubCategory = (integer) strValue;
                    debugMessage("blnAbsoluteSubCategory = " + (string) blnAbsoluteSubCategory);
            
                }

                keySettingsId = llGetNotecardLine("FOSSL_LINK_SETTINGS", ++intSettingLines); // request next line
            }
            else{
             
                //If this link is a display, add self to vendor's list of displays
                if(blnImages == TRUE){

                    blnReadyToPost = TRUE;

                    if(blnRequested == TRUE){

                        debugMessage("addScreen#" + (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory);
                        llMessageLinked(LINK_ROOT,0,"addScreen#" + (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory,NULL_KEY);
                        
                    }
                    
                }
                                      
            }
        }
        
    }

    //Tell the vendor to change index whenever it gets touched by an avatar
    touch_start(integer total_number)
    {
        
        //If an avatar touches this object, tell the main script to change its selected index
        //If the index is relative to 0#0, ignore the click
        if ((llDetectedType(0) & AGENT) && ((blnAbsoluteCategory == TRUE || blnAbsoluteSubCategory == TRUE) || (intCategory != 0 || intSubCategory != 0)) ){
        
            debugMessage("linkClicked#"+ (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory);
            llMessageLinked(LINK_ROOT,0,"linkClicked#"+ (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory,NULL_KEY);
        
        }
    
    }

    link_message(integer sender_number, integer number, string message, key id)
    {

        //Separate the linked message into the function and variables
        list lstMessage = llParseString2List(message,["#"],[]);
        string strFunction = llList2String(lstMessage,0);

        //getDisplays
        if(strFunction == "getDisplays" ){

            blnRequested = TRUE;
            debugMessage("Link has been requested to register itself as a diplay if possible.");
            debugMessage("blnRequested = " + (string) blnRequested);
            debugMessage("blnReadyToPost = " + (string) blnReadyToPost);
            debugMessage("blnImages = " + (string) blnImages);
            
            if(blnImages == TRUE){

                debugMessage("Link is ready to post, registering...");
                debugMessage("addScreen#" + (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory);
                        llMessageLinked(LINK_ROOT,0,"addScreen#" + (string) blnAbsoluteCategory + "#" + (string) intCategory + "#"+ (string) blnAbsoluteSubCategory + "#" + (string) intSubCategory,NULL_KEY);

            }

        }
        //debugMode#blnEnabled
        else if(strFunction == "debugMode"){

            blnDebug = (integer) llList2String(lstMessage,1);
            
        }
        
    }

}