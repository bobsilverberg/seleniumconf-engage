<cfsilent>
	<cfset CopyToScope("${event.speakers},${event.proposalStatuses}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##speakersTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<h3>Speakers</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>
</cfoutput>

<cfif speakers.RecordCount eq 0>
	<p><strong>No speakers!</strong></p>
<cfelse>
	<p>	Statuses: 
		<cfoutput query="proposalStatuses">
			<a href="#BuildUrl('admin.speakers', 'statusId=#proposalStatuses.status_id#')#">#proposalStatuses.status#</a> | 
		</cfoutput>
	</p>
	<table id="speakersTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th width="30%">Name</th>
				<th>Status (Number of Proposals)</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="speakers" group="speaker_name">
				<tr>
					<td width="30%"><a href="#BuildUrl('proposal', 'proposalID=#speakers.proposal_id#')#">#speakers.speaker_name#</a></td>
					<td>
						<cfoutput>
							#speakers.status# (#speakers.proposal_count#),
						</cfoutput>
					</td>
			</cfoutput>
		</tbody>
	</table>
</cfif>

