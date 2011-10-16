<cfsilent>
	<cfset CopyToScope("${event.sessionType}") />
</cfsilent>
<cfoutput>
<h3>#sessionType.getTitle()#</h3>

<p>#sessionType.getDescription()#</p>

<p>Duration: #sessionType.getDuration()# minutes</p>

<table border="0">
	<tr>
		<td>
			<a href="#BuildUrl('admin.sessionTypeForm', 'sessionTypeID=#sessionType.getSessionTypeID()#')#"><img src="/images/icons/page_edit.png" border="0" width="16" height="16" alt="Edit Session Type" title="Edit Session Type" /></a>&nbsp;
			<a href="#BuildUrl('admin.sessionTypeForm', 'sessionTypeID=#sessionType.getSessionTypeID()#')#">Edit Session Type</a>
		</td>
		<td>
			<a href="#BuildUrl('admin.sessionTypes')#"><img src="/images/icons/arrow_turn_left.png" border="0" width="16" height="16" alt="Session Types" title="Session Types" /></a>&nbsp;
			<a href="#BuildUrl('admin.sessionTypes')#">Session Types for This Event</a>
		</td>
	</tr>
</table>
</cfoutput>