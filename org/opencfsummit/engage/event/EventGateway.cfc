<cfcomponent 
		displayname="EventGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="EventGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getEvents" access="public" output="false" returntype="query">
		<cfset var events = 0 />
		
		<cfquery name="events" datasource="#getDSN()#">
			SELECT 	event_id, parent_id, slug, title, start_date, end_date, proposal_deadline, 
					allow_proposal_title_edits, publish_proposal_statuses, 
					publish_schedule, accept_proposal_comments_after_deadline, 
					open_text, closed_text, session_text, tracks_text, 
					dt_created, dt_updated, created_by, updated_by, active 
			FROM 	event 
			ORDER BY title ASC
		</cfquery>
		
		<cfreturn events />
	</cffunction>
	
	<cffunction name="getChildEvents" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var events = 0 />
		
		<cfquery name="events" datasource="#getDSN()#">
			SELECT 	event_id, title 
			FROM 	event 
			WHERE 	parent_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" /> 
			ORDER BY title ASC
		</cfquery>
		
		<cfreturn events />
	</cffunction>
	
	<cffunction name="getTracksText" access="public" output="false" returntype="string">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var getTracksText = 0 />
		
		<cfquery name="getTracksText" datasource="#getDSN()#">
			SELECT 	tracks_text 
			FROM 	event 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn getTracksText.tracks_text />
	</cffunction>
	
	<cffunction name="getParentID" access="public" output="false" returntype="numeric">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var getParentID = 0 />
		<cfset var parentID = 0 />
		
		<cfquery name="getParentID" datasource="#getDSN()#">
			SELECT 	parent_id 
			FROM 	event 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif getParentID.parent_id neq "">
			<cfset parentID = getParentID.parent_id />
		</cfif>
		
		<cfreturn parentID />
	</cffunction>
	
	<cffunction name="getLatestEventID" access="public" output="false" returntype="numeric">
		<cfset var getID = 0 />
		<cfset var eventID = 0 />
		
		<cfquery name="getID" datasource="#getDSN()#">
			SELECT MAX(event_id) AS event_id
			FROM event
		</cfquery>
		
		<cfif getID.RecordCount gt 0>
			<cfset eventID = getID.event_id />
		</cfif>
		
		<cfreturn eventID />
	</cffunction>
	
	<cffunction name="getEventName" access="public" output="false" returntype="string">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfset var getName = 0 />
		
		<cfquery name="getName" datasource="#getDSN()#">
			SELECT 	title 
			FROM 	event 
			WHERE 	event_id = <cfqueryparam value="#arguments.eventID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn getName.title />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="theEvent" type="Event" required="true" />
		
		<cfset var getEvent = 0 />
		<cfset var parentID = 0 />
		<cfset var proposalDeadline = CreateDateTime(1900,1,1,0,0,0) />
		<cfset var updatedBy = 0 />
		
		<cfif arguments.theEvent.getEventID() neq 0>
			<cfquery name="getEvent" datasource="#getDSN()#">
				SELECT 	event_id, parent_id, slug, title, start_date, end_date, proposal_deadline, 
						allow_proposal_title_edits, publish_proposal_statuses, 
						publish_schedule, accept_proposal_comments_after_deadline, 
						open_text, closed_text, session_text, tracks_text, 
						dt_created, dt_updated, created_by, updated_by, active 
				FROM 	event 
				WHERE 	event_id = <cfqueryparam value="#arguments.theEvent.getEventID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getEvent.RecordCount gt 0>
				<cfif getEvent.parent_id neq "">
					<cfset parentID = getEvent.parent_id />
				</cfif>
				
				<cfif getEvent.proposal_deadline neq "">
					<cfset proposalDeadline = getEvent.proposal_deadline />
				</cfif>
				
				<cfif getEvent.updated_by neq "">
					<cfset updatedBy = getEvent.updated_by />
				</cfif>
				
				<cfset arguments.theEvent.init(getEvent.event_id, parentID, getEvent.slug, getEvent.title, getEvent.start_date, 
												getEvent.end_date, proposalDeadline, getEvent.allow_proposal_title_edits, 
												getEvent.publish_proposal_statuses, getEvent.publish_schedule, 
												getEvent.accept_proposal_comments_after_deadline, getEvent.open_text, 
												getEvent.closed_text, getEvent.session_text, getEvent.tracks_text, 
												getEvent.dt_created, getEvent.dt_updated, getEvent.created_by, updatedBy, 
												getEvent.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="theEvent" type="Event" required="true" />
		
		<cfset var saveEvent = 0 />
		<cfset var proposalDeadlineNull = false />
		
		<cfif arguments.theEvent.getProposalDeadline() eq CreateDateTime(1900,1,1,0,0,0)>
			<cfset proposalDeadlineNull = true />
		</cfif>		
		
		<cfif arguments.theEvent.getEventID() eq 0>
			<cfquery name="saveEvent" datasource="#getDSN()#">
				INSERT INTO event (
					parent_id, slug, title, start_date, end_date, proposal_deadline, 
					allow_proposal_title_edits, publish_proposal_statuses, 
					publish_schedule, accept_proposal_comments_after_deadline, 
					open_text, closed_text, session_text, tracks_text, 
					dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.theEvent.getParentID()#" cfsqltype="cf_sql_integer" 
							null="#Not arguments.theEvent.getParentID()#" />, 
					<cfqueryparam value="#arguments.theEvent.getSlug()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.theEvent.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
					<cfqueryparam value="#arguments.theEvent.getStartDate()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.theEvent.getEndDate()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.theEvent.getProposalDeadline()#" cfsqltype="cf_sql_timestamp" 
							null="#proposalDeadlineNull#"/>, 
					<cfqueryparam value="#arguments.theEvent.getAllowProposalTitleEdits()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.theEvent.getPublishProposalStatuses()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.theEvent.getPublishSchedule()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.theEvent.getAcceptProposalCommentsAfterDeadline()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.theEvent.getOpenText()#" cfsqltype="cf_sql_longvarchar" />, 
					<cfqueryparam value="#arguments.theEvent.getClosedText()#" cfsqltype="cf_sql_longvarchar" />, 
					<cfqueryparam value="#arguments.theEvent.getSessionText()#" cfsqltype="cf_sql_longvarchar" 
							null="#not Len(arguments.theEvent.getSessionText())#" />, 
					<cfqueryparam value="#arguments.theEvent.getTracksText()#" cfsqltype="cf_sql_longvarchar" 
							null="#not Len(arguments.theEvent.getTracksText())#" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.theEvent.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.theEvent.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveEvent" datasource="#getDSN()#">
				UPDATE 	event 
				SET 	parent_id = <cfqueryparam value="#arguments.theEvent.getParentID()#" cfsqltype="cf_sql_integer" 
												null="#Not arguments.theEvent.getParentID()#" />, 
						slug = <cfqueryparam value="#arguments.theEvent.getSlug()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						title = <cfqueryparam value="#arguments.theEvent.getTitle()#" cfsqltype="cf_sql_varchar" maxlength="255" />, 
						start_date = <cfqueryparam value="#arguments.theEvent.getStartDate()#" cfsqltype="cf_sql_timestamp" />, 
						end_date = <cfqueryparam value="#arguments.theEvent.getEndDate()#" cfsqltype="cf_sql_timestamp" />, 
						proposal_deadline = <cfqueryparam value="#arguments.theEvent.getProposalDeadline()#" cfsqltype="cf_sql_timestamp" 
													null="#proposalDeadlineNull#"/>, 
						allow_proposal_title_edits = <cfqueryparam value="#arguments.theEvent.getAllowProposalTitleEdits()#" 
															cfsqltype="cf_sql_tinyint" />, 
						publish_proposal_statuses = <cfqueryparam value="#arguments.theEvent.getPublishProposalStatuses()#" 
															cfsqltype="cf_sql_tinyint" />, 
						publish_schedule = <cfqueryparam value="#arguments.theEvent.getPublishSchedule()#" cfsqltype="cf_sql_tinyint" />, 
						accept_proposal_comments_after_deadline = <cfqueryparam value="#arguments.theEvent.getAcceptProposalCommentsAfterDeadline()#" 
																			cfsqltype="cf_sql_tinyint" />, 
						open_text = <cfqueryparam value="#arguments.theEvent.getOpenText()#" cfsqltype="cf_sql_longvarchar" />, 
						closed_text = <cfqueryparam value="#arguments.theEvent.getClosedText()#" cfsqltype="cf_sql_longvarchar" />, 
						session_text = <cfqueryparam value="#arguments.theEvent.getSessionText()#" cfsqltype="cf_sql_longvarchar" 
												null="#not Len(arguments.theEvent.getSessionText())#" />, 
						tracks_text = <cfqueryparam value="#arguments.theEvent.getTracksText()#" cfsqltype="cf_sql_longvarchar" 
												null="#not Len(arguments.theEvent.getTracksText())#" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.theEvent.getUpdatedBy()#" cfsqltype="cf_sql_integer" 
													null="#not arguments.theEvent.getUpdatedBy()#" />, 
						active = <cfqueryparam value="#arguments.theEvent.getIsActive()#" cfsqltype="cf_sql_tinyint" />
				WHERE 	event_id = <cfqueryparam value="#arguments.theEvent.getEventID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="theEvent" type="Event" required="true" />
		
		<cfset var deleteEvent = 0 />
		
		<cfquery name="deleteEvent" datasource="#getDSN()#">
			DELETE FROM event 
			WHERE event_id = <cfqueryparam value="#arguments.theEvent.getEventID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
	
</cfcomponent>