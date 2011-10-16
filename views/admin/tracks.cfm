<cfsilent>
	<cfset CopyToScope("${event.tracks}") />
	
	<cfset tracksText = event.getArg('tracksText', '') />
</cfsilent>
<cfoutput>
<h3>Tracks</h3>

<p>#tracksText#</p>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<div id="message" class="#message.class#">
		#message.text#
	</div>
</cfif>

<cfif tracks.RecordCount eq 0>
	<p><strong>No tracks!</strong></p>
<cfelse>
	<table border="0" width="100%">
		<tbody>
		<cfloop query="tracks">
			<tr>
				<td style="background-color:###tracks.color#;padding:10px 0 0 10px;">
					<a href="#BuildUrl('admin.track', 'trackID=#tracks.track_id#')#"><h3 class="tracktitle">#tracks.title#</h3></a>
				</td>
			</tr>
			<tr>
				<td>#tracks.description#</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>
								<a href="#BuildUrl('admin.trackForm', 'trackID=#tracks.track_id#')#"><img src="/images/icons/page_edit.png" width="16" height="16" border="0" alt="Edit Track" title="Edit Track"></a>&nbsp;
								<a href="#BuildUrl('admin.trackForm', 'trackID=#tracks.track_id#')#">Edit</a>
							</td>
							<td>
								<a href="#BuildUrl('admin.deleteTrack', 'trackID=#tracks.track_id#')#"><img src="/images/icons/delete.png" width="16" height="16" border="0" alt="Destroy Track" title="Destroy Track"></a>&nbsp;
								<a href="#BuildUrl('admin.deleteTrack', 'trackID=#tracks.track_id#')#">Destroy</a>
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
	<a href="#BuildUrl('admin.trackForm')#"><img src="/images/icons/add.png" border="0" width="16" height="16" alt="Add Track" title="Add Track" /></a>&nbsp;
	<a href="#BuildUrl('admin.trackForm')#">Add Track</a>
</p>
</cfoutput>