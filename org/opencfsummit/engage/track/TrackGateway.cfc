<cfcomponent 
		displayname="TrackGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="TrackGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getTracks" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var tracks = 0 />
		
		<cfquery name="tracks" datasource="#getDSN()#">
			SELECT 	track_id, event_id, title, excerpt, description, color, 
					dt_created, dt_updated, created_by, updated_by, active 
			FROM 	track 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY title ASC
		</cfquery>
		
		<cfreturn tracks />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="track" type="Track" required="true" />
		
		<cfset var getTrack = 0 />
		<cfset var dtUpdated = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		
		<cfif arguments.track.getTrackID() neq 0>
			<cfquery name="getTrack" datasource="#getDSN()#">
				SELECT 	track_id, event_id, title, excerpt, description, color, 
						dt_created, dt_updated, created_by, updated_by, active
				FROM 	track 
				WHERE 	track_id = <cfqueryparam value="#arguments.track.getTrackID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getTrack.RecordCount gt 0>
				<cfif getTrack.dt_updated neq "">
					<cfset dtUpdated = getTrack.dt_updated />
				</cfif>
				
				<cfif getTrack.updated_by neq "">
					<cfset updatedBy = getTrack.updated_by />
				</cfif>
				
				<cfset arguments.track.init(getTrack.track_id, getTrack.event_id, getTrack.title, 
											getTrack.excerpt, getTrack.description, getTrack.color, 
											getTrack.dt_created, dtUpdated, getTrack.created_by, 
											updatedBy, getTrack.active ) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="track" type="Track" required="true" />
		
		<cfset var saveTrack = 0 />
		
		<cfif arguments.track.getTrackID() eq 0>
			<cfquery name="saveTrack" datasource="#getDSN()#">
				INSERT INTO track (
					event_id, title, excerpt, description, color, 
					dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.track.getEventID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.track.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.track.getExcerpt()#" cfsqltype="cf_sql_varchar" maxlength="1000" />, 
					<cfqueryparam value="#arguments.track.getDescription()#" cfsqltype="cf_sql_longvarchar" />, 
					<cfqueryparam value="#arguments.track.getColor()#" cfsqltype="cf_sql_char" maxlength="7" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.track.getCreatedBy()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.track.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveTrack" datasource="#getDSN()#">
				UPDATE 	track 
				SET 	event_id = <cfqueryparam value="#arguments.track.getEventID()#" cfsqltype="cf_sql_integer" />, 
						title = <cfqueryparam value="#arguments.track.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						excerpt = <cfqueryparam value="#arguments.track.getExcerpt()#" cfsqltype="cf_sql_varchar" maxlength="1000" />, 
						description = <cfqueryparam value="#arguments.track.getDescription()#" cfsqltype="cf_sql_longvarchar" />, 
						color = <cfqueryparam value="#arguments.track.getColor()#" cfsqltype="cf_sql_char" maxlength="7" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.track.getUpdatedBy()#" cfsqltype="cf_sql_tinyint" />, 
						active = <cfqueryparam value="#arguments.track.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	track_id = <cfqueryparam value="#arguments.track.getTrackID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="track" type="Track" required="true" />
		
		<cfset var deleteTrack = 0 />
		
		<cfquery name="deleteTrack" datasource="#getDSN()#">
			DELETE FROM track 
			WHERE track_id = <cfqueryparam value="#arguments.track.getTrackID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>

</cfcomponent>