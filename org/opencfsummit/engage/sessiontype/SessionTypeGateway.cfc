<cfcomponent 
		displayname="SessionTypeGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="SessionTypeGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getSessionTypes" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var sessionTypes = 0 />
		
		<cfquery name="sessionTypes" datasource="#getDSN()#">
			SELECT 	session_type_id, event_id, title, description, duration, 
					dt_created, dt_updated, created_by, updated_by, active 
			FROM 	session_type 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY title ASC
		</cfquery>
		
		<cfreturn sessionTypes />
	</cffunction>
	
	<cffunction name="getSessionTypeByTitle" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="title" type="string" required="true" />
		
		<cfset var sessionType = 0 />
		
		<cfquery name="sessionType" datasource="#getDSN()#">
			SELECT 	session_type_id, event_id, title, description, duration, 
					dt_created, dt_updated, created_by, updated_by, active 
			FROM 	session_type 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" />
			AND 	title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>
		
		<cfreturn sessionType />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="sessionType" type="SessionType" required="true" />
		
		<cfset var getSessionType = 0 />
		<cfset var dtUpdated = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		
		<cfif arguments.sessionType.getSessionTypeID() neq 0>
			<cfquery name="getSessionType" datasource="#getDSN()#">
				SELECT 	session_type_id, event_id, title, description, duration, 
						dt_created, dt_updated, created_by, updated_by, active 
				FROM 	session_type 
				WHERE 	session_type_id = <cfqueryparam value="#arguments.sessionType.getSessionTypeID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getSessionType.RecordCount gt 0>
				<cfif getSessionType.dt_updated neq "">
					<cfset dtUpdated = getSessionType.dt_updated />
				</cfif>
				
				<cfif getSessionType.updated_by neq "">
					<cfset updatedBy = getSessionType.updated_by />
				</cfif>
				
				<cfset arguments.sessionType.init(getSessionType.session_type_id, getSessionType.event_id, getSessionType.title, 
												getSessionType.description, getSessionType.duration, 
												getSessionType.dt_created, dtUpdated, getSessionType.created_by, 
												updatedBy, getSessionType.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="sessionType" type="SessionType" required="true" />
		
		<cfset var saveSessionType = 0 />
		
		<cfif arguments.sessionType.getSessionTypeID() eq 0>
			<cfquery name="saveSessionType" datasource="#getDSN()#">
				INSERT INTO session_type (
					event_id, title, description, duration, 
					dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.sessionType.getEventID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.sessionType.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.sessionType.getDescription()#" cfsqltype="cf_sql_longvarchar" />, 
					<cfqueryparam value="#arguments.sessionType.getDuration()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.sessionType.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.sessionType.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveSessionType" datasource="#getDSN()#">
				UPDATE 	session_type 
				SET 	event_id = <cfqueryparam value="#arguments.sessionType.getEventID()#" cfsqltype="cf_sql_integer" />,
						title = <cfqueryparam value="#arguments.sessionType.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						description = <cfqueryparam value="#arguments.sessionType.getDescription()#" cfsqltype="cf_sql_longvarchar" />, 
						duration = <cfqueryparam value="#arguments.sessionType.getDuration()#" cfsqltype="cf_sql_integer" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.sessionType.getUpdatedBy()#" cfsqltype="cf_sql_integer" />, 
						active = <cfqueryparam value="#arguments.sessionType.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	session_type_id = <cfqueryparam value="#arguments.sessionType.getSessionTypeID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="sessionType" type="SessionType" required="true" />
		
		<cfset var deleteSessionType = 0 />
		
		<cfquery name="deleteSessionType" datasource="#getDSN()#">
			DELETE FROM session_type 
			WHERE session_type_id = <cfqueryparam value="#arguments.sessionType.getSessionTypeID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>

</cfcomponent>