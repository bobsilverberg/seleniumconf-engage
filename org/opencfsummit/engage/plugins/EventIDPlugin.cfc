<cfcomponent 
		displayname="EventIDPlugin" 
		output="false" 
		extends="MachII.framework.Plugin" 
		depends="eventService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="preEvent" access="public" returntype="void" output="false">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		
		<cfif arguments.eventContext.getCurrentEvent().getName() eq "admin.eventForm" 
				and (not arguments.eventContext.getCurrentEvent().isArgDefined('eventID') 
						or arguments.eventContext.getCurrentEvent().getArg('eventID') eq 0)>
			<cfset arguments.eventContext.getCurrentEvent().setArg('eventID', 0) />
		<cfelse>
			<cfif arguments.eventContext.getCurrentEvent().isArgDefined("eventID")>
				<cfset session.eventID = arguments.eventContext.getCurrentEvent().getArg('eventID') />
			<cfelseif StructKeyExists(session, "eventID")>
				<cfset arguments.eventContext.getCurrentEvent().setArg("eventID", session.eventID) />
			<cfelse>
				<cfset session.eventID = getEventService().getLatestEventID() />
				<cfset arguments.eventContext.getCurrentEvent().setArg("eventID", session.eventID) />
			</cfif>
		</cfif>
	</cffunction>
	
</cfcomponent>