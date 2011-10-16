<cfcomponent 
	displayname="UserFormFilter" 
	output="false" 
	extends="MachII.framework.EventFilter" 
	depends="userService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>

	<cffunction name="filterEvent" access="public" output="false" returntype="boolean">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		
		<cfset var proceed = false />
		
		<cfif (arguments.event.getArg('userID', 0) == 0 && StructKeyExists(session, "user") && session.user.getIsAdmin()) || 
				(StructKeyExists(session, "user") && (session.user.getUserID() == arguments.event.getArg("userID") || session.user.getIsAdmin()))>
			<cfset proceed = true />
		<cfelse>
			<cfset arguments.eventContext.clearEventQueue() />
			<cfset redirectEvent("main") />
		</cfif>
		
		<cfreturn proceed />
	</cffunction>

</cfcomponent>