<cfcomponent 
		displayname="SessionListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="sessionService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="processSessionForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var theSession = arguments.event.getArg('theSession') />
		<cfset var errors = StructNew() />
		<cfset var message = StructNew() />

		<cfif arguments.event.getArg('sessionTime') neq "">
			<cfset theSession.setSessionTime(arguments.event.getArg('sessionTime')) />
		</cfif>
		
		<cfset errors = theSession.validate() />
		
		<cfset message.text = "The session was saved." />
		<cfset message.class = "success" />
		
		<cfif not StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cftry>
				<cfset getSessionService().saveSession(theSession) />
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
	
	<cffunction name="deleteSession" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The session was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getSessionService().deleteSession(arguments.event.getArg('session')) />
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