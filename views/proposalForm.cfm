<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset CopyToScope("${event.proposal},${event.tracks},${event.proposalStatuses},${event.sessionTypes},${event.skillLevels}") />
	
	<cfset agreedToTermsChecked = proposal.getAgreedToTerms() />
	
	<cfif proposal.getProposalID() eq 0>
		<cfset proposal.setContactEmail(session.user.getEmail()) />
	</cfif>
</cfsilent>
<cfoutput>
<cfif proposal.getProposalID() eq 0>
<h3>Create New Proposal</h3>
<cfelse>
<h3>Edit Proposal - #proposal.getTitle()#</h3>
</cfif>
<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<cfset errors = event.getArg('errors') />
	<div id="message" class="#message.class#">
		<h4>#message.text#</h4>
		<ul>
		<cfloop collection="#errors#" item="error">
			<li>#errors[error]#</li>
		</cfloop>
		</ul>
	</div>
</cfif>

<form:form actionEvent="processProposalForm" bind="proposal">
<table width="100%" border="0">
	<cfif session.user.getIsAdmin()>
		<tr>
			<td align="right">Your Score</td>
			<td>
				<cfloop from="1" to="10" index="i">
					<form:radio path="myScore" value="#i#"/> #i#
				</cfloop>
			</td>
		</tr>
		<tr>
			<td align="right">Status</td>
			<td>
				<form:select path="statusID">
					<form:option value="0" label="- select -" />
					<form:options items="#proposalStatuses#" valueCol="status_id" labelCol="status" />
				</form:select>
			</td>
		</tr>
	</cfif>
	<tr>
		<td colspan="2"><h4>Speaker Info (you only have to enter this once)</h4></td>
	</tr>
	<tr>
		<td align="right">Name</td>
		<td><form:input path="user.name" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td align="right">Email</td>
		<td><form:input path="user.email" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td align="right">Company</td>
		<td><form:input path="user.company" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td align="right">Address</td>
		<td><form:input path="user.address" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td align="right">City/State/Zip</td>
		<td><form:input path="user.cityStateZip" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td align="right">Phone</td>
		<td><form:input path="user.phone" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td colspan="2">Bio (required, but you can come back and edit this later)</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="user.bio" cols="40" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2"><h4>Session Info</h4></td>
	</tr>
	<tr>
		<td align="right">Title</td>
		<td><form:input path="title" size="50" maxlength="255" /></td>
	</tr>
	<!---
	<tr>
		<td align="right">Session Type</td>
		<td>
			<form:select path="sessionTypeID">
				<form:option value="0" label="- select -" />
				<form:options items="#sessionTypes#" valueCol="session_type_id" labelCol="title" />
			</form:select>
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
	--->
	<tr>
		<td colspan="2">Description (one or two paragraphs)</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="description" cols="40" rows="10" />
		</td>
	</tr>
	<!---
	<tr>
		<td align="right" valign="top">Tags</td>
		<td valign="top">
			<form:input path="tags" size="50" /><br />
			<span style="font-size:9px;">(comma separated)</span>
		</td>
	</tr>
	--->
	<tr>
		<td colspan="2">
			Note to Organizers (Optional)
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="noteToOrganizers" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2"><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="proposalID" />
</form:form>
</cfoutput>