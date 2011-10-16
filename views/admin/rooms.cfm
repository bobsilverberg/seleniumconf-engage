<cfsilent>
	<cfset CopyToScope("${event.rooms}") />
</cfsilent>
<cfoutput>
<h3>Rooms</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif rooms.RecordCount eq 0>
	<p><strong>No rooms!</strong></p>
<cfelse>
	<table border="0" width="100%">
		<tbody>
		<cfloop query="rooms">
			<tr>
				<td>
					<a href="#BuildUrl('admin.room', 'roomID=#rooms.room_id#')#">#rooms.name#</a>
				</td>
			</tr>
			<tr>
				<td>#rooms.description#</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>

<p>
	<a href="#BuildUrl('admin.roomForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Room" title="Add Room" /></a>&nbsp;
	<a href="#BuildUrl('admin.roomForm')#">Add Room</a>
</p>
</cfoutput>