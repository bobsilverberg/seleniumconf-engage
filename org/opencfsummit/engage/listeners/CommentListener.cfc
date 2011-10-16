<cfcomponent 
		displayname="CommentListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="commentService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="getComments" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var itemID = 0 />
		<cfset var itemType = "" />
		
		<cfif arguments.event.isArgDefined("proposalID")>
			<cfset itemID = arguments.event.getArg("proposalID") />
			<cfset itemType = "Proposal" />
		<cfelseif arguments.event.isArgDefined("topicSuggestionID")>
			<cfset itemID = arguments.event.getArg("topicSuggestionID") />
			<cfset itemType = "Topic Suggestion" />
		</cfif>
		
		<cfreturn getCommentService().getComments(itemID, itemType) />
	</cffunction>
	
	<cffunction name="processCommentForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var comment = arguments.event.getArg('comment') />
		<cfset var errors = StructNew() />
		<cfset var message = StructNew() />
		<cfset var successEvent = arguments.event.getArg("nextEvent","") />
		<cfset var failEvent = arguments.event.getArg("nextEvent","") />
		
		<cfset comment.setCreatedBy(session.user.getUserID()) />
		
		<cfset errors = comment.validate() />
		
		<cfset message.text = "The comment was saved." />
		<cfset message.class = "success" />
		
		<cfif arguments.event.getArg("itemType") EQ "Proposal">
			<cfif len(successEvent) EQ 0>
				<cfset successEvent = "proposal" />
				<cfset failEvent = "proposal" />
			</cfif>
			<cfset arguments.event.setArg("proposalID", arguments.event.getArg("itemID")) />
		<cfelseif arguments.event.getArg("itemType") EQ "Topic Suggestion">
			<cfset successEvent = "topicSuggestion" />
			<cfset failEvent = "topicSuggestion" />
			<cfset arguments.event.setArg("topicSuggestionID", arguments.event.getArg("itemID")) />
		</cfif>
		
		<cfif !StructIsEmpty(errors)>
			<cfif not arguments.event.isArgDefined("myScore")>
				<cfset message.text = "Please correct the following errors:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
			</cfif>
			<cfset redirectEvent(failEvent, "", true) />
		<cfelse>
			<cftry>
				<cfset getCommentService().saveComment(comment) />
				<cfset arguments.event.setArg("message", message) />
				<cfset arguments.event.setArg("commentID", comment.getCommentID()) />
				<cfset arguments.event.removeArg("comment") />
				<cfset redirectEvent(successEvent, "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent(failEvent, "", true) />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
	
</cfcomponent>