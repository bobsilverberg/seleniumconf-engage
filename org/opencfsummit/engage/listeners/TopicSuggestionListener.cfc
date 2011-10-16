<cfcomponent 
		displayname="TopicSuggestionListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="topicSuggestionService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="getUserVotes" access="public" output="false" returntype="string">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userVotes = "" />
		
		<cfif StructKeyExists(session, "user")>
			<cfset userVotes = getTopicSuggestionService().getUserVotes(session.user.getUserID()) />
		</cfif>
		
		<cfreturn userVotes />
	</cffunction>
	
	<cffunction name="voteForTopicSuggestion" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		<cfset var remove = arguments.event.getArg('remove',false) />

		<!--- make sure the user is voting using their user ID --->
		<cfif arguments.event.getArg('userID') neq session.user.getUserID()>
			<cfset redirectEvent("fail", "", true) />
		</cfif>

		<cfset message.text = "Your vote was recorded!" />
		<cfif remove>
			<cfset message.text = "Your vote was removed!" />
		</cfif>
		<cfset message.class = "success" />
		
		<cftry>
			<cfif remove>
				<cfset getTopicSuggestionService().removeVote(arguments.event.getArg("topicSuggestionID"), 
														session.user.getUserID()) />
			<cfelse>
				<cfset getTopicSuggestionService().addVote(arguments.event.getArg("topicSuggestionID"), 
														session.user.getUserID()) />
			</cfif>
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="processTopicSuggestionForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var topicSuggestion = arguments.event.getArg('topicSuggestion') />
		<cfset var errors = topicSuggestion.validate() />
		<cfset var message = StructNew() />
		<cfset var topicSuggestionUserID = getTopicSuggestionService().getTopicSuggestionUserID(topicSuggestion.getTopicSuggestionID()) />
		
		<cfif (topicSuggestion.getTopicSuggestionID() > 0 && topicSuggestionUserID != session.user.getUserID() && ! session.user.getIsAdmin())>
			<cfset redirectEvent("fail", "", true) />
		</cfif>
		
		<cfif topicSuggestion.getTopicSuggestionID() eq 0>
			<cfset topicSuggestion.setCreatedBy(session.user.getUserID()) />
			<cfset topicSuggestion.setIsActive(true) />
			<cfset arguments.event.setArg("newTopic", topicSuggestion.getTopic()) />
		</cfif>
		
		<cfset message.text = "The topic suggestion was saved." />
		<cfset message.class = "success" />
		
		<cfif not StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cftry>
				<cfset getTopicSuggestionService().saveTopicSuggestion(topicSuggestion) />
				<cfset arguments.event.setArg("message", message) />
				<!---<cfset getTopicSuggestionService().updateRSSFeed(arguments.event.getArg('eventID'), getProperty('siteURL')) />--->
				<cfset redirectEvent("success", "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent("fail", "", true) />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
	
	<cffunction name="tweetForUser" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var tweetText = arguments.event.getArg('tweetText') />
		<cfset var message = StructNew() />
		<cfset var twitter = setupTwitter() />
		
		<cfset arguments.event.setArg('tweetText','') />

		<cfif len(tweetText) gt 0>
			<cfset message.text = "Thanks for the Tweet!" />
			<cfset message.class = "success" />
			
			<cftry>
				<cfset twitter.updateStatus(tweetText) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("success", "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent("fail", "", true) />
				</cfcatch>
			</cftry>
		</cfif>
		<cfset redirectEvent("success", "", true) />
		
	</cffunction>
	
	<cffunction name="addWallPostForUser" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var tweetText = arguments.event.getArg('tweetText') />
		<cfset var message = StructNew() />
		<cfset var wallPost = 0 />
		<cfset var cookieVals = setupFB() />
		
		<cfset arguments.event.setArg('tweetText','') />

		<cfif len(tweetText) gt 0>
			<cfset message.text = "Thanks for the Wall Post!" />
			<cfset message.class = "success" />
			
			<cftry>
			
				<cfhttp url="https://graph.facebook.com/#session.user.getUserInfo().id#/feed" method="post" result="wallPost">
					<cfhttpparam type="formField" name="access_token" value="#cookieVals['access_token']#" />
					<cfhttpparam type="formField" name="message" value="#tweetText#" />
					<!--- Leaving these out because the link is being created with the Login to Twitter graphic
					<cfhttpparam type="formField" name="link" value="http://engage.cfobjective.com/" />
					<cfhttpparam type="formField" name="name" value="cf.Objective() Topic Suggestion Survey" />
					<cfhttpparam type="formField" name="caption" value="Suggest new topics for cf.Objective() 2011 and vote for your favoutites." />
					--->
				</cfhttp>
				
				<!--- Helps wth debugging
				<cfset userInfo = DeserializeJSON(wallPost.FileContent) />
				--->
	
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("success", "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent("fail", "", true) />
				</cfcatch>
			</cftry>
		</cfif>
		<cfset redirectEvent("success", "", true) />
		
	</cffunction>
	
	<cffunction name="processTopicSuggestionMergeForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var topicSuggestionId = arguments.event.getArg('topicSuggestionId') />
		<cfset var mergeTopicId = arguments.event.getArg('mergeTopicId') />
		<cfset var message = StructNew() />
		
		<cfif ! session.user.getIsAdmin()>
			<cfset redirectEvent("fail", "", true) />
		</cfif>
		
		<cfset message.text = "The topic suggestion was merged." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getTopicSuggestionService().mergeTopicSuggestion(fromId=topicSuggestionId,intoId=mergeTopicId) />
			<cfset arguments.event.setArg("message", message) />
			<cfset getTopicSuggestionService().updateRSSFeed(arguments.event.getArg('eventID'), getProperty('siteURL')) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="processTopicSuggestionVotes" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var topTopicSuggestionId = arguments.event.getArg('topTopicSuggestionId',0) />
		
		<cfset message.text = "Your votes were recorded." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getTopicSuggestionService().maintainVotes(arguments.event.getArg('votes'), topTopicSuggestionId, session.user.getUserID()) />
			<cfif topTopicSuggestionId gt 0>
				<cfset session.user.setTopTopicSuggestionId(topTopicSuggestionId) />
			</cfif>
			<cfset arguments.event.setArg("message", message) />
			<cfset arguments.event.setArg("includeTwitterAnywhere", true) />

			<cfset redirectEvent("success", "", true) />

			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="deleteTopicSuggestion" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		<cfset var topicSuggestion = arguments.event.getArg('topicSuggestion') />
		<cfset var topicSuggestionUserID = getTopicSuggestionService().getTopicSuggestionUserID(topicSuggestion.getTopicSuggestionID()) />
		
		<cfif (topicSuggestionUserID != session.user.getUserID() && ! session.user.getIsAdmin())>
			<cfset redirectEvent("fail", "", true) />
		</cfif>

		<cfset message.text = "The topic suggestion was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getTopicSuggestionService().deleteTopicSuggestion(arguments.event.getArg('topicSuggestion')) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="setupTwitter" access="private" output="false" returntype="any">
		<cfset var twitter = CreateObject("java", "twitter4j.Twitter").init() />
		<cfset var accessToken = CreateObject("java", "twitter4j.http.AccessToken").init(session.user.getUserInfo().oAuthToken,session.user.getUserInfo().oAuthTokenSecret) />
		<cfset twitter.setOAuthConsumer(getProperty('twitterKeys').consumerKey, getProperty('twitterKeys').consumerSecret) />
		<cfset twitter.setOAuthAccessToken(accessToken) />
		<cfreturn twitter />
	</cffunction>

	<cffunction name="setupFB" access="private" output="false" returntype="any">
		<cfset var cookiePairs = ListToArray(cookie["fbs_#getProperty('facebookKeys').applicationID#"], "&") />
		<cfset var cookieVals = StructNew() />
		<cfset var temp = 0 />
			
		<cfloop array="#cookiePairs#" index="temp">
			<cfset cookieVals[ListFirst(temp, "=")] = ListLast(temp, "=") />
		</cfloop>
		
		<cfreturn cookieVals />
	</cffunction>

</cfcomponent>