<cfcomponent 
		displayname="EventListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="eventService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="processEventForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var theEvent = arguments.event.getArg('theEvent') />
		<cfset var errors = StructNew() />
		<cfset var message = StructNew() />
		
		<cfif IsValid('date', arguments.event.getArg('startDate'))>
			<cfset theEvent.setStartDate(arguments.event.getArg('startDate')) />
		</cfif>

		<cfif IsValid('date', arguments.event.getArg('endDate'))>
			<cfset theEvent.setEndDate(arguments.event.getArg('endDate')) />
		</cfif>
		
		<cfif IsValid('date', arguments.event.getArg('proposalDeadline'))>
			<cfset theEvent.setProposalDeadline(arguments.event.getArg('proposalDeadline')) />
		</cfif>
		
		<cfset errors = theEvent.validate() />
		
		<cfset message.text = "The event was saved." />
		<cfset message.class = "success" />
		
		<cfif not StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cftry>
				<cfset getEventService().saveEvent(theEvent) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("success", "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent("fail", "", true) />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteEvent" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The event was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getEventService().deleteEvent(arguments.event.getArg('theEvent')) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>