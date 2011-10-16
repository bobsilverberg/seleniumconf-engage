<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset copyToScope("${event.sessionType}") />
</cfsilent>
<cfoutput>
<cfif sessionType.getSessionTypeID() eq 0>
<h3>Create New Session Type</h3>
<cfelse>
<h3>Edit Session Type - #sessionType.getTitle()#</h3>
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

<form:form actionEvent="admin.processSessionTypeForm" bind="sessionType">
<table border="0" width="100%">
	<tr>
		<td align="right">Title</td>
		<td>
			<form:input path="title" size="70" maxlength="255" />
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
		<td>Duration</td>
		<td><form:input path="duration" /> (minutes)</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="sessionTypeID" />
</form:form>
</cfoutput>
