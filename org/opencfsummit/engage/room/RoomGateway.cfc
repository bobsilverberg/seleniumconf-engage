<cfcomponent 
		displayname="RoomGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="RoomGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getRooms" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var rooms = 0 />
		
		<cfquery name="rooms" datasource="#getDSN()#">
			SELECT 	room_id, event_id, name, capacity, size, seating_configuration, description, 
					image, dt_created, dt_updated, updated_by, active 
			FROM 	room 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY name ASC
		</cfquery>
		
		<cfreturn rooms />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="room" type="Room" required="true" />
		
		<cfset var getRoom = 0 />
		<cfset var dtUpdated = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		
		<cfif arguments.room.getRoomID() neq 0>
			<cfquery name="getRoom" datasource="#getDSN()#">
				SELECT 	room_id, event_id, name, capacity, size, seating_configuration, description, 
						image, dt_created, dt_updated, created_by, updated_by, active 
				FROM 	room 
				WHERE 	room_id = <cfqueryparam value="#arguments.room.getRoomID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getRoom.RecordCount gt 0>
				<cfif getRoom.dt_updated neq "">
					<cfset dtUpdated = getRoom.dt_updated />
				</cfif>
				
				<cfif getRoom.updated_by neq "">
					<cfset updatedBy = getRoom.updated_by />
				</cfif>
				
				<cfset arguments.room.init(getRoom.room_id, getRoom.event_id, getRoom.name, getRoom.capacity, 
											getRoom.size, getRoom.seating_configuration, getRoom.description, 
											getRoom.image, getRoom.dt_created, dtUpdated, getRoom.created_by, 
											updatedBy, getRoom.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="room" type="Room" required="true" />
		
		<cfset var saveRoom = 0 />
		
		<cfif arguments.room.getRoomID() eq 0>
			<cfquery name="saveRoom" datasource="#getDSN()#">
				INSERT INTO room (
					event_id, name, capacity, size, seating_configuration, description, 
					image, dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.room.getEventID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.room.getName()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.room.getCapacity()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.room.getSize()#" cfsqltype="cf_sql_varchar" maxlength="255" 
									null="#not Len(trim(arguments.room.getSize()))#" />, 
					<cfqueryparam value="#arguments.room.getSeatingConfiguration()#" cfsqltype="cf_sql_varchar" maxlength="255" 
									null="#not Len(trim(arguments.room.getSeatingConfiguration()))#" />, 
					<cfqueryparam value="#arguments.room.getDescription()#" cfsqltype="cf_sql_varchar" maxlength="1000" 
									null="#not Len(trim(arguments.room.getDescription()))#" />, 
					<cfqueryparam value="#arguments.room.getImage()#" cfsqltype="cf_sql_varchar" maxlength="500" 
									null="#not Len(trim(arguments.room.getImage()))#" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.room.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.room.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveRoom" datasource="#getDSN()#">
				UPDATE 	room 
				SET 	event_id = <cfqueryparam value="#arguments.room.getEventID()#" cfsqltype="cf_sql_integer" />,
						name = <cfqueryparam value="#arguments.room.getName()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						capacity = <cfqueryparam value="#arguments.room.getCapacity()#" cfsqltype="cf_sql_integer" />, 
						size = <cfqueryparam value="#arguments.room.getSize()#" cfsqltype="cf_sql_varchar" maxlength="255" 
									null="#not Len(trim(arguments.room.getSize()))#" />, 
						seating_configuration = <cfqueryparam value="#arguments.room.getSeatingConfiguration()#" cfsqltype="cf_sql_varchar" 
														maxlength="255" null="#not Len(trim(arguments.room.getSeatingConfiguration()))#" />, 
						description = <cfqueryparam value="#arguments.room.getDescription()#" cfsqltype="cf_sql_varchar" maxlength="1000" 
													null="#not Len(trim(arguments.room.getDescription()))#" />, 
						image = <cfqueryparam value="#arguments.room.getImage()#" cfsqltype="cf_sql_varchar" maxlength="500" 
												null="#not Len(trim(arguments.room.getImage()))#" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.room.getUpdatedBy()#" cfsqltype="cf_sql_integer" />, 
						active = <cfqueryparam value="#arguments.room.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	room_id = <cfqueryparam value="#arguments.room.getRoomID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="room" type="Room" required="true" />
		
		<cfset var deleteRoom = 0 />
		
		<cfquery name="deleteRoom" datasource="#getDSN()#">
			DELETE FROM room 
			WHERE room_id = <cfqueryparam value="#arguments.room.getRoomID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>

</cfcomponent>