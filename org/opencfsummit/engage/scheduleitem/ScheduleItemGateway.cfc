<cfcomponent 
		displayname="ScheduleItemGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="ScheduleItemGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getScheduleItems" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var scheduleItems = 0 />
		
		<cfquery name="scheduleItems" datasource="#getDSN()#">
			SELECT 	schedule_item_id, event_id, room_id, title, excerpt, description, 
					start_time, duration, dt_created, dt_updated, created_by, updated_by, active 
			FROM 	schedule_item 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY start_time ASC
		</cfquery>
		
		<cfreturn scheduleItems />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="scheduleItem" type="ScheduleItem" required="true" />
		
		<cfset var getScheduleItem = 0 />
		<cfset var roomID = 0 />
		<cfset var dtUpdated = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		<cfset var startTime = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var duration = 0 />
		
		<cfif arguments.scheduleItem.getScheduleItemID() neq 0>
			<cfquery name="getScheduleItem" datasource="#getDSN()#">
				SELECT 	schedule_item_id, event_id, room_id, title, excerpt, description, 
						start_time, duration, dt_created, dt_updated, created_by, updated_by, active 
				FROM 	schedule_item 
				WHERE 	schedule_item_id = <cfqueryparam value="#arguments.scheduleItem.getScheduleItemID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getScheduleItem.RecordCount gt 0>
				<cfif getScheduleItem.room_id neq "">
					<cfset roomID = getScheduleItem.room_id />
				</cfif>
				
				<cfif getScheduleItem.dt_updated neq "">
					<cfset dtUpdated = getScheduleItem.dt_updated />
				</cfif>
				
				<cfif getScheduleItem.updated_by neq "">
					<cfset updatedBy = getScheduleItem.updated_by />
				</cfif>
				
				<cfif getScheduleItem.start_time neq "">
					<cfset startTime = getScheduleItem.start_time />
				</cfif>
				
				<cfif getScheduleItem.duration neq "">
					<cfset duration = getScheduleItem.duration />
				</cfif>
				
				<cfset arguments.scheduleItem.init(getScheduleItem.schedule_item_id, getScheduleItem.event_id, roomID, 
													getScheduleItem.title, getScheduleItem.excerpt, getScheduleItem.description, 
													startTime, duration, getScheduleItem.dt_created, dtUpdated, 
													getScheduleItem.created_by, updatedBy, getScheduleItem.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="scheduleItem" type="ScheduleItem" required="true" />
		
		<cfset var saveScheduleItem = 0 />
		<cfset var startTimeNull = false />
		
		<cfif arguments.scheduleItem.getStartTime() eq CreateDateTime(1900,1,1,0,0,0)>
			<cfset startTimeNull = true />
		</cfif>
		
		<cfif arguments.scheduleItem.getScheduleItemID() eq 0>
			<cfquery name="saveScheduleItem" datasource="#getDSN()#">
				INSERT INTO schedule_item (
					event_id, room_id, title, excerpt, description, 
					start_time, duration, dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.scheduleItem.getEventID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.scheduleItem.getRoomID()#" cfsqltype="cf_sql_integer" 
									null="#not arguments.scheduleItem.getRoomID()#" />, 
					<cfqueryparam value="#arguments.scheduleItem.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.scheduleItem.getExcerpt()#" cfsqltype="cf_sql_varchar" maxlength="1000" 
									null="#not Len(trim(arguments.scheduleItem.getExcerpt()))#" />, 
					<cfqueryparam value="#arguments.scheduleItem.getDescription()#" cfsqltype="cf_sql_longvarchar" 
									null="#not len(trim(arguments.scheduleItem.getDescription()))#" />, 
					<cfqueryparam value="#arguments.scheduleItem.getStartTime()#" cfsqltype="cf_sql_timestamp" 
									null="#startTimeNull#" />, 
					<cfqueryparam value="#arguments.scheduleItem.getDuration()#" cfsqltype="cf_sql_smallint" 
									null="#not arguments.scheduleItem.getDuration()#" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.scheduleItem.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.scheduleItem.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveScheduleItem" datasource="#getDSN()#">
				UPDATE 	schedule_item 
				SET 	event_id = <cfqueryparam value="#arguments.scheduleItem.getEventID()#" cfsqltype="cf_sql_integer" />, 
						room_id = <cfqueryparam value="#arguments.scheduleItem.getRoomID()#" cfsqltype="cf_sql_integer" 
									null="#not arguments.scheduleItem.getRoomID()#" />, 
						title = <cfqueryparam value="#arguments.scheduleItem.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						excerpt = <cfqueryparam value="#arguments.scheduleItem.getExcerpt()#" cfsqltype="cf_sql_varchar" maxlength="1000" 
									null="#not Len(trim(arguments.scheduleItem.getExcerpt()))#" />, 
						description = <cfqueryparam value="#arguments.scheduleItem.getDescription()#" cfsqltype="cf_sql_longvarchar" 
											null="#not len(trim(arguments.scheduleItem.getDescription()))#" />, 
						start_time = <cfqueryparam value="#arguments.scheduleItem.getStartTime()#" cfsqltype="cf_sql_timestamp" 
													null="#startTimeNull#" />,
						duration = <cfqueryparam value="#arguments.scheduleItem.getDuration()#" cfsqltype="cf_sql_smallint" 
												null="#not arguments.scheduleItem.getDuration()#" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.scheduleItem.getUpdatedBy()#" cfsqltype="cf_sql_integer" />, 
						active = <cfqueryparam value="#arguments.scheduleItem.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	schedule_item_id = <cfqueryparam value="#arguments.scheduleItem.getScheduleItemID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="scheduleItem" type="ScheduleItem" required="true" />
		
		<cfset var deleteScheduleItem = 0 />
		
		<cfquery name="deleteScheduleItem" datasource="#getDSN()#">
			DELETE FROM schedule_item 
			WHERE schedule_item_id = <cfqueryparam value="#arguments.scheduleItem.getScheduleItemID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>

</cfcomponent>