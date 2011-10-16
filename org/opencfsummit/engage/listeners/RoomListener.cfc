<cfcomponent 
		displayname="RoomListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="roomService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="processRoomForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var room = arguments.event.getArg('room') />
		<cfset var errors = room.validate() />
		<cfset var message = StructNew() />
		<cfset var uploadResults = 0 />
		
		<cfset message.text = "The room was saved." />
		<cfset message.class = "success" />
		
		<cfif not StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cfif event.isArgDefined("deleteImage") and event.getArg("deleteImage") 
					and event.isArgDefined("oldImage") and event.getArg("oldImage") neq "">
				<cffile action="delete" file="#ExpandPath(event.getArg('oldImage'))#" />
				<cftry>
					<cfcatch type="any">
						<cfset errors.fileDeleteError = CFCATCH.Message & " - " & CFCATCH.Detail />
						<cfset message.text = "An error occurred deleting the image:" />
						<cfset message.class = "error" />
						<cfset arguments.event.setArg("errors", errors) />
						<cfset arguments.event.setArg("message", message) />
						<cfset redirectEvent("fail", "", true) />
					</cfcatch>
				</cftry>
			</cfif>
			
			<cfif event.getArg("image") neq "">
				<cftry>
					<cfset uploadResults = uploadFile('image', ExpandPath('/uploads/images/rooms/'), 
															'overwrite', '.jpg,.gif,.png') />
					<cfset room.setImage('/uploads/images/rooms/' & uploadResults.serverfile) />
					<cfcatch type="any">
						<cfset errors.fileUploadError = CFCATCH.Message & " - " & CFCATCH.Detail />
						<cfset message.text = "An error occurred with the file upload:" />
						<cfset message.class = "error" />
						<cfset arguments.event.setArg("errors", errors) />
						<cfset arguments.event.setArg("message", message) />
						<cfset redirectEvent("fail", "", true) />
					</cfcatch>
				</cftry>
			</cfif>

			<cftry>
				<cfset getRoomService().saveRoom(room) />
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
	
	<cffunction name="deleteRoom" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The room was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getRoomService().deleteRoom(arguments.event.getArg('room')) />
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