<cfsilent>
	<cfset CopyToScope("${event.room}") />
</cfsilent>
<cfoutput>
<h3>#room.getName()#</h3>

<table width="100%">
	<tbody>
		<tr>
			<td width="50%" valign="top">
				<p>
					<strong>Capacity:</strong> #room.getCapacity()#<br />
					<strong>Size:</strong> #room.getSize()#<br />
					<strong>Seating Configuration:</strong> #room.getSeatingConfiguration()#
				</p>
				
				<p>#room.getDescription()#</p>
				
				<p>
					<a href="#BuildUrl('admin.roomForm', 'roomID=#room.getRoomID()#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Room" title="Edit Room"></a>&nbsp;
					<a href="#BuildUrl('admin.roomForm', 'roomID=#room.getRoomID()#')#">Edit</a>&nbsp;
					<a href="#BuildUrl('admin.deleteRoom', 'roomID=#room.getRoomID()#')#"><img src="/images/icons/delete.png" width="16" height="16" border="0" alt="Destroy Room" title="Destroy Room"></a>&nbsp;
					<a href="#BuildUrl('admin.deleteRoom', 'roomID=#room.getRoomID()#')#">Destroy</a>
				</p>
			</td>
			<td width="50%" valign="top">
				<cfif room.getImage() neq "">
					<img src="#room.getImage()#" />
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>