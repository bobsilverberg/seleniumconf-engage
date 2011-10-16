<cfsilent>
	<cfset CopyToScope("${event.proposals},${event.proposalTags},${event.comments:true},${event.average:false},${event.proposalStatuses},${event.tracks:0}") />
</cfsilent>
<cfoutput>
<cfif not comments>
	<script type="text/javascript">
		$(function() { 
			$("##proposalsTable").tablesorter({widgets:['zebra']}); 
		});	
	</script>
</cfif>

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
	<cfif session.user.getIsAdmin()>
		<cfoutput>
			<p><a href="#BuildUrl('proposals', 'comments=#(not comments)#')#">Toggle Comments</a></p>
		</cfoutput>
		<p>	Tags: 
			<cfoutput query="proposalTags">
				<a href="#BuildUrl('proposals', 'tag=#proposalTags.tag#|comments=#comments#')#">#proposalTags.tag# (#proposalTags.tagged#)</a> | 
			</cfoutput>
		</p>
		<p>	Status: 
			<cfoutput query="proposalStatuses">
				<a href="#BuildUrl('proposals', 'statusId=#proposalStatuses.status_id#|comments=#comments#')#">#proposalStatuses.status#</a> | 
			</cfoutput>
		</p>
	</cfif>
	<table id="proposalsTable" class="tablesorter" border="0" cellpadding="0" cellspacing="1">
		<thead>
			<tr>
				<th width="30%">Title</th>
				<!---<th>Status</th>--->
				<th>Submitted</th>
				<cfif session.user.getIsAdmin()>
					<th>Speaker</th>
					<th>Email</th>
					<th>Your Score</th>
					<th>Total Score</th>
					<th>Votes</th>
					<th>Avg Score</th>
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
							<a href="#BuildUrl('proposals', 'speaker=#proposals.user_id#')#">
								#proposals.speaker_name#
							</a>
						</td>
						<td>#proposals.email#</td>
						<td>#proposals.myScore#</td>
						<td>#proposals.totalScore#</td>
						<td>#proposals.votes#</td>
						<td>#proposals.averagescore#</td>
					</cfif>
				</tr>
				<cfif comments and session.user.getIsAdmin()>
					<tr>
						<td colspan="7">
							<strong>Description:</strong> #proposals.description#
							<cfif len(proposals.note_to_organizers) gt 0>
								<br /><strong>Note to Organizers:</strong> #proposals.note_to_organizers#
							</cfif>
						</td>
					</tr>
					<cfif len(proposals.commenter_name) gt 0>
						<tr><td colspan="7"><h4>Comments</h4></td></tr>
						<cfoutput>
							<tr>
								<td colspan="7">
									<p><strong>#proposals.commenter_name#</a> said ...</strong>&nbsp;
									(#DateFormat(proposals.comment_date, 'm/d/yyyy')# #TimeFormat(proposals.comment_date, 'h:mm TT')#)</p>
									<p>#proposals.comment#</p>
								</td>
							</tr>
						</cfoutput>
					</cfif>
				</cfif>
				<cfif session.user.getIsAdmin()>
					<tr>
						<td colspan="7">
							<form action="#BuildUrl('admin.scoreAndComment')#" method="post"> 
							Status: 
							<select name="statusId" id="statusId">
								<cfloop query="proposalStatuses">
									<option value="#proposalStatuses.status_id#" <cfif proposals.status_id eq proposalStatuses.status_id>selected="selected"</cfif>>#proposalStatuses.status#</option>
								</cfloop>
							</select>
							Track: 
							<select name="trackId" id="trackId">
								<cfloop query="tracks">
									<option value="#tracks.track_id#" <cfif proposals.track_id eq tracks.track_id>selected="selected"</cfif>>#tracks.title#</option>
								</cfloop>
							</select>
							<input name="submit" value="Submit" type="submit" id="submit"/> 
							<input type="hidden" name="commentID" value="0" id="commentID"/> 
							<input type="hidden" name="itemID" value="#proposals.proposal_id#" id="itemID"/> 
							<input type="hidden" name="proposalID" value="#proposals.proposal_id#" id="proposalID"/> 
							<input type="hidden" name="itemType" value="proposal" id="itemType"/> 
							<input type="hidden" name="nextEvent" value="proposals" id="nextEvent"/> 
							<input type="hidden" name="comments" value="false" id="comments"/> 
							</form>
						</td>
					</tr>
				</cfif>
			</cfoutput>
		</tbody>
	</table>
</cfif>

<!---
<cfoutput>
<p>
	<a href="#BuildUrl('proposalForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Proposal" title="Add Proposal" /></a>&nbsp;
	<a href="#BuildUrl('proposalForm')#">Add Proposal</a>
</p>
</cfoutput>
--->
