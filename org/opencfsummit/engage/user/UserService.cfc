<cfcomponent 
		displayname="UserService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="UserService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setUserGateway" access="public" output="false" returntype="void">
		<cfargument name="userGateway" type="UserGateway" required="true" />
		<cfset variables.userGateway = arguments.userGateway />
	</cffunction>
	<cffunction name="getUserGateway" access="public" output="false" returntype="UserGateway">
		<cfreturn variables.userGateway />
	</cffunction>
	
	<cffunction name="getUserBean" access="public" output="false" returntype="User">
		<cfreturn CreateObject("component", "User").init() />
	</cffunction>
	
	<cffunction name="getUsers" access="public" output="false" returntype="query">
		<cfreturn getUserGateway().getUsers() />
	</cffunction>
	
	<cffunction name="getUserVotes" access="public" output="false" returntype="query">
		<cfargument name="userId" type="numeric" required="true" />
		<cfreturn getUserGateway().getUserVotes(arguments.userId) />
	</cffunction>
	
	<cffunction name="userExists" access="public" output="false" returntype="boolean">
		<cfargument name="oauthUID" type="string" required="true" />
		<cfargument name="oauthProvider" type="string" required="true" />
		
		<cfreturn getUserGateway().userExists(arguments.oauthUID, arguments.oauthProvider) />
	</cffunction>
	
	<cffunction name="getUser" access="public" output="false" returntype="User">
		<cfargument name="userID" type="numeric" required="false" default="0" />
		<cfargument name="oauthProvider" type="string" required="false" default="" />
		<cfargument name="oauthUID" type="string" required="false" default="" />
		
		<cfset var user = getUserBean() />
		
		<cfif arguments.userID != 0>
			<cfset user.setUserID(arguments.userID) />
		<cfelse>
			<cfset user.setOauthProvider(arguments.oauthProvider) />
			<cfset user.setOauthUID(arguments.oauthUID) />
		</cfif>

		<cfset getUserGateway().fetch(user) />
		
		<cfreturn user />
	</cffunction>
	
	<cffunction name="saveUser" access="public" output="false" returntype="void">
		<cfargument name="user" type="User" required="true" />
		
		<cfset getUserGateway().save(arguments.user) />
	</cffunction>

</cfcomponent>