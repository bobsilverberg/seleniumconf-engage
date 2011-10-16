<cfsilent>
	<cfset CopyToScope("${event.topPicks}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##topicSuggestionsTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<h3>Top Topic Suggestion Picks</h3>
<cfif topPicks.RecordCount eq 0>
	<p><strong>No top picks!</strong></p>
<cfelse>
	<table id="topicSuggestionsTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th width="50%">Topic</th>
				<th>Suggested Speaker</th>
				<th>Suggested On</th>
				<th>Votes</th>
				<th>Top Pick Count</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="topPicks">
				<tr>
					<td>
						<a href="#BuildUrl('topicSuggestion', 'topicSuggestionID=#topPicks.topic_suggestion_id#')#">
							#topPicks.topic#
						</a>
					</td>
					<td>#topPicks.suggested_speaker#</td>
					<td>#DateFormat(topPicks.dt_created, "mm/dd/yyyy")# #TimeFormat(topPicks.dt_created, "hh:mm TT")#</td>
					<td>#topPicks.votes#</td>
					<td>#topPicks.Users#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfif>

</cfoutput>
