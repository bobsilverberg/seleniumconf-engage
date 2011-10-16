<cfset copyToScope("${event.events}") />
<cfoutput>
<h3>Events</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif events.RecordCount eq 0>
	<p><strong>No events!</strong></p>
<cfelse>
	<table border="0">
		<tbody>
			<tr>
				<th>Slug</th>
				<th>Title</th>
				<th>Accepting?</th>
				<th>Deadline</th>
				<th colspan="4">Manage</th>
			</tr>
		<cfloop query="events">
			<tr>
				<td>#events.slug#</td>
				<td>#events.title#</td>
				<td>
					<cfif DateCompare(Now(), events.proposal_deadline) eq -1>
						Yes
					<cfelse>
						No
					</cfif>
				</td>
				<td>
					<cfif IsValid('date', events.proposal_deadline)>
						#DateFormat(events.proposal_deadline, "mm/dd/yyyy")#&nbsp;
						#TimeFormat(events.proposal_deadline, "hh:mm tt")#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td>
					<a href="#BuildUrl('admin.event', 'eventID=#events.event_id#')#"><img src="/images/icons/page.png" width="16" height="16" border="0" alt="Show Event" title="Show Event"></a>&nbsp;
					<a href="#BuildUrl('admin.event', 'eventID=#events.event_id#')#">Show</a>
				</td>
				<td>
					<a href="#BuildUrl('proposals', 'eventID=#events.event_id#')#"><img src="/images/icons/page_white_stack.png" width="16" height="16" border="0" alt="Event Proposals" title="Event Proposals"></a>&nbsp;
					<a href="#BuildUrl('proposals', 'eventID=#events.event_id#')#">Proposals</a>
				</td>
				<td>
					<a href="#BuildUrl('admin.eventForm', 'eventID=#events.event_id#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Event" title="Edit Event"></a>&nbsp;
					<a href="#BuildUrl('admin.eventForm', 'eventID=#events.event_id#')#">Edit</a>
				</td>
				<td>
					<a href="#BuildUrl('admin.deleteEvent', 'eventID=#events.event_id#')#"><img src="/images/icons/delete.png" width="16" height="16" border="0" alt="Destroy Event" title="Destroy Event"></a>&nbsp;
					<a href="#BuildUrl('admin.deleteEvent', 'eventID=#events.event_id#')#">Destroy</a>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>

<p>
	<a href="#BuildUrl('admin.eventForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Event" title="Add Event" /></a>&nbsp;
	<a href="#BuildUrl('admin.eventForm')#">Add Event</a>
</p>
</cfoutput>