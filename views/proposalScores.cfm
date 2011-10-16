<cfsilent>
	<cfset CopyToScope("${event.proposals},${event.proposalTags}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() { 
		$("##proposalsTable").tablesorter({widgets:['zebra']}); 
	});	
</script>

<h3>Proposals</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>
</cfoutput>

<cfif proposals.RecordCount eq 0>
	<p><strong>No proposals!</strong></p>
<cfelse>
	<p>	Tags: 
		<cfoutput query="proposalTags">
			<a href="#BuildUrl('admin.proposalScores', 'tag=#proposalTags.tag#')#">#proposalTags.tag# (#proposalTags.tagged#)</a> | 
		</cfoutput>
	</p>
	<table id="proposalsTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th width="30%">Title</th>
				<!---<th>Status</th>--->
				<th>Submitted</th>
				<cfif session.user.getIsAdmin()>
					<th>Speaker</th>
					<!---<th>Track</th>--->
					<th>Total Score</th>
					<th>Avg Score</th>
					<th>Votes</th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="proposals" group="proposal_id">
				<tr>
					<td width="30%"><a href="#BuildUrl('proposal', 'proposalID=#proposals.proposal_id#')#">#proposals.title#</a></td>
					<!---<td>#proposals.status#</td>--->
					<td>#DateFormat(proposals.dt_created, "mm/dd/yyyy")# #TimeFormat(proposals.dt_created, "hh:mm TT")#</td>
					<cfif session.user.getIsAdmin()>
						<td>
							<a href="#BuildUrl('admin.proposalScores', 'speaker=#proposals.user_id#')#">
								#proposals.speaker_name#
							</a>
						</td>
						<!---<td>#proposals.track_title#</td>--->
						<td>#proposals.totalScore#</td>
						<td>#proposals.averagescore#</td>
						<td>#proposals.votes#</td>
					</cfif>
				</tr>
				<cfset scores = {} />
				<cfoutput group="comment_date">
					<cfif len(proposals.commenter_name) gt 0>
						<tr>
							<td colspan="5">
								<p><strong>#proposals.commenter_name#</a> said ...</strong>&nbsp;
								(#DateFormat(proposals.comment_date, 'm/d/yyyy')# #TimeFormat(proposals.comment_date, 'h:mm TT')#)</p>
								<p>#proposals.comment#</p>
								<hr noshade="true" />
							</td>
						</tr>
					</cfif>
					<cfoutput>
						<cfset scores[proposals.scorer_name] = proposals.user_score />
					</cfoutput>
				</cfoutput>
				<tr><td colspan="5"><strong>Scores: </strong><cfloop collection="#scores#" item="score">#score#: #scores[score]#, </cfloop></td></tr>
			</cfoutput>
		</tbody>
	</table>
</cfif>

<cfoutput>
<p>
	<a href="#BuildUrl('proposalForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Proposal" title="Add Proposal" /></a>&nbsp;
	<a href="#BuildUrl('proposalForm')#">Add Proposal</a>
</p>
</cfoutput>