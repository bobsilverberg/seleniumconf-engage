<cfsilent>
	<cfset CopyToScope("${event.theSession}")>
</cfsilent>
<cfoutput>
<div style="float:left;width:500px;">
<h3>#theSession.getProposal().getTitle()#</h3>

<h4>Excerpt</h4>

<p>#theSession.getProposal().getExcerpt()#</p>

<h4>Description</h4>

<p>#theSession.getProposal().getDescription()#</p>

<p>
	<a href=""><img src="/images/icons/arrow_turn_left.png" border="0" width="16" height="16" alt="Sessions" title="Sessions" /></a>&nbsp;
	<a href="">Back to list of sessions</a>
</p>

<h1>SPEAKER STUFF HERE</h1>

<h4>Speakers' Other Sessions Here</h4>
</div>

<div style="float:right;margin-top:10px;width:200px;">
<table border="0">
	<tr>
		<td>#theSession.getProposal().getStatus()#</td>
	</tr>
	<tr>
		<td style="background-color:###theSession.getProposal().getTrackColor()#">#theSession.getProposal().getTrackTitle()#</td>
	</tr>
	<tr>
		<td>#theSession.getProposal().getSessionType()#</td>
	</tr>
	<tr>
		<td>
			<strong>Scheduled:</strong><br />
			#DateFormat(theSession.getSessionTime(), "dddd, mmm d, yyyy")# at 
			#TimeFormat(theSession.getSessionTime(), "h:mm TT")# in 
			<a href="#BuildUrl('admin.room', 'roomID=#theSession.getRoomID()#')#">#theSession.getRoom()#</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="#BuildUrl('sessionNotes', 'sessionID=#theSession.getSessionID()#')#"><img src="/images/icons/page_white_text.png" border="0" width="16" height="16" alt="Session Notes" title="Session Notes" /></a>&nbsp;
			<a href="#BuildUrl('sessionNotes', 'sessionID=#theSession.getSessionID()#')#">Session notes</a>
		</td>
	</tr>
</table>
</div>
</cfoutput>