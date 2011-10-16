<cfsilent>
	<cfset CopyToScope("${event.scheduleItem}") />
</cfsilent>
<cfoutput>
<h3>#scheduleItem.getTitle()#</h3>

<h4>Excerpt</h4>

<p>#scheduleItem.getExcerpt()#</p>

<h4>Description</h4>

<p>#scheduleItem.getDescription()#</p>

<h4>Room</h4>

<p><a href="#BuildUrl('admin.room', 'roomID=#scheduleItem.getRoomID()#')#">#scheduleItem.getRoomID()#</a></p>

<h4>Start Time</h4>

<p>
	<cfif scheduleItem.getStartTime() neq CreateDateTime(1900,1,1,0,0,0)>
		#DateFormat(scheduleItem.getStartTime(), 'yyyy-mm-dd')# #TimeFormat(scheduleItem.getStartTime(), 'hh:mm TT')#
	<cfelse>
		&nbsp;
	</cfif>
</p>

<h4>Duration</h4>

<p>#scheduleItem.getDuration()#</p>

<table border="0">
	<tr>
		<td>
			<a href="#BuildUrl('admin.scheduleItemForm', 'scheduleItemID=#scheduleItem.getScheduleItemID()#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Schedule Item" title="Edit Schedule Item"></a>&nbsp;
			<a href="#BuildUrl('admin.scheduleItemForm', 'scheduleItemID=#scheduleItem.getScheduleItemID()#')#">Edit</a>
		</td>
		<td>
			<a href="#BuildUrl('admin.scheduleItemForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Schedule Item" title="Add Schedule Item" /></a>&nbsp;
			<a href="#BuildUrl('admin.scheduleIdescriptemForm')#">Add Schedule Item</a>
		</td>
	</tr>
</table>
</cfoutput>