<cfsilent>
	<cfset CopyToScope("${event.track}") />
</cfsilent>
<cfoutput>
<h3>#track.getTitle()#</h3>

<p>#track.getDescription()#</p>

<h4>Excerpt</h4>

<p>#track.getExcerpt()#</p>

<table border="0">
	<tr>
		<td>
			<a href="#BuildUrl('admin.trackForm', 'trackID=#track.getTrackID()#')#"><img src="/images/icons/page_edit.png" border="0" width="16" height="16" alt="Edit Track" title="Edit Track" /></a>&nbsp;
			<a href="#BuildUrl('admin.trackForm', 'trackID=#track.getTrackID()#')#">Edit Track</a>
		</td>
	</tr>
</table>
</cfoutput>