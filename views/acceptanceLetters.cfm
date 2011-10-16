<cfsilent>
	<cfset CopyToScope("${event.proposals},${event.send:false}") />
</cfsilent>

<cfoutput query="proposals" group="speaker_name">
<cfif send>
sending!<br />
<cfmail from="bob.silverberg@gmail.com" subject="cf.Objective() Wants You!" to="#proposals.email#" bcc="bob.silverberg@gmail.com" 
password="WozitG20" port="587" server="smtp.gmail.com" username="bob.silverberg@gmail.com" usetls="true">
Hey #listFirst(proposals.speaker_name," ")#,

Congratulations! We think the following sessions, proposed by you, are so awesome that we want to include them in this year's cf.Objective():<cfoutput>
 - #proposals.title#</cfoutput>

Please confirm your availability to present at the conference by replying to this note.

An official announcement will be published in the next day or so. **Please keep this information to yourself until that time.** You will be invited to join a Google group for cf.Objective() speakers via which you will receive information on the deadlines for outlines and draft presentations.

Thank you for your interest in speaking at the conference. We look forward to working with you over the next several months. If you have any questions or concerns feel free to email me directly.

Bob Silverberg (on behalf of the cf.Objective() Content Advisory Board)
</cfmail>
</cfif>
Sent mail to #proposals.email#<br />
</cfoutput>
