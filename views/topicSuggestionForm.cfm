<cfif structKeyExists(session,"user")>
	<cfsilent>
		<cfimport prefix="form" taglib="/MachII/customtags/form" />
		<cfset CopyToScope("${event.topicSuggestion},${event.newTopic:''}") />
		<cfset oAuthType = session.user.getOauthProvider() />
	</cfsilent>
	<cfoutput>
	<cfif topicSuggestion.getTopicSuggestionID() eq 0>
	<h3>New Topic Suggestion</h3>
	<cfelse>
	<h3>Edit Topic Suggestion - #topicSuggestion.getTopic()#</h3>
	</cfif>
	<cfif event.isArgDefined('message')>
		<cfset message = event.getArg('message') />
		<cfset errors = event.getArg('errors', StructNew()) />
		<div id="message" class="#message.class#">
			<h4>
				#message.text#
				<cfif len(newTopic) gt 0 or message.text contains "votes were recorded">
					<cfif oAuthType eq "Twitter">
						<cfset buttonLabel = "Tweet It!" />
						<cfset cfo = "##cfObjective" />
						<cfset postEvent = "tweetForUser" />
					<cfelse>
						<cfset buttonLabel = "Add a Wall Post!" />
						<cfset cfo = "cf.Objective()" />
						<cfset postEvent = "addWallPostForUser" />
					</cfif>
					<cfif len(newTopic) gt 0>
						<cfset tweetText = "I just suggested [] for #cfo# 2011. http://bit.ly/9w6Pxd" />
						<cfset shortTopic = newTopic />
						<cfif oAuthType eq "Twitter">
							<cfset label = "Why not Tweet it?" />
							<cfset shortTopic = left(newTopic,142 - len(tweetText)) />
						<cfelse>
							<cfset label = "Why not add a wall post?" />
							<cfset tweetText = replace(tweetText,"http://bit.ly/9w6Pxd","http://engage.cfobjective.com") />
							<cfset shortTopic = """" & shortTopic & """" />
						</cfif>
						<cfset tweetText = replace(tweetText,"[]",shortTopic) />
					<cfelse>						
						<cfset tweetText = "I just voted for my favourite topics for #cfo# 2011. Why not cast your votes now? http://engage.cfobjective.com" />
						<cfif oAuthType eq "Twitter">
							<cfset label = "Why not Tweet about it and encourage others to vote too?" />
						<cfelse>
							<cfset label = "Why not add a wall post and encourage others to vote too?" />
						</cfif>
					</cfif>
					<form:form actionEvent="#postEvent#">
						<br />
						#label#<br />
						<form:textarea name="tweetText" rows="3" cols="70" value="#tweetText#" /><br />
						<form:button name="submit" value="#buttonLabel#" />
					</form:form>
				</cfif>
			</h4>
			<cfif !StructIsEmpty(errors)>
				<ul>
				<cfloop collection="#errors#" item="error">
					<li>#errors[error]#</li>
				</cfloop>
				</ul>
			</cfif>
		</div>
	</cfif>
	
	<form:form actionEvent="processTopicSuggestionForm" bind="topicSuggestion">
	<table width="100%" border="0">
		<tr>
			<td align="right">Topic</td>
			<td><form:input path="topic" size="50" maxlength="500" /></td>
		</tr>
		<!---
		<cfif session.user.getIsAdmin()>
			<tr>
				<td colspan="2">Description</td>
			</tr>
			<tr>
				<td colspan="2">
					<form:textarea class="ckeditor" path="description" cols="80" rows="10" />
				</td>
			</tr>
			<tr>
				<td align="right" valign="top">Categories</td>
				<td>category select here
				</td>
			</tr>
		</cfif>
		--->
		<tr>
			<td align="right">Suggested Speaker (optional)</td>
			<td><form:input path="suggestedSpeaker" size="50" maxlength="500" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><form:button name="submit" value="Submit" /></td>
		</tr>
	</table>
		<form:hidden path="topicSuggestionID" />
	</form:form>
	</cfoutput>
</cfif>
