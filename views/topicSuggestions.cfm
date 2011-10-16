<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset CopyToScope("${event.topicSuggestions},${event.userVotes}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##topicSuggestionsTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<fb:like href="http://engage.cfobjective.com/index.cfm/topicSuggestions/" show_faces="false"></fb:like>
<h3>Current Topic Suggestions</h3>
<cfif !StructKeyExists(session, "user")>
<p><em><a href="#BuildUrl('login')#">Log in</a> to submit suggestions, comment, and vote!</em></p>
</cfif>
<cfif topicSuggestions.RecordCount eq 0>
	<p><strong>No topic suggestions!</strong></p>
<cfelse>
	<form:form actionEvent="processTopicSuggestionVotes">
	<table id="topicSuggestionsTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th width="50%">Topic</th>
				<cfif StructKeyExists(session, "user") && session.user.getIsAdmin()>
					<th>Description</th>
					<th>Suggested Speaker</th>
					<th>Suggested By</th>
					<th>Votes</th>
				</cfif>
				<th>Suggested On</th>
				<th>Comments</th>
				<cfif StructKeyExists(session, "user")>
					<th>My Top Pick</th>
					<th>Vote</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfloop query="topicSuggestions">
				<tr>
					<td>
						<a href="#BuildUrl('topicSuggestion', 'topicSuggestionID=#topicSuggestions.topic_suggestion_id#')#">
							#topicSuggestions.topic#
						</a>
					</td>
					<cfif StructKeyExists(session, "user") && session.user.getIsAdmin()>
						<td>#topicSuggestions.description#</td>
						<td>#topicSuggestions.suggested_speaker#</td>
						<td>#topicSuggestions.suggested_by#</td>
						<td width="50">#topicSuggestions.votes#</td>
					</cfif>
					<td>#DateFormat(topicSuggestions.dt_created, "mm/dd/yyyy")# #TimeFormat(topicSuggestions.dt_created, "hh:mm TT")#</td>
					<td>#topicSuggestions.comments#</td>
					<cfif StructKeyExists(session, "user")>
						<td>
							<input id="topTopicSuggestionId#topicSuggestions.topic_suggestion_id#" name="topTopicSuggestionId" value="#topicSuggestions.topic_suggestion_id#" type="radio" <cfif session.user.getTopTopicSuggestionId() eq topicSuggestions.topic_suggestion_id>checked="checked"</cfif> />
						</td>
						<td>
							<input id="votes#topicSuggestions.topic_suggestion_id#" name="votes" value="#topicSuggestions.topic_suggestion_id#" type="checkbox" <cfif ListFind(userVotes, topicSuggestions.topic_suggestion_id)>checked="checked"</cfif> />
						</td>
					</cfif>
				</tr>
			</cfloop>
			<cfif StructKeyExists(session, "user")>
				<tr>
					<td colspan="4"><form:button name="submit" value="Record Your Votes" /></td>
				</tr>
			</cfif>
		</tbody>
	</table>
	</form:form>
</cfif>

</cfoutput>