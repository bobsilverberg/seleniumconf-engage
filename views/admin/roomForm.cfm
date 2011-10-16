<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset copyToScope("${event.room}") />
</cfsilent>
<cfoutput>
<cfif room.getRoomID() eq 0>
<h3>Create New Room</h3>
<cfelse>
<h3>Edit Room - #room.getName()#</h3>
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

<form:form actionEvent="admin.processRoomForm" bind="room">
<table border="0" width="100%">
	<tr>
		<td align="right">Name</td>
		<td>
			<form:input path="name" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td align="right">Capacity (number of people)</td>
		<td>
			<form:input path="capacity" />
		</td>
	</tr>
	<tr>
		<td align="right">Size</td>
		<td>
			<form:input path="size" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td align="right">Seating Configuration</td>
		<td>
			<form:input path="seatingConfiguration" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Description</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="description" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td align="right">Image</td>
		<td>
			<form:file path="image" /><br />
			(must be JPG, GIF, or PNG)
		</td>
	</tr>
	<cfif room.getImage() neq "">
		<tr>
			<td colspan="2">Current Image</td>
		</tr>
		<tr>
			<td colspan="2"><img src="#room.getImage()#" /></td>
		</tr>
		<tr>
			<td align="right">Delete Image?</td>
			<td><form:checkbox name="deleteImage" id="deleteImage" value="1" /></td>
		</tr>
	</cfif>
	<tr>
		<td>&nbsp;</td>
		<td><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="roomID" />
	<cfif room.getImage() neq "">
		<form:hidden name="oldImage" id="oldImage" path="image" />
	</cfif>
</form:form>
</cfoutput>
