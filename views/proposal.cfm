<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset CopyToScope("${event.proposal},${event.tracks},${event.proposalStatuses},${event.sessionTypes},${event.skillLevels},${event.comments}") />
</cfsilent>
<cfoutput>
<h3>#proposal.getTitle()#</h3>

<h4>SPEAKER: #proposal.getSpeakerName()#</h4>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif session.user.getIsAdmin()>
	<div class="info">
		<table width="100%" border="0">
		<form:form actionEvent="admin.updateProposal" bind="proposal">
			<tr>
				<td align="right">Your Score</td>
				<td>
					<cfloop from="1" to="10" index="i">
						<form:radio path="myScore" value="#i#"/> #i#
					</cfloop>
				</td>
			</tr>
			<tr>
				<td align="right" valign="top">Tags</td>
				<td valign="top">
					<form:input path="tags" size="50" /><br />
					<span style="font-size:9px;">(comma separated)</span>
				</td>
			</tr>
			<tr>
				<td align="right">Track</td>
				<td>
					<form:select path="trackID">
						<form:option value="0" label="- select -" />
						<form:options items="#tracks#" valueCol="track_id" labelCol="title" />
					</form:select>
				</td>
			</tr>
			<tr>
				<td align="right">Skill Level</td>
				<td>
					<form:select path="skillLevelID">
						<form:option value="0" label="- select -" />
						<form:options items="#skillLevels#" valueCol="skill_level_id" labelCol="skill_level" />
					</form:select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>CHANGE STATUS:</strong></td>
				<td>
					<form:select path="statusID">
						<form:options items="#proposalStatuses#" valueCol="status_id" labelCol="status" />
					</form:select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<form:button name="submit" value="Update" /><br />
				</td>
			</tr>
			<form:hidden path="proposalID" />
		</form:form>
		</table>
	</div>

	<!---
	<h4>Session Type</h4>
	
	<p>#proposal.getSessionType()#</p>
	
	<h4>Skill Level</h4>
	
	<p>#proposal.getSkillLevel()#</p>
	
	<h4>Excerpt</h4>
	
	<p>#proposal.getExcerpt()#</p>
	
	<h4>Tags</h4>
	
	<p>
	<cfif proposal.getTags() eq "">
		<em>- none -</em>
	<cfelse>
		#proposal.getTags()#
	</cfif>
	</p>
	--->
</cfif>

<h4>Description</h4>

<p>#proposal.getDescription()#</p>


<h4>Submitted On</h4>

<p>#DateFormat(proposal.getDtCreated(), 'm/d/yyyy')# #TimeFormat(proposal.getDtCreated(), 'h:mm TT')#</p>

<h4>Note to Organizers</h4>

<p>#proposal.getNoteToOrganizers()#</p>

<table border="0">
	<tr>
		<td>
			<a href="#BuildUrl('proposalForm', 'proposalID=#proposal.getProposalID()#')#"><img src="/images/icons/page_edit.png" border="0" width="16" height="16" alt="Edit Proposal" title="Edit Proposal" /></a>&nbsp;
			<a href="#BuildUrl('proposalForm', 'proposalID=#proposal.getProposalID()#')#">Edit Proposal</a>
		</td>
		<td>
			<a href="#BuildUrl('deleteProposal', 'proposalID=#proposal.getProposalID()#')#" class="confirm"><img src="/images/icons/delete.png" border="0" width="16" height="16" alt="Destroy Proposal" title="Destroy Proposal" /></a>&nbsp;
			<a href="#BuildUrl('deleteProposal', 'proposalID=#proposal.getProposalID()#')#" class="confirm">Destroy Proposal</a>
		</td>
		<td>
			<a href="#BuildUrl('proposals')#"><img src="/images/icons/arrow_turn_left.png" border="0" width="16" height="16" alt="Proposals" title="Proposals" /></a>&nbsp;
			<a href="#BuildUrl('proposals')#">Back to Proposals</a>
		</td>
	</tr>
</table>

<cfif session.user.getIsAdmin()>
	
	<cfif comments.RecordCount gt 0>
		<h4>Comments</h4>
			
			<cfloop query="comments">
				<p><strong><a href="#comments.commenter_profile_link#">#comments.commenter_name#</a> said ...</strong>&nbsp;
				(#DateFormat(comments.dt_created, 'm/d/yyyy')# #TimeFormat(comments.dt_created, 'h:mm TT')#)</p>
				<p>#comments.comment#</p>
				<hr noshade="true" />
		</cfloop>
	</cfif>

	#event.getArg('commentForm', '')#

</cfif>
</cfoutput>
