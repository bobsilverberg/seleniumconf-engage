<cfset copyToScope("${event.scheduleItems}") />
<cfoutput>
<h3>Schedule Items</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif scheduleItems.RecordCount eq 0>
	<p><strong>No schedule items!</strong></p>
<cfelse>
	<table border="0">
		<tbody>
			<tr>
				<th>Title</th>
				<th>Start Time</th>
				<th>Duration</th>
				<th colspan="2">Controls</th>
			</tr>
		<cfloop query="scheduleItems">
			<tr>
				<td>
					<a href="#BuildUrl('admin.scheduleItem', 'scheduleItemID=#scheduleItems.schedule_item_id#')#">#scheduleItems.title#</a>
				</td>
				<td>
					<cfif IsValid('date', scheduleItems.start_time)>
						#DateFormat(scheduleItems.start_time, "mm/dd/yyyy")#&nbsp;
						#TimeFormat(scheduleItems.start_time, "hh:mm tt")#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td>#scheduleItems.duration#</td>
				<td>
					<a href="#BuildUrl('admin.scheduleItemForm', 'scheduleItemID=#scheduleItems.schedule_item_id#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Schedule Item" title="Edit Schedule Item"></a>&nbsp;
					<a href="#BuildUrl('admin.scheduleItemForm', 'scheduleItemID=#scheduleItems.schedule_item_id#')#">Edit</a>
				</td>
				<td>
					<a href="#BuildUrl('admin.deleteScheduleItem', 'scheduleItemID=#scheduleItems.schedule_item_id#')#"><img src="/images/icons/delete.png" width="16" height="16" border="0" alt="Destroy Schedule Item" title="Destroy Schedule Item"></a>&nbsp;
					<a href="#BuildUrl('admin.deleteScheduleItem', 'scheduleItemID=#scheduleItems.schedule_item_id#')#">Destroy</a>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>

<p>
	<a href="#BuildUrl('admin.scheduleItemForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Schedule Item" title="Add Schedule Item" /></a>&nbsp;
	<a href="#BuildUrl('admin.scheduleItemForm')#">Add Schedule Item</a>
</p>
</cfoutput>