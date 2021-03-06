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

list lstProducts;                   //List of products loaded into memory. Product records are as follows...
                                    //current#Category#Subcategory#Price#Name#TextureUUID

list lstItemRequestList;            //List of items to be requested from the server
//each record is in the form of "Category#SubCategory#DatabaseKey#LineRead"

integer intItemRequestList = 0;        //Number of item database requests to send to the server

integer intMaxProducts = 0;            //Maximum Number of products that can be loaded

integer intProductListCounter = -2147483646;    //Keeps track of a counter used for indicating the most and needed products in category

key keyProductsUUID = NULL_KEY;                 //The uuid of the notecard to be read for products

integer blnDebug = FALSE;                        //Determines if script will output debugging messages

//=================================================================//
//Define the following functions
//=================================================================//

//This displays messages to the owner if debug mode has been set to true
debugMessage(string strMessage){

    if(blnDebug == TRUE){

        llOwnerSay("FOSSLProductDatabase:   " + strMessage);
        
    }
    
}

//Find the product array index based upon the Category and Sub category Index
//If Not found, returns -1
integer findIndexByCategory(integer intCategory, integer intSubCategory){

    integer intProductListIndex = -1;
    integer intTotalLength = llGetListLength(lstProducts);
    integer blnFound = FALSE;
    string strSearchCondition = ((string)intCategory + "#" +(string)intSubCategory);
    
    list lstProduct = [];

    do{

        intProductListIndex++;
        lstProduct = llParseString2List(llList2String(lstProducts,intProductListIndex),["#"],[]);

        //current#Category#Subcategory#Price#Name#TextureUUID
        if(strSearchCondition == (llList2String(lstProduct,1) + "#" + llList2String(lstProduct,2))){

            blnFound = TRUE;

        }


    } while(blnFound == FALSE && intProductListIndex < intTotalLength);

    if(blnFound == TRUE){

        return intProductListIndex;

    }
    else{

        return -1;

    }

}

//when product list counter has reached maximum, use this to start back from square 1
resetCounter(){

    debugMessage("Query counter Maxed out. Resetting query.");
    
    integer intItemsIndex = -1;
    integer intItemsLength = llGetListLength(lstProducts);
    integer intMinimum = 0;
    integer intMaximum = 0;
    integer intDifference = 0;
    list lstOpenedIndex = [];

    lstProducts = llListSort(lstProducts,1,TRUE);

    intMinimum = (integer) llList2String(llParseString2List(llList2String(lstProducts,0),["#"],[]),0);
        
    do{

        ++intItemsIndex;
        lstOpenedIndex = llParseString2List(llList2String(lstProducts,intItemsIndex),["#"],[]);
        intMaximum = (integer) llList2String(lstOpenedIndex,0);
        intDifference = intMaximum - intMinimum;
        lstOpenedIndex = llListReplaceList( lstOpenedIndex,[(string) (-2147483646 + intDifference)], 0,0);
        lstProducts = llListReplaceList(lstProducts,[llDumpList2String(lstOpenedIndex,"#")], intItemsIndex,intItemsIndex);
        
    }while(intItemsIndex < intItemsLength);
    
    
    intProductListCounter = -2147483645 + intDifference; // set the counter to one greater than recent
    
}

//This function adds an item to the buffer
//If the buffer is full, replace the first item not being used by a display
//If the item is to be used by a display, update the displays.
addItem(string strItem){

    debugMessage("Appending Item to Database");
    
    //If the counter is more equal to the maximum integer,
    //reset the database index for most and least used database queries
    if(intProductListCounter == 2147483646){

        resetCounter();

    }

    //If the number of products are less than that of the maximum, add it to the buffer
    if((llGetListLength(lstProducts) - 1) < intMaxProducts){

        debugMessage("Buffer not Full. Appending.");
    
        //Use a space hack trick for conserving memory
        //Expand lstProducts with an extra element
        lstProducts += [ ((string) (++intProductListCounter)) + "#" + strItem];

    }
    //Otherwise, replace the first index that is least recent
    else{

        debugMessage("Buffer Full. Replacing least accessed index.");
    
        //Sort lstProducts starting from least recent data to most recent data
        lstProducts = llListSort(lstProducts,1,TRUE);
        //Overwrite first, least used index with current product
        lstProducts = llListReplaceList(lstProducts,[((string) (++intProductListCounter)) + "#" + strItem],0,0);

    }

}

//This function adds item requests to the buffer before it starts obtaining them from the notecard
itemRequest(integer intCategory, integer intSubCategory, string strReturnRequest){

    //Use memory conservative techniques to reduce memory footprint
    //take that record and add it to the waitlist
    //categoryRequest#subcategoryRequest#ReturnQuery#notecardKey#notecardLine
    debugMessage("Reqesting data from notecard...");
    lstItemRequestList = llListReplaceList((lstItemRequestList = []) + lstItemRequestList,[(string)intCategory + "#" + (string)intSubCategory + "#" + strReturnRequest + "#" + (string) llGetNotecardLine(keyProductsUUID,0) + "#0" ],intItemRequestList,intItemRequestList);

    //increment # of items on the waitlist
    intItemRequestList++;

}

//This function removes item requests by their index
removeItemRequest(integer intIndex){

    //Use memory conservative techniques to reduce memory footprint
    //remove the item by index
    lstItemRequestList = llDeleteSubList((lstItemRequestList = []) + lstItemRequestList,intIndex,intIndex);
    
    //decrement # of items on the waitlist
    intItemRequestList--;
    
    
}

//Use this function to make database requests off temporary memory first
//If an index can't be found, make a request off of notecard memory
dbQuery(integer intCategory, integer intSubCategory, string strReturnRequest){

    integer intFoundIndex = findIndexByCategory(intCategory,intSubCategory);
    list lstFoundProduct = [];

    //Index found... return the result and update the access couter on that item
    if(intFoundIndex != -1){

        //If the counter is more equal to the maximum integer,
        //reset the database index for most and least used database queries
        if(intProductListCounter == 2147483646){

            resetCounter();

        }

        //Split the found product into its elements for individual element manipulation
        lstFoundProduct = llParseString2List(llList2String(lstProducts,intFoundIndex),["#"],[]);

        //Advance the database access counter indicating this is the latest item in the database
        lstFoundProduct = llListReplaceList(lstFoundProduct,[(string)(++intProductListCounter)],0,0);

        debugMessage("Found Request in Buffer... returning values");
        
        //return query to owner
        //dbResults#ReturnQuery#(productRecord)
        llMessageLinked(LINK_SET,0,"dbResults#" + strReturnRequest + "#" + llDumpList2String(llList2List(lstFoundProduct,1,-1),"#"),NULL_KEY);
        
    }
    //Index not found... time to make a notecard request
    else{

        debugMessage("Requested Query not found in Buffer. Retrieving data from source...");
        itemRequest(intCategory,intSubCategory,strReturnRequest);
        
    }
    
}

//=================================================================//
//Customize the above functions
//=================================================================//


default
{

    //Activate this event when container script is rezzed
    //Its best to just reset the database and start with fresh data
    on_rez(integer start_param)
    {

        //Reset this script upon rezzing the containing prim
        llResetScript();
        
    }

    //Activate this event when a companion script sends out a linked message
    //Use this event to determine if that script is making a request of this script
    //This script accepts database query requests, database resizing requests,
    //database source requests, and database clearing
    link_message(integer sender_number, integer number, string message, key id)
    {

        //Separate the linked message into the function and variables
        list lstMessage = llParseString2List(message,["#"],[]);
        string strFunction = llList2String(lstMessage,0);

        //A scripted object wants to obtain information about a product
        //dbRequest#requestKey#Category#SubCategory
        if(strFunction == "dbRequest"){

            debugMessage("dbRequest = " + llList2String(lstMessage,1) );
            dbQuery((integer) llList2String(lstMessage,2), (integer) llList2String(lstMessage,3), llList2String(lstMessage,1));
            
        }
        //clearDatabase
        else if(strFunction == "clearDatabase"){

            lstProducts = [];
            
        }
        //setBuffer#bufferLength
        else if(strFunction == "setBuffer"){

            //Clear database
            lstProducts = [];

            //Reset database counter
            intProductListCounter = -2147483646;

            //Set the maximum # of products in inventory
            intMaxProducts = (integer) llList2String(lstMessage,1);
            
        }
        //addBuffer#bufferLength
        else if(strFunction == "addBuffer"){

            //Set the maximum # of products in inventory
            intMaxProducts += 1;
            
        }
        //setDB#productNotecardUUID
        else if(strFunction == "setDB"){

            //Clear out any requests and database inventory
            lstProducts = [];
            intItemRequestList = 0;
            lstItemRequestList = [];

            //reset inventory counter
            intProductListCounter = -2147483646;

            //Assign Key of products notecard to this uuid
            keyProductsUUID = (key) llList2String(lstMessage,1);
            
        }
        //debugMode#blnEnabled
        else if(strFunction == "debugMode"){

            blnDebug = (integer) llList2String(lstMessage,1);
            
        }
        //getMemory
        else if(strFunction == "getMemory"){
         
            llOwnerSay("FOSSLVendorProductDatabase:   Memory = " + (string) llGetFreeMemory() +"/16000 Bytes");
                  
        }
                
    }

    //Activate this event when a query couldn't find the solution in a list (fast)
    //each request has a notecard line# and key to keep track of where they are
    //If request can't find the index in the card, return that the inventory wasn't found
    dataserver(key requested, string data)
    {

       list lstCurrentRequestedItem;
       integer intWaitListIndex = 0;
       integer blnKeyFound = FALSE;

       //loop through the product request list to determine if this data server event matches the product request
       for(;(intWaitListIndex < intItemRequestList) && (blnKeyFound == FALSE); intWaitListIndex++){

            //Extract the query into its elements
           lstCurrentRequestedItem = llParseString2List(llList2String(lstItemRequestList,intWaitListIndex),["#"],[]);

           //Attempt to match the current notecard request key with that of the events
           if(requested == (key)llList2String(lstCurrentRequestedItem,3)){

               //If this is not the end of the product list...
               if(data != EOF){

                   //Extract the product line into its elements
                   list lstProductParsedLine = llParseString2List(data,["#"],[]);

                   //Does this product line match with the request?
                   if( ((integer)llList2String(lstProductParsedLine,0) == (integer)llList2String(lstCurrentRequestedItem,0)) && ((integer)llList2String(lstProductParsedLine,1) == (integer)llList2String(lstCurrentRequestedItem,1)) ){

                        //return query to owner
                        //dbResults#ReturnQuery#(productRecord)
                        llMessageLinked(LINK_SET,0,"dbResults#" + llList2String(lstCurrentRequestedItem,2) + "#" + data,NULL_KEY);
                
                       //Add the product line to product buffer
                       addItem(data);
                            
                       //Remove the request from the list
                       removeItemRequest(intWaitListIndex);
                            
                   }
                   else{

                        //start requesting for the next line of the notecard
                        //categoryRequest#subcategoryRequest#ReturnQuery#notecardKey#notecardLine
                       lstItemRequestList = llListReplaceList(lstItemRequestList,[llList2String(lstCurrentRequestedItem,0) + "#" + llList2String(lstCurrentRequestedItem,1) + "#" + llList2String(lstCurrentRequestedItem,2) + "#" + (string) llGetNotecardLine(keyProductsUUID,(((integer) llList2String(lstCurrentRequestedItem,4)) + 1)) + "#" + (string)(((integer) llList2String(lstCurrentRequestedItem,4)) + 1) ],intWaitListIndex,intWaitListIndex);
                            
                   }
                        
               }
               //If this is the end of the product list and still the item category and subcategory isn't found,
               //chances are, there's no product
               else{

                   //return query to owner
                   //dbResults#ReturnQuery#(productRecord)
                   llMessageLinked(LINK_SET,0,"dbResults#" + llList2String(lstCurrentRequestedItem,2) + "#" + llList2String(lstCurrentRequestedItem,0) + "#" + llList2String(lstCurrentRequestedItem,1) + "#-1#NO_ITEM_AVAILABLE#NO_IMAGE_AVAILABLE",NULL_KEY);
            
                   //Add a NULL product to product buffer
                   addItem(llList2String(lstCurrentRequestedItem,0) + "#" + llList2String(lstCurrentRequestedItem,1) + "#-1#NO_ITEM_AVAILABLE#NO_IMAGE_AVAILABLE");

                   //Remove the request from the list
                   removeItemRequest(intWaitListIndex);
                   
               }

               blnKeyFound = TRUE;
                    
           }
                
       }
                    
    }
    
}