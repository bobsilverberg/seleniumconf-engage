<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />

	<cfset CopyToScope("${event.comment}") />
	
	<cfif event.isArgDefined("proposalID")>
		<cfset itemID = event.getArg("proposalID") />
		<cfset itemType = "Proposal" />
	<cfelseif event.isArgDefined("topicSuggestionID")>
		<cfset itemID = event.getArg("topicSuggestionID") />
		<cfset itemType= "Topic Suggestion" />
	</cfif>
	
	<cfset comment.setItemID(itemID) />
	<cfset comment.setItemType(itemType) />
</cfsilent>
<cfoutput>
<form:form actionEvent="processCommentForm" bind="comment">
	<h4>Comment</h4>
	<form:textarea class="ckeditor" path="comment" cols="80" rows="10" />
	<form:button name="submit" value="Submit" />
	<form:hidden path="commentID" />
	<form:hidden path="itemID" />
	<form:hidden path="itemType" />
</form:form>
</cfoutput>