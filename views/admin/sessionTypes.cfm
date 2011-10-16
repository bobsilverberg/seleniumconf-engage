<cfsilent>
	<cfset CopyToScope("${event.sessionTypes}") />
</cfsilent>
<cfoutput>
<h3>Session Types</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif sessionTypes.RecordCount eq 0>
	<p><strong>No session types!</strong></p>
<cfelse>
	<table border="0" width="100%">
		<tbody>
		<cfloop query="sessionTypes">
			<tr>
				<td>
					<a href="#BuildUrl('admin.sessionType', 'sessionTypeID=#sessionTypes.session_type_id#')#"><h4>#sessionTypes.title#</h4></a>
				</td>
			</tr>
			<tr>
				<td>#sessionTypes.description#</td>
			</tr>
			<tr>
				<td>Duration: #sessionTypes.duration# minutes</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>
								<a href="#BuildUrl('admin.sessionTypeForm', 'sessionTypeID=#sessionTypes.session_type_id#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Session Type" title="Edit Session Type"></a>&nbsp;
								<a href="#BuildUrl('admin.sessionTypeForm', 'sessionTypeID=#sessionTypes.session_type_id#')#">Edit</a>
							</td>
							<td>
								<a href="#BuildUrl('admin.deleteSessionType', 'sessionTypeID=#sessionTypes.session_type_id#')#"><img src="/images/icons/delete.png" width="16" height="16" border="0" alt="Destroy Session Type" title="Destroy Session Type"></a>&nbsp;
								<a href="#BuildUrl('admin.deleteSessionType', 'sessionTypeID=#sessionTypes.session_type_id#')#">Destroy</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfif>

<p>
	<a href="#BuildUrl('admin.sessionTypeForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Session Type" title="Add Session Type" /></a>&nbsp;
	<a href="#BuildUrl('admin.sessionTypeForm')#">Add Session Type</a>
</p>
</cfoutput>