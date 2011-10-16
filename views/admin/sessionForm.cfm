<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset CopyToScope("${event.theSession},${event.proposals},${event.proposalStatuses},${event.rooms}") />
	
	<!--- handle date defaults and formatting --->
	<cfset sessionTime = "" />

	<cfif theSession.getSessionTime() neq CreateDateTime(1900,1,1,0,0,0)>
		<cfset sessionTime = DateFormat(theSession.getSessionTime(), "mm/dd/yyyy") & " " & 
								TimeFormat(theSession.getSessionTime(), "hh:mm TT") />
	</cfif>
</cfsilent>
<cfoutput>
<script type="text/javascript">
$(function() {
	$('##sessionTime').datepicker({
		duration:'',
		showTime:true,
		constrainInput:false
	});
});
</script>

<cfif theSession.getSessionID() eq 0>
<h3>Create New Session</h3>
<cfelse>
<h3>Edit Session - #theSession.getProposal().getTitle()#</h3>

<h4>SPEAKERS HERE</h4>
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

<form:form actionEvent="admin.processSessionForm" bind="theSession">
<table border="0" width="100%">
	<tbody>
		<cfif theSession.getSessionID() neq 0>
			<tr>
				<td colspan="2"><strong>#theSession.getProposal().getTitle()#</strong></td>
			</tr>
		</cfif>
		<tr>
			<td align="right">Proposal</td>
			<td>
				<form:select path="proposalID">
					<form:option value="0" label="- select -" />
					<form:options items="#proposals#" valueCol="proposal_id" labelCol="title" />
				</form:select>
			</td>
		</tr>
		<tr>
			<td align="right">Status</td>
			<td>
				<form:select path="proposal.statusID">
					<form:option value="0" label="- select -" />
					<form:options items="#proposalStatuses#" valueCol="status_id" labelCol="status" />
				</form:select>
			</td>
		</tr>
		<tr>
			<td align="right">Room</td>
			<td>
				<form:select path="roomID">
					<form:option value="0" label="- select -" />
					<form:options items="#rooms#" valueCol="room_id" labelCol="name" />
				</form:select>
			</td>
		</tr>
		<tr>
			<td align="right">Day/Time</td>
			<td><form:input name="sessionTime" id="sessionTime" value="#sessionTime#" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><form:button name="submit" value="Submit" /></td>
		</tr>
	</tbody>
</table>
	<form:hidden path="sessionID" />
</form:form>
</cfoutput>