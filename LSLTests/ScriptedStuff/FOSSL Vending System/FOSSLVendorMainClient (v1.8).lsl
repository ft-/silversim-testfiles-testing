//FOSSLVendorMainClient
//---------------------------------------------------------------------------------//
//Copyright Info Below... Please Do not Remove //
//---------------------------------------------------------------------------------//

//(c)2007 Ilobmirt Tenk

//This file is part of the FOSSL Vendor Project

// FOSSL Vendor is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.

// FOSSL Vendor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

//---------------------------------------------------------------------------------//
//Copyright Info Above... Please Do not Remove //
//---------------------------------------------------------------------------------//

//=================================================================//
//List all the global variables here...
//=================================================================//

string strCurrentItem = ""; //This is the current item that the product index is on
// the server, store the notecards in the server
string strINFO = " Info"; //This is the suffix for the info notecard - create one for each product - if using
integer intSeparateInfo = TRUE; //SET TRUE OR FALSE - if true the vendor will deliver a separate card for each item

list lstItemRequestList; //List of items to be requested from the server
//each record is in the form of "Category#SubCategory#DatabaseKey"

list lstDisplays; //List of displays to render products on
//Each display has a record of "Link#absoluteCategory#Category#absoluteSubCategory #SubCategory"

integer intHashCounter = -2147483646; //Used in the creation of a unique request

integer intSettingLines = 0; //Total # of lines in the settings notecard

integer intProductLines = 0; //Total # of lines in the products notecard

integer intItemRequestList = 0; //Number of item database requests to send to the server

integer intProductIndexCategory = 0; //Current index of visible product shown by Category

integer intProductIndexSubCategory = 0; //Current index of visible product shown by sub Category

integer intProductIndexMaxCategory = 0; //Maximum index of categorys

integer intProductIndexMaxSubCategory = 0; //Maximumindex of SubCategorys

integer intInfoCount = 0; //Number of times people clicked on the info button

integer intEmailRequestStarted = 0; //Last time an e-mail was sent out to the server

integer intLastProductUpdate = 0; //Last time product list was updated

key keySettingsId; //Used to load system Settings

key keyProductsUUID; //The uuid of the notecard to be read for products

key keyProductCategories; //The key of the line being read from the products card to determine length of categories

integer blnWaitingForServer = FALSE; //Used to determine if vendor is currently requesting a uuid for the product notecard

integer blnServerDown = TRUE; //Used to determine if the in-world server is down

integer blnDebug = FALSE; //Used to determine if vendor will output debugging information

string strVendorLocation = ""; //This is the slurl to the vendor location

//=================================================================//
//Customize the following variables
//=================================================================//

key keyTexLoading = "56617727-a972-f7d2-a730-484644a1fcb7"; //Texture UUID to represent that an item is loading

key keyTexOffline = "b8426d53-221d-9fc2-5b29-3ef16e2bd7a3"; //Texture UUID to represent the vendor has no connection to the server

key keyTexNothing = "93481f65-67ff-f166-cc64-e6fe1069c1c1"; //Texture UUID to represent that there is no item for this index

key keyServer = NULL_KEY; //This is a pointer to an object server. If this is not NULL_KEY, the vending system will consider selling items from that server.

string strInfoCardName = ""; //Name of the information notecard that talks about your company

string strProductsCardName = "FOSSL_PRODUCTS_LIST"; //Name of the products card to read off of

string strEncryptionKey = ""; //Key to encrypt its communications with

integer intBuffer = 0; //How big do you want you product inventory to be? This goes beyond the # of displays

float fltInventoryRefresh = 3600.0; //Time delay before vendor clears its product inventory and makes another request for more items

integer intServerTimeout = 60; //Time in seconds before vendor is considered down

integer intCommChannel = 45; //Channel in which you can communicate to your vending machine

string strEmailOnSale = ""; //Email this address upon a sale to say that an item has been bought

integer blnEmailAgents = FALSE; //Can this script export the task of sending e-mails to other in-world objects?

//=================================================================//
//Customize the above variables
//=================================================================//



//=================================================================//
//Define global Functions here...
//=================================================================//

//This displays messages to the owner if debug mode has been set to true
debugMessage(string strMessage){

    if(blnDebug == TRUE){

        llOwnerSay("FOSSLVendorMainClient: " + strMessage);

    }

}

//Used for encrypting communications between itself and the inworld server
string encrypt(string strPayload){

    //If there is an encryption key...
    if(strEncryptionKey != ""){

        //Use this simple Algrorythm to encrypt/decrypt input string
        return llXorBase64StringsCorrect(llStringToBase64(strPayload), llStringToBase64(strEncryptionKey));

    }
    //otherwise...
    else{

        //Just return the string as is.
        return strPayload;

    }

}

//Used for decrypting communications between itself and the inworld server
string decrypt(string strPayload){

    //If there is an encryption key...
    if(strEncryptionKey != ""){

    //Use this simple Algrorythm to encrypt/decrypt input string
    return llBase64ToString(llXorBase64StringsCorrect(strPayload, llStringToBase64(strEncryptionKey)));

    }
    //otherwise...
    else{

        //Just return the string as is.
        return strPayload;

    }

}

//Enters the vending system into an offline mode if not offline already
goOffline(){

    blnServerDown = TRUE; //Set state of vendor to be offline
    clearRequests(); //Clear any pending requests for products
    llMessageLinked(LINK_SET,0,"goingOffline",NULL_KEY); //Notify system its going offline
    displaysOffline(); //Reflect the changes on display

}

//Restores functionality to the vending machine from an offline mode
goOnline(){

    blnServerDown = FALSE; //Set state of vendor to be online
    llMessageLinked(LINK_SET,0,"goingOnline",NULL_KEY);
    displaysLoading(); //reflect changes on display

}

//This will set each display to a loading texture
//This will also send out database requests for each link
displaysLoading(){

    list lstDisplay = [];
    integer intIndex = 0;
    integer intDisplayIndex = 0;
    integer intDisplays = llGetListLength(lstDisplays);
    integer blnDisplayAbsoluteCategory = 0;
    integer blnDisplayAbsoluteSubCategory = 0;
    integer intDisplayCategory = 0;
    integer intDisplaySubCategory = 0;
    integer intDisplayRelativeCategory = 0;
    integer intDisplayRelativeSubCategory = 0;

    strCurrentItem = "";
    updatePrices();

    //Loop through each index of the available displays
    for(; intIndex < intDisplays; intIndex++){

        //collect prim location, then texturethem with the offline texture
        //Link#absoluteCategory#Category#absoluteSubCategory #SubCategory
        lstDisplay = llParseString2List(llList2String(lstDisplays,intIndex),["#"],[]);
        intDisplayIndex = (integer) llList2String(lstDisplay,0);

        intDisplayRelativeCategory = (integer) llList2String(lstDisplay,2);
        blnDisplayAbsoluteCategory = (integer) llList2String(lstDisplay,1);
        blnDisplayAbsoluteSubCategory = (integer) llList2String(lstDisplay,3);
        intDisplayRelativeSubCategory = (integer) llList2String(lstDisplay,4);

        //Obtain displayed category
        if(blnDisplayAbsoluteCategory == TRUE){

            intDisplayCategory = intDisplayRelativeCategory;
            debugMessage("Display category is Absolute");

        }
        else{

            intDisplayCategory = intDisplayRelativeCategory + intProductIndexCategory;
            debugMessage("Display category is Relative");
            
            debugMessage("Normalising Category index");
            //Make sure displayed Category is between 0 and the maximum category
            while(intDisplayCategory > intProductIndexMaxCategory){

                intDisplayCategory -= (intProductIndexMaxCategory + 1);

            }

            while(intDisplayCategory < 0){

                intDisplayCategory += (intProductIndexMaxCategory + 1);

            }

        }

        //Obtain displayed SubCategory
        if(blnDisplayAbsoluteSubCategory == TRUE){

            intDisplaySubCategory = intDisplayRelativeSubCategory;
            debugMessage("Display subcategory is Absolute");

        }
        else{

            intDisplaySubCategory = intDisplayRelativeSubCategory + intProductIndexSubCategory;
            debugMessage("Display subcategory is relative");
        
            debugMessage("Normalising Category index");
            //Make sure displayed SubCategory is between 0 and the maximum category
            while(intDisplaySubCategory > intProductIndexMaxSubCategory){

                intDisplaySubCategory -= (intProductIndexMaxSubCategory + 1);

            }

            while(intDisplaySubCategory < 0){

                intDisplaySubCategory += (intProductIndexMaxSubCategory + 1) ;

            }

        }

        debugMessage("Display Categories found @ " + (string) intDisplayCategory + "#" + (string) intDisplaySubCategory);

        llSetLinkTexture(intDisplayIndex, keyTexLoading ,ALL_SIDES);

        debugMessage("Item Request for link # "+ (string) intDisplayIndex +" = " + (string) intDisplayCategory + "#" + (string) intDisplaySubCategory);
        itemRequest(intDisplayCategory,intDisplaySubCategory,intDisplayIndex);

    }

}

//This will Update all visible displays with the offline texture
//Also, it will prevent payments to be made to the machine
displaysOffline(){

    list lstDisplay = [];
    integer intIndex = 0;
    integer intDisplayIndex = 0;
    integer intDisplays = llGetListLength(lstDisplays);

    strCurrentItem = "";
    updatePrices();

    //Loop through each index of the available displays
    for(; intIndex < intDisplays; intIndex++){

        //collect prim location, then texturethem with the offline texture
        lstDisplay = llParseString2List(llList2String(lstDisplays,intIndex),["#"],[]);
        intDisplayIndex = (integer) llList2String(lstDisplay,0);
        llSetLinkTexture(intDisplayIndex, keyTexOffline ,ALL_SIDES);

    }

}

//This will update a single screen with an associated texture
updateDisplay(string strReturnQuery){

    debugMessage("strReturnQuery for texturing = " + strReturnQuery);
    //Extract the query into its elements
    //return query = "dbResults#ReturnQuery#(productRecord)"
    //ProductRecord = "Category#Subcategory#Price#Name#TextureUUID"
    list lstReturnQuery = llParseString2List(strReturnQuery,["#"],[]);

    //extract the query ID into its elements
    //queryID = "linkNumber^queryHash"
    list lstQuery = llParseString2List(llList2String(lstReturnQuery,1) ,["#"],[]);
    string strTextureElement = llList2String(lstReturnQuery,6);

    integer intLinkNumber = (integer) llList2String(lstQuery,0);
    debugMessage("Texture for Prim #"+ (string) intLinkNumber +" = " + strTextureElement );

    //Granted, the image for the item index is available, texure it.
    if( (strTextureElement != "") && (strTextureElement != "NO_IMAGE_AVAILABLE") ){

        llSetLinkTexture(intLinkNumber,(key) strTextureElement,ALL_SIDES);

    }
    //If there doesn't appear to be an image for the product, give it the nothing texture
    else{

        llSetLinkTexture(intLinkNumber,keyTexNothing,ALL_SIDES);

    }

    //If query returned something that is equal to product index, capture it as a current index
    if((llList2String(lstReturnQuery,2) + "#" + llList2String(lstReturnQuery,3)) == ((string)intProductIndexCategory + "#" + (string)intProductIndexSubCategory )){

        strCurrentItem = llDumpList2String(llList2List(lstReturnQuery,2,-1),"#");
        //change the info card name
        if (intSeparateInfo == TRUE){

            // use the product name plus the strINFO suffix to identify the notecard to deliver;
            strInfoCardName = llList2String(llList2List(lstReturnQuery,2,-1), 3) + strINFO;
            
        }
        //NB if FALSE the originally set info card wil be used instead;

        debugMessage("Current Info name:" + strInfoCardName);
        //Update prices
        updatePrices();

    }

}


//This makes the vendor update the price based upon current Index as well as the displayed objects.
updatePrices(){

    list lstParsedItem = [];
    integer intPrice = 0;

    if(strCurrentItem != ""){

        lstParsedItem = llParseString2List(strCurrentItem,["#"],[]);
        intPrice = (integer) llList2String(lstParsedItem,2);
    
        if((intPrice > 0) && (blnServerDown == FALSE) ){

            llSetPayPrice(PAY_HIDE, [intPrice, PAY_HIDE, PAY_HIDE, PAY_HIDE]);

        }
        else{

            llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);

        }

        llMessageLinked(LINK_SET,intPrice,"updatePrice",NULL_KEY); //set the prices for the buy/gift buttons

    }
    else{

        llSetPayPrice(PAY_HIDE, [PAY_HIDE, PAY_HIDE, PAY_HIDE, PAY_HIDE]);

    }


}


//This function adds item requests to the buffer before it starts obtaining them from the database
itemRequest(integer intCategory, integer intSubCategory, integer intLink){

    //keep hash counter going. Never let it reach its end
    if(intHashCounter == 2147483646 ){

        intHashCounter = -2147483646;

    }

    string strQueryID = (string)intLink + "^" + llMD5String("H@5h",++intHashCounter);

    //take that record and add it to the waitlist
    lstItemRequestList = llListReplaceList((lstItemRequestList = []) + lstItemRequestList,[(string)intCategory + "#" + (string)intSubCategory + "#" + strQueryID ],intItemRequestList,intItemRequestList);

    //increment # of items on the waitlist
    intItemRequestList++;

    llMessageLinked(LINK_SET,0,"dbRequest#" + strQueryID + "#" + (string) intCategory + "#" + (string) intSubCategory ,NULL_KEY);

}

//This function removes item requests by their index
removeItemRequest(integer intIndex){

    //remove the item by index
    lstItemRequestList = llDeleteSubList((lstItemRequestList = []) + lstItemRequestList,intIndex,intIndex);
    
    //decrement # of items on the waitlist
    intItemRequestList--;


}

//clears the request buffer
clearRequests(){

    lstItemRequestList= [];
    intItemRequestList = 0;

}

//Proccesses the dbQuery to see if it matches a request
processQuery(string strDBQuery){

    integer intIndex = -1;
    integer blnFound = FALSE;
    string strQueryID = llList2String(llParseString2List(strDBQuery,["#"],[]),1);
    list lstParsedRequest = [];

    debugMessage("Proccessing Query = " + strQueryID );

    //loop while there are requests to proccess and if the query doesn't match
    do{

        ++intIndex; //advance an index

        lstParsedRequest = llParseString2List(llList2String(lstItemRequestList,intIndex),["#"],[]);

        if(strQueryID == llList2String(lstParsedRequest,2) ){

            blnFound = TRUE;

            updateDisplay(strDBQuery);

            removeItemRequest(intIndex);

        }

    }while( (intIndex < intItemRequestList) && (blnFound == FALSE) );

}

default
{
    //Activated upon the beginning of script execution
    //Start setting up vendor settings
    state_entry(){

        //Keep debug mode in all scripts the same on startup or reset
        llMessageLinked(LINK_SET,0,"debugMode#"+ (string) blnDebug ,NULL_KEY);
        llOwnerSay("FOSSLVendorClient: Loading Settings...");
        keySettingsId = llGetNotecardLine("FOSSL_CLIENT_SETTINGS", intSettingLines); //Obtain the first line of the vendor settings
        
        vector vectSimLocation = llGetPos();
        string strPosX = (string) llRound(vectSimLocation.x);
        string strPosY = (string) llRound(vectSimLocation.y);
        string strPosZ = (string) llRound(vectSimLocation.z);
        

        strVendorLocation = "http://slurl.com/secondlife/" + llEscapeURL(llGetRegionName()) + "/" + strPosX + "/" + strPosY + "/" + strPosZ;
        debugMessage("Vendor Location = " + strVendorLocation );
     
    }

    //Activated upon rezzing of its container prim
    //Use this event to update the settings of the vending system
    on_rez(integer start_param){

        //reset the script when I rez it
        llResetScript();

    }

    //Activated upon modification of vendor's inventory
    //Reset script to make use of possible changes
    changed(integer change){

        // If I change the contents of the vendor
        if(change & CHANGED_INVENTORY){

        //reset the script to make use of the changes
            llResetScript();

        }

    }

//Activate this event when a companion script sends out a linked message
    //Use this event to determine if that script is making a request or response of this script
    //This script accepts requests to go online of offline, link clicked requests,
    //screen addition requests, buying requests, and info requests
    link_message(integer sender_num, integer num, string str, key id){

        debugMessage("Link message recieved = " + str);

        list lstMessage = llParseString2List(str,["#"],[]);
        string strFunction = llList2String(lstMessage,0);

        //Vendor module wants vendor to go online
        if(strFunction == "goOnline"){

            goOnline();

        }
        //Vendor module wants vendor to go offline
        if(strFunction == "goOffline"){

            goOffline();

        }
        //"linkClicked#absoluteCategory#CategoryShift#absolut eSubcategory#SubCategoryShift"
        if(strFunction == "linkClicked"){

            integer intDiffCategory = (integer) llList2String(lstMessage,2);
            integer intDiffSubCategory = (integer) llList2String(lstMessage,4);
            integer blnAbsoluteCategory = (integer) llList2String(lstMessage,1);
            integer blnAbsoluteSubCategory = (integer) llList2String(lstMessage,3);

            //Determine Category
            if(blnAbsoluteCategory == TRUE){

                intProductIndexCategory = intDiffCategory;

            }
            else{

                intProductIndexCategory += intDiffCategory;
                
                //Keep Category larger than 0
                while(intProductIndexCategory < 0){

                    intProductIndexCategory += (intProductIndexMaxCategory + 1);

                }
                //Keep Category less than or equal to max
                while(intProductIndexCategory > intProductIndexMaxCategory){

                    intProductIndexCategory -= (intProductIndexMaxCategory+1);

                }

            }

            //Determine Subcategory
            if(blnAbsoluteSubCategory == TRUE){

                intProductIndexSubCategory = intDiffSubCategory;

            }
            else{

                intProductIndexSubCategory += intDiffSubCategory;
                
                //Keep SubCategory larger than 0
                while(intProductIndexSubCategory < 0){

                    intProductIndexSubCategory += (intProductIndexMaxSubCategory + 1);

                }

                //Keep SubCategory less than or equal to max
                while(intProductIndexSubCategory > intProductIndexMaxSubCategory){

                    intProductIndexSubCategory -= (intProductIndexMaxSubCategory + 1);

                }

            }

            clearRequests();
            displaysLoading();

        }
        //"addScreen#absoluteCategory#CategoryShift#absoluteS ubcategory#SubCategoryShift"
        else if(strFunction == "addScreen"){

            debugMessage("Screen added ... Updating the screens");

            lstDisplays += [(string) sender_num + "#" + llList2String(lstMessage,1) + "#" + llList2String(lstMessage,2) + "#" + llList2String(lstMessage,3) + "#" + llList2String(lstMessage,4) ];

            clearRequests();
            llMessageLinked(LINK_SET,0,"addBuffer" ,NULL_KEY); //set new Buffer Length
            displaysLoading();


        }
        //"itemBought#BuyerUUID"
        else if(strFunction == "itemBought"){

            key keyBuyerUUID = (key)llList2String(lstMessage,1);
            list lstItemBought = llParseString2List(strCurrentItem,["#"],[]);
            string strItemBought = llList2String(lstItemBought,3);

            debugMessage( llKey2Name(keyBuyerUUID) + " has bought your item.");
            llWhisper(0,"Thank you " + llKey2Name(keyBuyerUUID) + " for purchasing the " + strItemBought +".");

            //If this is networked, request server to distribute object
            if(keyServer != NULL_KEY){

                //Send another E-mail Request hopefully, its just a missed e-mail request
                //Make Request for product card UUID
                //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                //If not, make the e-mail request within this script taking into account the 20 second
                //script delay set in by LL to prevent e-mail spam. <:P
                if(blnEmailAgents == TRUE){

                    llMessageLinked(LINK_SET,0,"EmailRequest#" + (string) keyServer + "@lsl.secondlife.com#"+ encrypt("Give Item") +"#" + encrypt((string) keyBuyerUUID + "^" + strItemBought) ,NULL_KEY);

                    //Notify the certain e-mail address of a sale
                    if(strEmailOnSale != ""){
                        
                        llMessageLinked(LINK_SET,0,"EmailRequest#" + strEmailOnSale + "#Item Purchsed - "+ strItemBought +"#Purchaser - " + llKey2Name(keyBuyerUUID) + "\nItem Purchased - " + strItemBought +"\nLocation - " + strVendorLocation,NULL_KEY);
                         debugMessage("Sent email notification to " + strEmailOnSale);
                        
                    }

                }
                else{

                    llEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Give Item"),encrypt((string) keyBuyerUUID + "^" + strItemBought));
                    //Notify the certain e-mail address of a sale
                    if(strEmailOnSale != ""){
                        
                        llEmail( strEmailOnSale, "Item Purchsed - "+ strItemBought,"Purchaser - " + llKey2Name(keyBuyerUUID) + "\nItem Purchased - " + strItemBought +"\nLocation - " + strVendorLocation);
                        debugMessage("Sent email notification to " + strEmailOnSale);
                        
                    }

                }

            }
            //Otherwise, give the person the object in its own inventory
            else{

                llGiveInventory(keyBuyerUUID, strItemBought);

            }

        }
        //"infoRequested#requesterUUID"
        else if(strFunction == "infoRequested"){

            intInfoCount++;
            key keyRequesterUUID = (key)llList2String(lstMessage,1);
            debugMessage( llKey2Name(keyRequesterUUID) + " wants to know more about your business.");


            //If this is networked, request server to distribute notecard
            if(keyServer != NULL_KEY){

                //Send another E-mail Request hopefully, its just a missed e-mail request
                //Make Request for product card UUID
                //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                //If not, make the e-mail request within this script taking into account the 20 second
                //script delay set in by LL to prevent e-mail spam. <:P
                if(blnEmailAgents == TRUE){

                    llMessageLinked(LINK_SET,0,"EmailRequest#" + (string) keyServer + "@lsl.secondlife.com#"+ encrypt("Give Note") +"#" + encrypt((string) keyRequesterUUID + "^" + strInfoCardName) ,NULL_KEY);

                }
                else{

                    llEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Give Note"),encrypt((string) keyRequesterUUID + "^" + strInfoCardName));

                }

            }
            //Otherwise, give the person the object in its own inventory
            else{

                llGiveInventory(keyRequesterUUID, strInfoCardName);

            }

        }
        //dbResults#QueryID#(product data)
        else if(strFunction == "dbResults"){

            processQuery(str);//check if response was needed

        }
        else{

            //Ignore the message

        }

    }

    //used to read vendor settings, calculate index lengths, and retrieve product data
    dataserver(key query_id, string data) {

        //Whenever vendor is reading the settings notecard.
        //This usually happens once during script initialization
        //Data should be an assignment per line
        //Record format should be "variable=value"
        if (query_id == keySettingsId) {
    
            if (data != EOF) { // not at the end of the notecard
    
                //split the record into variable names and values
                list lstSplit = llParseString2List(data,["="],[]);
                string strVariable = llToUpper(llStringTrim(llList2String(lstSplit,0),STRING_TRIM));
                string strValue = llStringTrim(llList2String(lstSplit,1),STRING_TRIM );

                if(strVariable == "LOADING TEXTURE"){

                    keyTexLoading = (key) strValue;

                }
                if(strVariable == "EMAIL"){

                    strEmailOnSale = strValue;

                }
                if(strVariable == "SEPARATE INFO"){

                    intSeparateInfo = (integer) strValue;
                    
                }
                if(strVariable == "INFO SUFFIX"){

                    strINFO = strValue;
                    debugMessage("INFO CARD SUFFIX:" + strINFO);

                }
                if(strVariable == "OFFLINE TEXTURE"){

                    keyTexOffline = (key) strValue;

                }
                if(strVariable == "NOTHING TEXTURE"){

                    keyTexNothing = (key) strValue;

                }
                if(strVariable == "SERVER"){

                    keyServer = (key) strValue;

                }
                if(strVariable == "PRODUCT CARD"){

                    strProductsCardName = strValue;

                }
                if(strVariable == "INFO CARD"){

                    strInfoCardName = strValue;

                }
                if(strVariable == "COMM CHANNEL"){

                    intCommChannel = (integer) strValue;

                }
                if(strVariable == "REFRESH"){

                    fltInventoryRefresh = (float) strValue;

                }
                if(strVariable == "TIMEOUT"){

                    intServerTimeout = (integer) strValue;

                }
                if(strVariable == "BUFFER"){

                    intBuffer = (integer) strValue;

                }
                if(strVariable == "EMAIL AGENTS"){

                    blnEmailAgents = (integer) strValue;

                }
                if(strVariable == "KEY"){

                    strEncryptionKey = strValue;

                }

                keySettingsId = llGetNotecardLine("FOSSL_CLIENT_SETTINGS", ++intSettingLines); // request next line
        
            }
            //Settings notecard has been read, proceed with obtaining products card.
            else{

                llOwnerSay("FOSSLVendorClient: Vendor Settings loaded.");
                llListen(intCommChannel,"",llGetOwner(),"count"); //activate listen event whenever I say count on the listening channel
                llListen(intCommChannel,"",llGetOwner(),"debug"); //activate listen event whenever I say debug on the listening channel
                llListen(intCommChannel,"",llGetOwner(),"reset"); //activate listen event whenever I say reset on the listening channel
                llListen(intCommChannel,"",llGetOwner(),"online"); //activate listen event whenever I say online on the listening channel
                llListen(intCommChannel,"",llGetOwner(),"offline"); //activate listen event whenever I say offline on the listening channel
                llListen(intCommChannel,"",llGetOwner(),"memory"); //activate listen event whenever I say memory on the listening channel

                //Is this vendor networked?
                if(keyServer != NULL_KEY){

                    llOwnerSay("FOSSLVendorClient: Vendor is networked. Contacting Server for Product List.");

                    //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                    //If not, make the e-mail request within this script taking into account the 20 second
                    //script delay set in by LL to prevent e-mail spam. <:P
                    if(blnEmailAgents == TRUE){

                        llMessageLinked(LINK_SET,0,"EmailRequest#" + (string) keyServer + "@lsl.secondlife.com#"+ encrypt("Requesting Product List") + "#" + encrypt("NULL"),NULL_KEY);

                    }
                    else{

                        llEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Requesting Product List"),encrypt("NULL"));

                    }
                    blnWaitingForServer = TRUE;
                    intEmailRequestStarted = llGetUnixTime();
                    llSetTimerEvent(1.0);

                }
                //Otherwise, if it is not networked, load the product list uuid locally
                else{

                    llOwnerSay("FOSSLVendorClient: Vendor is not networked. Obtaining Product List locally.");
                    keyProductsUUID = llGetInventoryKey(strProductsCardName);
                    llOwnerSay("FOSSLVendorClient: Determining Maximums for Categories and Subcategories. This may take a while...");
                    //start obtaining the # of categories and subcategories
                    keyProductCategories = llGetNotecardLine(keyProductsUUID,intProductLines) ;

                }

                //Update database buffer to the length specified by notecard
                llMessageLinked(LINK_SET, 0, "setBuffer#" + (string) intBuffer, NULL_KEY);

            }
        }
        //Whenever vendor is reading the products notecard to determine size of its categories and subcategories.
        else if(query_id == keyProductCategories){

            //If the products notecard needs to be read further...
            if(data != EOF){

                list lstProductParsedLine = llParseString2List(data,["#"],[]); //Parse the line into a list
    
                //Determine if current Category # is the current Maximum
                if(intProductIndexMaxCategory < (integer) llList2String(lstProductParsedLine,0)){

                    intProductIndexMaxCategory = (integer) llList2String(lstProductParsedLine,0);

                }

                //Determine if current SubCategory # is the current Maximum
                if(intProductIndexMaxSubCategory < (integer) llList2String(lstProductParsedLine,1)){

                    intProductIndexMaxSubCategory = (integer) llList2String(lstProductParsedLine,1);

                }

                //Read the next line of the products notecard
                keyProductCategories = llGetNotecardLine(keyProductsUUID,++intProductLines);

            }
            //After reading the notecard, vendor is ready to operate
            else{

                llOwnerSay("FOSSLVendorClient: Categories and SubCategories determined. Vendor is now able to load products.");

                intProductLines = 0; //clear this for later updates
                clearRequests(); //clear any requests for products if any
                llMessageLinked(LINK_SET,0,"setBuffer#" + (string) intBuffer ,NULL_KEY);//clear the current list of products in buffer, if any
                llMessageLinked(LINK_SET, 0, "setDB#" + (string) keyProductsUUID, NULL_KEY); //Tell Database where it gets its data
                goOnline();

                //Request displays to register if there are none already
                if(lstDisplays == []){

                    llMessageLinked(LINK_SET,0,"getDisplays",NULL_KEY); //request all screens to register

                }

                //Only refresh the inventory if it is networked
                if(keyServer != NULL_KEY){

                    llSetTimerEvent(fltInventoryRefresh); //Set timer to request product notecard uuid at a set interval

                }

            }

        }

    }

    timer(){

        //Depending on if the vendor is waiting from a response from the server,
        //either wait for an e-mail from the server, or make a request for an updated product list
        if(blnWaitingForServer == TRUE){
    
            if(llGetUnixTime() - intEmailRequestStarted < intServerTimeout){
    
                //llGetNextEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Update Product List"));
                llGetNextEmail("","");        
        
            }
            else{

                //take vendor offline if not done already
                goOffline();

                //Send another E-mail Request hopefully, its just a missed e-mail request
                //Make Request for product card UUID
                //If there are available scripts dedicated to offloading the delay in llEmail, do so.
                //If not, make the e-mail request within this script taking into account the 20 second
                //script delay set in by LL to prevent e-mail spam. <:P
                if(blnEmailAgents == TRUE){

                    llMessageLinked(LINK_SET,0,"EmailRequest#" + (string) keyServer + "@lsl.secondlife.com#"+ encrypt("Requesting Product List") + "#" + encrypt("NULL"),NULL_KEY);

                }
                else{

                    llEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Requesting Product List"),encrypt("NULL"));

                }

                intEmailRequestStarted = llGetUnixTime(); //After this, timer loop will look for a server response

            }

        }
        else{

            //Make Request for product card UUID
            //If there are available scripts dedicated to offloading the delay in llEmail, do so.
            //If not, make the e-mail request within this script taking into account the 20 second
            //script delay set in by LL to prevent e-mail spam. <:P
            if(blnEmailAgents == TRUE){

                llMessageLinked(LINK_SET,0,"EmailRequest#" + (string) keyServer + "@lsl.secondlife.com#"+ encrypt("Requesting Product List") + "#" + encrypt("NULL"),NULL_KEY);

            }
            else{

                llEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Requesting Product List"),encrypt("NULL"));

            }

            blnWaitingForServer = TRUE;
            intEmailRequestStarted = llGetUnixTime(); //After this, timer loop will look for a server response
            llSetTimerEvent(1.0);

        }

    }

    email(string time, string address, string subject, string body, integer remaining){

        debugMessage("Recieved E-mail from : " + address);

        if (address == (string) keyServer + "@lsl.secondlife.com" && subject == encrypt("Update Product List")){

            //don't wait for more e-mail
            blnWaitingForServer = FALSE;

            //make this the last time products were updated
            intLastProductUpdate = llGetUnixTime();

            //Remove e-mail header to generate the new uuid
            key keyNewUUID = (key) decrypt(llDeleteSubString(body, 0, llSubStringIndex(body, "\n\n") + 1));

            //New product notecard uuid is in the message
            keyProductsUUID = keyNewUUID;

            //start obtaining the # of categories and subcategories
            keyProductCategories = llGetNotecardLine(keyProductsUUID,intProductLines) ;

            //polling for further e-mails using the timer event is no longer neccesary
            llSetTimerEvent(0.0);

        }

        if(remaining > 0 ){

            //load the next e-mail in que to try and clear the e-mail buffer
            //llGetNextEmail((string) keyServer + "@lsl.secondlife.com",encrypt("Update Product List"));
            llGetNextEmail("","");

        }

    }

    listen( integer channel, string name, key id, string message ){

        if(id == llGetOwner()){

            //Count the number of times users requested information
            if(message == "count"){
                
                llOwnerSay("FOSSLVendorClient: Notecard info request at " + (string)intInfoCount + ".");
                
            }

            //Enable or disable verbose output
            else if(message == "debug"){

                blnDebug = !blnDebug;
                llOwnerSay("FOSSLVendorClient: Debug Mode set to: " + (string) blnDebug);
                llMessageLinked(LINK_SET,0,"debugMode#" + (string) blnDebug,NULL_KEY);

            }

            //Make the vendor go online
            else if(message == "online"){

                goOnline();
                debugMessage("Vendor attempting to go online");

            }

            //Make the vendor go offline
            else if(message == "offline"){

                goOffline();
                debugMessage("Vendor attempting to go offline");

            }

            //Reset the scripts
            else if(message == "reset"){

                llResetScript();

            }
            //Get the current free memory in script
            else if(message == "memory"){

                llOwnerSay("FOSSLVendorClient: Memory = " + (string) llGetFreeMemory() +"/16000 Bytes");
                llMessageLinked(LINK_SET,0,"getMemory",NULL_KEY); //If other scripts understand this, have them output free memory also

            }
            else{
                
                llOwnerSay("FOSSLVendorClient: I dunno what youre talking about.");
            
            }

        }

    }

}
