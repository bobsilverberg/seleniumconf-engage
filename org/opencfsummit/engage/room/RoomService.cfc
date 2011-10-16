<cfcomponent 
		displayname="RoomService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="RoomService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setRoomGateway" access="public" output="false" returntype="void">
		<cfargument name="roomGateway" type="RoomGateway" required="true" />
		<cfset variables.roomGateway = arguments.roomGateway />
	</cffunction>
	<cffunction name="getRoomGateway" access="public" output="false" returntype="RoomGateway">
		<cfreturn variables.roomGateway />
	</cffunction>
	
	<cffunction name="getRoomBean" access="public" output="false" returntype="Room">
		<cfreturn CreateObject("component", "Room").init() />
	</cffunction>
	
	<cffunction name="getRooms" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getRoomGateway().getRooms(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getRoom" access="public" output="false" returntype="Room">
		<cfargument name="roomID" type="numeric" required="false" default="0" />
		
		<cfset var room = getRoomBean() />
		
		<cfset room.setRoomID(arguments.roomID) />
		<cfset getRoomGateway().fetch(room) />
		
		<cfreturn room />
	</cffunction>
	
	<cffunction name="saveRoom" access="public" output="false" returntype="void">
		<cfargument name="room" type="Room" required="true" />
		
		<cfset getRoomGateway().save(room) />
	</cffunction>
	
	<cffunction name="deleteRoom" access="public" output="false" returntype="void">
		<cfargument name="room" type="Room" required="true" />
		
		<cfset getRoomGateway().delete(room) />
	</cffunction>

</cfcomponent>