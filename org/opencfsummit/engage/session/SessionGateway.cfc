<cfcomponent 
		displayname="SessionGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="SessionGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getSessions" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var sessions = 0 />
		
		<cfquery name="sessions" datasource="#getDSN()#">
			SELECT 	s.session_id, s.event_id, s.proposal_id, s.room_id, s.session_time, 
					s.dt_created, s.dt_updated, s.created_by, s.updated_by, s.active, 
					p.status_id, p.track_id, p.title AS proposal_title, 
					ps.status, 
					t.title AS track_title, 
					r.name AS room_name 
			FROM 	session s 
			INNER JOIN proposal p 
				ON s.proposal_id = p.proposal_id 
			INNER JOIN proposal_status ps 
				ON p.status_id = ps.status_id 
			INNER JOIN track t 
				ON p.track_id = t.track_id 
			LEFT OUTER JOIN room r 
				ON s.room_id = r.room_id 
			WHERE 	s.event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY s.session_time, track_title
		</cfquery>
		
		<cfreturn sessions />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="theSession" type="Session" required="true" />
		
		<cfset var getSession = 0 />
		<cfset var dtUpdated = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		<cfset var roomID = 0 />
		
		<cfif arguments.theSession.getSessionID() neq 0>
			<cfquery name="getSession" datasource="#getDSN()#">
				SELECT 	s.session_id, s.event_id, s.proposal_id, s.room_id, s.session_time, 
						s.dt_created, s.dt_updated, s.created_by, s.updated_by, s.active, 
						r.name AS room_name 
				FROM 	session s 
				LEFT JOIN room r 
					ON s.room_id = r.room_id 
				WHERE 	session_id = <cfqueryparam value="#arguments.theSession.getSessionID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getSession.RecordCount gt 0>
				<cfif getSession.room_id neq "">
					<cfset roomID = getSession.room_id />
				</cfif>
				
				<cfif getSession.dt_updated neq "">
					<cfset dtUpdated = getSession.dt_updated />
				</cfif>
				
				<cfif getSession.updated_by neq "">
					<cfset updatedBy = getSession.updated_by />
				</cfif>
				
				<cfset arguments.theSession.init(getSession.session_id, getSession.event_id, getSession.proposal_id, null, 
													roomID, getSession.room_name, getSession.session_time, getSession.dt_created, 
													dtUpdated, getSession.created_by, updatedBy, getSession.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="theSession" type="Session" required="true" />
		
		<cfset var saveSession = 0 />
		
		<cfif arguments.theSession.getSessionID() eq 0>
			<cfquery name="saveSession" datasource="#getDSN()#">
				INSERT INTO session (
					event_id, proposal_id, room_id, session_time, dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.theSession.getEventID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.theSession.getProposalID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.theSession.getRoomID()#" cfsqltype="cf_sql_integer" 
									null="#Not arguments.theSession.getRoomID()#" />, 
					<cfqueryparam value="#arguments.theSession.getSessionTime()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.theSession.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.theSession.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveSession" datasource="#getDSN()#">
				UPDATE 	session 
				SET 	event_id = <cfqueryparam value="#arguments.theSession.getEventID()#" cfsqltype="cf_sql_integer" />, 
						proposal_id = <cfqueryparam value="#arguments.theSession.getProposalID()#" cfsqltype="cf_sql_integer" />, 
						room_id = <cfqueryparam value="#arguments.theSession.getRoomID()#" cfsqltype="cf_sql_integer" 
												null="#Not arguments.theSession.getRoomID()#" />, 
						session_time = <cfqueryparam value="#arguments.theSession.getSessionTime()#" cfsqltype="cf_sql_timestamp" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.theSession.getUpdatedBy()#" cfsqltype="cf_sql_integer" />, 
						active = <cfqueryparam value="#arguments.theSession.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	session_id = <cfqueryparam value="#arguments.theSession.getSessionID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="theSession" type="Session" required="true" />
		
		<cfset var deleteSession = 0 />
		
		<cfquery name="deleteSession" datasource="#getDSN()#">
			DELETE FROM session 
			WHERE session_id = <cfqueryparam value="#arguments.theSession.getSessionID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>

</cfcomponent>