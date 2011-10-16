<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset copyToScope("${event.events},${event.childEvents},${event.theEvent}") />
	
	<!--- handle date defaults and formatting --->
	<cfset startDate = "" />
	<cfset endDate = "" />
	<cfset proposalDeadline = "" />
	
	<cfif theEvent.getStartDate() neq CreateDateTime(1900,1,1,0,0,0)>
		<cfset startDate = DateFormat(theEvent.getStartDate(), "mm/dd/yyyy") & " " & 
							TimeFormat(theEvent.getStartDate(), "hh:mm TT") />
	</cfif>
	
	<cfif theEvent.getEndDate() neq CreateDateTime(1900,1,1,0,0,0)>
		<cfset endDate = DateFormat(theEvent.getEndDate(), "mm/dd/yyyy") & " " & 
							TimeFormat(theEvent.getEndDate(), "hh:mm TT") />
	</cfif>
	
	<cfif theEvent.getProposalDeadline() neq CreateDateTime(1900,1,1,0,0,0)>
		<cfset proposalDeadline = DateFormat(theEvent.getProposalDeadline(), "mm/dd/yyyy") & " " & 
									TimeFormat(theEvent.getProposalDeadline(), "hh:mm TT") />
	</cfif>
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() {
		$('##startDate').datepicker({
			duration:'',
			showTime:true,
			constrainInput:false
		});
		$('##endDate').datepicker({
			duration:'',
			showTime:true,
			constrainInput:false
		});
		$('##proposalDeadline').datepicker({
			duration:'',
			showTime:true,
			constrainInput:false
		});
	});
</script>

<cfif theEvent.getEventID() eq 0>
<h3>Create New Event</h3>
<cfelse>
<h3>Edit Event - #theEvent.getTitle()#</h3>
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

<form:form actionEvent="admin.processEventForm" bind="theEvent">
<table border="0" width="100%">
	<tr>
		<td align="right">Slug</td>
		<td>
			<form:input path="slug" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td align="right">Title</td>
		<td>
			<form:input path="title" size="70" maxlength="255" />
		</td>
	</tr>
	<!---<tr>
		<td align="right">Child Of</td>
		<td>
			<form:select path="parentID">
				<form:option value="0" label="- None -" />
				<form:options items="#events#" valueCol="event_id" labelCol="title" />
			</form:select>
		</td>
	</tr>
	<tr>
		<td align="right">Children</td>
		<td>
			<ul>
			<cfif childEvents.RecordCount gt 0>
				<cfloop query="#childEvents#">
					<li><a href="#BuildUrl('admin.event', 'eventID=#childEvents.event_id#')#">#childEvents.title#</a></li>
				</cfloop>
			</cfif>
				<li><a href="">Add new child event ...</a></li>
			</ul>
		</td>
	</tr>--->
	<tr>
		<td align="right">Start Date</td>
		<td>
			<form:input name="startDate" id="startDate" value="#startDate#" />
		</td>
	</tr>
	<tr>
		<td align="right">End Date</td>
		<td>
			<form:input name="endDate" id="endDate" value="#endDate#" />
		</td>
	</tr>
	<tr>
		<td align="right">Proposal Deadline</td>
		<td>
			<form:input name="proposalDeadline" id="proposalDeadline" value="#proposalDeadline#" />
		</td>
	</tr>
	<tr>
		<td align="right">Lock editing of proposal title?</td>
		<td>
			<form:radiogroup path="allowProposalTitleEdits" items="true,false" labels="Yes,No">
				${output.radio} <label for="${output.id}">${output.label}</label>
			</form:radiogroup>
		</td>
	</tr>
	<tr>
		<td align="right">Publish proposal statuses?</td>
		<td>
			<form:radiogroup path="publishProposalStatuses" items="true,false" labels="Yes,No">
				${output.radio} <label for="${output.id}">${output.label}</label>
			</form:radiogroup>
		</td>
	</tr>
	<tr>
		<td align="right">Publish schedule?</td>
		<td>
			<form:radiogroup path="publishSchedule" items="true,false" labels="Yes,No">
				${output.radio} <label for="${output.id}">${output.label}</label>
			</form:radiogroup>
		</td>
	</tr>
	<tr>
		<td align="right">Accept proposal comments after deadline?</td>
		<td>
			<form:radiogroup path="acceptProposalCommentsAfterDeadline" items="true,false" labels="Yes,No">
				${output.radio} <label for="${output.id}">${output.label}</label>
			</form:radiogroup>
		</td>
	</tr>
	<tr>
		<td colspan="2">Open Text</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="openText" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Closed Text</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="closedText" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Session Text</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="sessionText" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Tracks Text</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="tracksText" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="eventID" />
</form:form>
</cfoutput>
