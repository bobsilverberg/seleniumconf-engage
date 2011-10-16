<cfif structKeyExists(session,"user") and session.user.getIsAdmin()>
	<cfsilent>
		<cfimport prefix="form" taglib="/MachII/customtags/form" />
		<cfset CopyToScope("${event.topicSuggestion},${event.topicSuggestions}") />
	</cfsilent>
	<cfoutput>
	<h3>Merge Topic Suggestion - #topicSuggestion.getTopic()#</h3>
	<cfif event.isArgDefined('message')>
		<cfset message = event.getArg('message') />
		<cfset errors = event.getArg('errors', StructNew()) />
		<div id="message" class="#message.class#">
			<h4>#message.text#</h4>
			<cfif !StructIsEmpty(errors)>
				<ul>
				<cfloop collection="#errors#" item="error">
					<li>#errors[error]#</li>
				</cfloop>
				</ul>
			</cfif>
		</div>
	</cfif>
	
	<form:form actionEvent="processTopicSuggestionMergeForm" bind="topicSuggestion">
	<table width="100%" border="0">
		<tr>
			<td align="right">Topic to Merge Into:</td>
			<td><form:select name="mergeTopicId" items="#topicSuggestions#" labelCol="topic" valueCol="topic_suggestion_id" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><form:button name="submit" value="Submit" /></td>
		</tr>
	</table>
	<form:hidden path="topicSuggestionID" />
	</form:form>
	</cfoutput>
</cfif>
