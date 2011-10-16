<cfsilent>
	<cfset CopyToScope("${event.proposals}") />
</cfsilent>

<h3>Proposal Comments</h3>

<cfif proposals.RecordCount eq 0>
	<p><strong>No comments!</strong></p>
<cfelse>
	<cfoutput query="proposals" group="proposal_id">
		<p>
			Submission: <strong><a href="#BuildUrl('proposal', 'proposalID=#proposals.proposal_id#')#">#proposals.title#</a></strong> by: 
			<strong><a href="#BuildUrl('proposals', 'speaker=#proposals.user_id#')#">#proposals.speaker_name#</a></strong>, 
			your score: <strong>#proposals.myScore#</strong>, total score: <strong>#proposals.totalScore#</strong>.<br />
			<strong>Description:</strong> #proposals.description#
			<cfif len(proposals.note_to_organizers) gt 0>
				<br /><strong>Note to Organizers:</strong> #proposals.note_to_organizers#
			</cfif>
			<h4>Comments</h4>
			<cfoutput>
				<strong>#proposals.commenter_name#</a> said ...</strong>&nbsp;
				(#DateFormat(proposals.comment_date, 'm/d/yyyy')# #TimeFormat(proposals.comment_date, 'h:mm TT')#)<br />
				#proposals.comment#
				<hr noshade="true" />
            </cfoutput>
	
			<form action="#BuildUrl('processCommentForm')#" method="post"> 
			<h4>Add a New Comment</h4> 
			<textarea name="comment" rows="4" cols="70" id="comment" class="ckeditor"></textarea> 
			<input name="submit" value="Submit" type="submit" id="submit"/> 
			<input type="hidden" name="commentID" value="0" id="commentID"/> 
			<input type="hidden" name="itemID" value="#proposals.proposal_id#" id="itemID"/> 
			<input type="hidden" name="itemType" value="proposal" id="itemType"/> 
			<input type="hidden" name="nextEvent" value="admin.proposalComments" id="nextEvent"/> 
			</form>
		</p>
    </cfoutput>
</cfif>
