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

default
{

    touch_start(integer total_number)
    {
        
        //If an avatar touches this object, tell the main script that (insert avatar's name here) touched it.
        if (llDetectedType(0) & AGENT){
            llMessageLinked(LINK_ROOT,0,"infoRequested#" + llDetectedName(0),NULL_KEY);
        }
    
    }
}