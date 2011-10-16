<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset CopyToScope('${event.user}') />
	<cfset oauthProviders = ['Facebook','Twitter'] />
</cfsilent>
<cfoutput>
<cfif user.getUserID() eq 0>
<h3>Create User</h3>
<cfelse>
<h3>Update User</h3>
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
<form:form actionEvent="processUserForm" bind="user">
<table border="0">
	<tr>
		<td>Email</td>
		<td><form:input path="email" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td>Name</td>
		<td><form:input path="name" size="50" maxlength="255" /></td>
	</tr>
	<tr>
		<td>OAuth Provider</td>
		<td>
			<form:select path="oauthProvider">
				<form:option value="0" label="- select -" />
				<form:options items="#oauthProviders#" />
			</form:select>
		</td>
	</tr>
	<tr>
		<td>OAuth User ID</td>
		<td><form:input path="oauthUID" size="50" /></td>
	</tr>
	<tr>
		<td>OAuth Profile Link</td>
		<td><form:input path="oauthProfileLink" size="50" /></td>
	</tr>
	<cfif session.user.getIsAdmin()>
		<tr>
			<td>Is Admin</td>
			<td><form:checkbox path="isAdmin" value="1" /></td>
		</tr>
		<tr>
			<td>Is Active</td>
			<td><form:checkbox path="isActive" value="1" /></td>
		</tr>
	</cfif>
	<tr>
		<td>&nbsp;</td>
		<td><form:button name="submit" id="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="userID" />
</form:form>
</cfoutput>