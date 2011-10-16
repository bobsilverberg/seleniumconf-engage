<cfsilent>
	<cfset CopyToScope("${event.userVotes}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##userVotesTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<h3>Votes by #userVotes.name#</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif userVotes.RecordCount eq 0>
	<p><strong>No Votes for this User!</strong></p>
<cfelse>
	<table id="userVotesTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th>Email</th>
				<th>Name</th>
				<th>Topic</th>
				<th>Suggested Speaker</th>
				<th>Topic Added Date</th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="userVotes">
			<tr>
				<td>
					<cfif userVotes.email neq "">
						<a href="#BuildUrl('userForm', 'userID=#userVotes.user_id#')#">#userVotes.email#</a>
					<cfelse>
						<a href="#BuildUrl('userForm', 'userID=#userVotes.user_id#')#">(twitter user)</a>
					</cfif>
				</td>
				<td>#userVotes.name#</td>
				<td>#userVotes.topic#</td>
				<td>#userVotes.suggested_speaker#</td>
				<td>#dateFormat(userVotes.topic_date,"short")# #timeFormat(userVotes.topic_date,"short")#</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>
</cfoutput>