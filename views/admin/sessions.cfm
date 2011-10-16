<cfsilent>
	<cfset CopyToScope("${event.sessions}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##sessionsTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<h3>Sessions</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif sessions.RecordCount eq 0>
	<p><strong>No sessions!</strong></p>
<cfelse>
	<table id="sessionsTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th>Title</th>
				<th>Track</th>
				<th>Scheduled Time</th>
				<th>Status</th>
				<th>Speakers</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="sessions">
				<tr>
					<td><a href="#BuildUrl('admin.session', 'sessionID=#sessions.session_id#')#">#sessions.proposal_title#</a></td>
					<td>#sessions.track_title#</td>
					<td>#DateFormat(sessions.session_time, "mm/dd/yyyy")# #TimeFormat(sessions.session_time, "hh:mm TT")#</td>
					<td>#sessions.status#</td>
					<td>&nbsp;</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfif>

<p>
	<a href="#BuildUrl('admin.sessionForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Session" title="Add Session" /></a>&nbsp;
	<a href="#BuildUrl('admin.sessionForm')#">Add Session</a>
</p>

</cfoutput>