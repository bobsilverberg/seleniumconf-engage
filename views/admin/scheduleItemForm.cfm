<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset copyToScope("${event.scheduleItem},${event.rooms}") />
	
	<!--- handle date defaults and formatting --->
	<cfset startTime = "" />
	
	<cfif scheduleItem.getStartTime() neq CreateDateTime(1900,1,1,0,0,0)>
		<cfset startTime = DateFormat(scheduleItem.getStartTime(), "mm/dd/yyyy") & " " & 
							TimeFormat(scheduleItem.getStartTime(), "hh:mm TT") />
	</cfif>
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() {
		$('##startTime').datepicker({
			duration:'',
			showTime:true,
			constrainInput:false
		});
	});
</script>

<cfif scheduleItem.getScheduleItemID() eq 0>
<h3>Create New Schedule Item</h3>
<cfelse>
<h3>Edit Schedule Item - #scheduleItem.getTitle()#</h3>
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

<form:form actionEvent="admin.processScheduleItemForm" bind="scheduleItem">
<table border="0" width="100%">
	<tr>
		<td align="right">Title</td>
		<td>
			<form:input path="title" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Excerpt</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="excerpt" cols="80" rows="10" />
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
		<td align="right">Start Time</td>
		<td>
			<form:input name="startTime" id="startTime" value="#startTime#" />
		</td>
	</tr>
	<tr>
		<td align="right">Duration (minutes)</td>
		<td><form:input path="duration" /></td>
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
		<td>&nbsp;</td>
		<td><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="scheduleItemID" />
</form:form>
</cfoutput>
