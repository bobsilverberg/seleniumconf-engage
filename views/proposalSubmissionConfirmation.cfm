<cfsilent>
	<cfset CopyToScope("${event.theEvent}")>
</cfsilent>
<cfoutput>
<h2>Thank You!</h2>

<p style="font-weight:bold;">
	Thanks for submitting your proposal	to cf.Objective() 2011!
</p>

<p>
	You'll hear back from us after January 9th, when proposal submissions close.
</p>

<p>
	<a href="#BuildUrl('proposalForm')#">Propose another talk</a>.
</p>

</cfoutput>