<cfsilent>
	<cfset CopyToScope("${event.proposals},${event.send:false}") />
</cfsilent>

<cfoutput query="proposals">
<cfset plural = "" />
<cfif proposals.count gt 1>
	<cfset plural = "s" />
</cfif>
<cfif send>
sending!<br />
<cfmail from="bob.silverberg@gmail.com" subject="Regrets from cf.Objective() 2011" to="#proposals.email#" bcc="bob.silverberg@gmail.com" 
password="WozitG20" port="587" server="smtp.gmail.com" username="bob.silverberg@gmail.com" usetls="true">
Hello #proposals.speaker_name#,

We would like to thank you for responding to cf.Objective()'s Call for Speakers. Unfortunately we were unable to find room in our schedule for your proposal#plural#. We hope you will consider proposing a topic for next year's conference, and would like to remind you that we will be accepting proposals for our Pecha Kucha sessions in the near future.

Sincerely,
Bob Silverberg (on behalf of the cf.Objective() Content Advisory Board)
</cfmail>
</cfif>
Sent mail to #proposals.email#<br />
</cfoutput>
