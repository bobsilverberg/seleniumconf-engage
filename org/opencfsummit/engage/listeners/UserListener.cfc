<cfcomponent 
		displayname="UserListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="userService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="login" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfscript>
			var cookiePairs = 0;
			var cookieVals = 0;
			var temp = 0;
			var userInfo = 0;
			var facebookInfo = 0;
			var facebookPicture = 0;
			var user = getUserService().getUserBean();
			var requestString = 0;
			var twitter = 0;
			var requestToken = 0;
			var accessToken = 0;
			var nextEventArgs = StructNew();
			var errors = StructNew();
			var message = StructNew();
		</cfscript>
		
		<cftry>
		
			<cfif StructKeyExists(cookie, "fbs_#getProperty('facebookKeys').applicationID#")>
				<!--- grab the user info, check to see if we have in the db --->
				<cfset cookiePairs = ListToArray(cookie["fbs_#getProperty('facebookKeys').applicationID#"], "&") />
				<cfset cookieVals = StructNew() />
				
				<cfloop array="#cookiePairs#" index="temp">
					<cfset cookieVals[ListFirst(temp, "=")] = ListLast(temp, "=") />
				</cfloop>
				
				<cfhttp url="https://graph.facebook.com/me" result="facebookInfo">
					<cfhttpparam type="url" name="access_token" value="#cookieVals['access_token']#" />
					<cfhttpparam type="header" name="mimetype" value="text/javascript" />
				</cfhttp>
				
				<cfset userInfo = DeserializeJSON(facebookInfo.FileContent) />
				
				<cfhttp url="https://graph.facebook.com/#ListLast(userInfo.link, '/')#?fields=picture" result="facebookPicture">
					<cfhttpparam type="url" name="access_token" value="#cookieVals['access_token']#" />
					<cfhttpparam type="header" name="mimetype" value="text/javascript" />
				</cfhttp>
				
				<cfcookie name="userInfo" value="Facebook|#userInfo.id#">
				
				<cfscript>
					if (isJSON(facebookPicture.FileContent) and structKeyExists(DeserializeJSON(facebookPicture.FileContent),"picture")) {
						userInfo.picture = DeserializeJSON(facebookPicture.FileContent).picture;
					}
					user.setOauthProvider("Facebook");
					user.setOauthUID(userInfo.id);
					user.setOauthProfileLink(userInfo.link);
					user.setEmail(userInfo.email);
					user.setName(userInfo.name);
					
					if (!getUserService().userExists(userInfo.id, "Facebook")) {
						getUserService().saveUser(user);
					} else {
						user = getUserService().getUser(oauthProvider = "Facebook", oauthUID = userInfo.id);
					}
					
					user.setUserInfo(userInfo);
					
					session.user = user;
					
					redirectEvent('main');
				</cfscript>
			<cfelseif arguments.event.getArg("loginMethod", "") eq "Twitter">
				<cfscript>
					twitter = CreateObject("java", "twitter4j.Twitter").init();
					twitter.setOAuthConsumer(getProperty('twitterKeys').consumerKey, getProperty('twitterKeys').consumerSecret);
					requestToken = twitter.getOAuthRequestToken(getProperty('twitterKeys').oauthCallbackURL);
					
					getPageContext().getRequest().getSession().setAttribute("twitter", twitter);
					getPageContext().getRequest().getSession().setAttribute("requestToken", requestToken);
					
					getPageContext().getResponse().sendRedirect(requestToken.getAuthenticationURL());
				</cfscript>
			</cfif>
			
			<cfcatch type="any">
				<cfset errors.systemError = cfcatch.Message & " - " & cfcatch.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="twitterLoginCallback" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cftry>
			<cfscript>
				var twitter = getPageContext().getRequest().getSession().getAttribute("twitter");
				var requestToken = getPageContext().getRequest().getSession().getAttribute("requestToken");
				var verifier = arguments.event.getArg("oauth_verifier");
				var accessToken = twitter.getOAuthAccessToken(requestToken, verifier);
				var user = getUserService().getUserBean();
				var userInfo = 0;
				var errors = StructNew();
				var message = StructNew();
			</cfscript>
		
			<cfhttp url="https://api.twitter.com/1/users/show.json?screen_name=#accessToken.getScreenName()#" method="get" />
			
			<cfset userInfo = DeserializeJSON(CFHTTP.FileContent) />
			<cfset userInfo.oAuthToken = accessToken.getToken() />
			<cfset userInfo.oAuthTokenSecret = accessToken.getTokenSecret() />
			
			<cfcookie name="userInfo" value="Twitter|#userInfo.screen_name#" />
			
			<cfscript>
				user.setOauthProvider('Twitter');
				user.setOauthUID(accessToken.getScreenName());
				user.setOauthProfileLink('http://www.twitter.com/#accessToken.getScreenName()#');
				user.setName(userInfo.name);
				
				if (!getUserService().userExists(accessToken.getScreenName(), "Twitter")) {
					getUserService().saveUser(user);
				} else {
					user = getUserService().getUser(oauthProvider = "Twitter", oauthUID = accessToken.getScreenName());
				}
				
				getPageContext().getRequest().removeAttribute("requestToken");
				
				user.setUserInfo(userInfo);
				
				session.user = user;
							
				redirectEvent('main');
			</cfscript>
			<cfcatch type="any">
				<cfset errors.systemError = cfcatch.Message & " - " & cfcatch.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="processUserForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfscript>
			var user = arguments.event.getArg("user");
			var errors = StructNew();
			var message = StructNew();
			
			if (user.getUserID() == 0) {
				user.setCreatedBy(session.user.getUserID());
			} else {
				user.setUpdatedBy(session.user.getUserID());
			}
			
			if (arguments.event.getArg("isAdmin", 0) == 1 && session.user.getIsAdmin()) {
				user.setIsAdmin(true);
			}
			
			if (arguments.event.getArg("isActive", 0) == 1 && session.user.getIsAdmin()) {
				user.setIsActive(true);
			}
			
			errors = user.validate();
			
			message.text = "The user was saved.";
			message.class = "success";
			
			if (!StructIsEmpty(errors)) {
				message.text = "Please correct the following errors:";
				message.class = "error";
				arguments.event.setArg("errors", errors);
				arguments.event.setArg("message", message);
				redirectEvent("fail", "", true);
			} else {
				try {
					getUserService().saveUser(user);
					arguments.event.setArg("message", message);
					redirectEvent("success", "", true);
				} catch (Any e) {
					errors.systemError = e.Message & " - " & e.Detail;
					message.text = "A system error occurred:";
					message.class = "error";
					arguments.event.setArg("errors", errors);
					arguments.event.setArg("message", message);
					redirectEvent("fail", "", true);
				}
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="logout" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset StructDelete(session, "user", false) />
		<cfcookie name="userInfo" expires="NOW" />
		
		<cfset redirectEvent('login', '', true) />
	</cffunction>
</cfcomponent>