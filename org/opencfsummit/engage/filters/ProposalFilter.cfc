<cfcomponent 
	displayname="PropsalFormFilter" 
	output="false" 
	extends="MachII.framework.EventFilter" 
	depends="proposalService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>

	<cffunction name="filterEvent" access="public" output="false" returntype="boolean">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		
		<cfset var proceed = false />
		<cfset var proposalUserID = 0 />
		
		<cfif arguments.event.getArg('proposalID', 0) neq 0>
			<cfset proposalUserID = getProposalService().getProposalUserID(arguments.event.getArg('proposalID', 0)) />
		</cfif>
		
		<cfif arguments.event.getArg('proposalID', 0) eq 0 or 
				(StructKeyExists(session, "user") and (session.user.getUserID() eq proposalUserID or session.user.getIsAdmin()))>
			<cfset proceed = true />
		<cfelse>
			<cfset arguments.eventContext.clearEventQueue() />
			<cfset redirectEvent("proposals") />
		</cfif>
		
		<cfreturn proceed />
	</cffunction>

</cfcomponent>