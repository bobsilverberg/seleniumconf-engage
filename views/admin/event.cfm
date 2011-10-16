<cfsilent>
	<cfset CopyToScope("${event.theEvent},${event.events},${event.childEvents},${event.parentEvent}") />
</cfsilent>
<cfoutput>
<h3>#theEvent.getTitle()#</h3>
<table border="0" width="100%">
	<tr>
		<td align="right">Slug</td>
		<td>#theEvent.getSlug()#</td>
	</tr>
	<tr>
		<td align="right">Title</td>
		<td>#theEvent.getTitle()#</td>
	</tr>
	<cfif theEvent.getParentID() neq 0>
		<tr>
			<td align="right">Child Of</td>
			<td>#parentEvent.getTitle()#</td>
		</tr>
	</cfif>
	<tr>
		<td align="right">Children</td>
		<td>
			<ul>
			<cfif childEvents.RecordCount gt 0>
				<cfloop query="#childEvents#">
					<li><a href="#BuildUrl('admin.event', 'eventID=#childEvents.event_id#')#">#childEvents.title#</a></li>
				</cfloop>
			</cfif>
			</ul>
		</td>
	</tr>
	<tr>
		<td align="right">Start Date</td>
		<td>#DateFormat(theEvent.getStartDate(), "dddd, mmmm dd, yyyy")# #TimeFormat(theEvent.getStartDate(), "hh:mm TT")#</td>
	</tr>
	<tr>
		<td align="right">End Date</td>
		<td>#DateFormat(theEvent.getEndDate(), "dddd, mmmm dd, yyyy")# #TimeFormat(theEvent.getEndDate(), "hh:mm TT")#</td>
	</tr>
	<tr>
		<td align="right">Proposal Deadline</td>
		<td>#DateFormat(theEvent.getProposalDeadline(), "dddd, mmmm dd, yyyy")# #TimeFormat(theEvent.getProposalDeadline(), "hh:mm TT")#</td>
	</tr>
	<tr>
		<td align="right">Allow editing of proposal title?</td>
		<td>#YesNoFormat(theEvent.getAllowProposalTitleEdits())#</td>
	</tr>
	<tr>
		<td align="right">Publish proposal statuses?</td>
		<td>#YesNoFormat(theEvent.getPublishProposalStatuses())#</td>
	</tr>
	<tr>
		<td align="right">Publish schedule?</td>
		<td>#YesNoFormat(theEvent.getPublishSchedule())#</td>
	</tr>
	<tr>
		<td align="right">Accept proposal comments after deadline?</td>
		<td>#YesNoFormat(theEvent.getAcceptProposalCommentsAfterDeadline())#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Open Text</td>
		<td>#theEvent.getOpenText()#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Closed Text</td>
		<td>#theEvent.getClosedText()#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Session Text</td>
		<td>#theEvent.getSessionText()#</td>
	</tr>
	<tr>
		<td align="right" valign="top">Tracks Text</td>
		<td>#theEvent.getTracksText()#</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table border="0">
				<tr>
					<td>
						<a href="#BuildUrl('proposals', 'eventID=#theEvent.getEventID()#')#"><img src="/images/icons/page_white_stack.png" border="0" width="16" height="16" alt="Proposals" title="Proposals" /></a>&nbsp;
						<a href="#BuildUrl('proposals', 'eventID=#theEvent.getEventID()#')#">Proposals</a>
					</td>
					<td>
						<a href="#BuildUrl('admin.eventForm', 'eventID=#theEvent.getEventID()#')#"><img src="/images/icons/page_edit.png" border="0" width="16" height="16" alt="Edit Event" title="Edit Event" /></a>&nbsp;
						<a href="#BuildUrl('admin.eventForm', 'eventID=#theEvent.getEventID()#')#">Edit</a>
					</td>
					<td>
						<a href="#BuildUrl('admin.deleteEvent', 'eventID=#theEvent.getEventID()#')#"><img src="/images/icons/delete.png" border="0" width="16" height="16" alt="Delete Event" title="Delete Event" /></a>&nbsp;
						<a href="#BuildUrl('admin.deleteEvent', 'eventID=#theEvent.getEventID()#')#">Destroy</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>