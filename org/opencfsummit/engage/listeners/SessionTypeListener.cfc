<cfcomponent 
		displayname="SessionTypeListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="sessionTypeService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="processSessionTypeForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var sessionType = arguments.event.getArg('sessionType') />
		<cfset var errors = sessionType.validate() />
		<cfset var message = StructNew() />
		
		<cfset message.text = "The session type was saved." />
		<cfset message.class = "success" />
		
		<cfif not StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cftry>
				<cfset getSessionTypeService().saveSessionType(sessionType) />
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
	
	<cffunction name="deleteSessionType" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The session type was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getSessionTypeService().deleteSessionType(arguments.event.getArg('sessionType')) />
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