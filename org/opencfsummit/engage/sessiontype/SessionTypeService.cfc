<cfcomponent 
		displayname="SessionTypeService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="SessionTypeService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setSessionTypeGateway" access="public" output="false" returntype="void">
		<cfargument name="sessionTypeGateway" type="SessionTypeGateway" required="true" />
		<cfset variables.sessionTypeGateway = arguments.sessionTypeGateway />
	</cffunction>
	<cffunction name="getSessionTypeGateway" access="public" output="false" returntype="SessionTypeGateway">
		<cfreturn variables.sessionTypeGateway />
	</cffunction>
	
	<cffunction name="getSessionTypeBean" access="public" output="false" returntype="SessionType">
		<cfreturn CreateObject("component", "SessionType").init() />
	</cffunction>
	
	<cffunction name="getSessionTypes" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getSessionTypeGateway().getSessionTypes(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getSessionTypeByTitle" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="title" type="string" required="true" />
		
		<cfreturn getSessionTypeGateway().getSessionTypeByTitle(arguments.eventID,arguments.title) />
	</cffunction>
	
	<cffunction name="getSessionType" access="public" output="false" returntype="SessionType">
		<cfargument name="sessionTypeID" type="numeric" required="false" default="0" />
		
		<cfset var sessionType = getSessionTypeBean() />
		
		<cfset sessionType.setSessionTypeID(arguments.sessionTypeID) />
		<cfset getSessionTypeGateway().fetch(sessionType) />
		
		<cfreturn sessionType />
	</cffunction>
	
	<cffunction name="saveSessionType" access="public" output="false" returntype="void">
		<cfargument name="sessionType" type="SessionType" required="true" />
		
		<cfset getSessionTypeGateway().save(sessionType) />
	</cffunction>
	
	<cffunction name="deleteSessionType" access="public" output="false" returntype="void">
		<cfargument name="sessionType" type="SessionType" required="true" />
		
		<cfset getSessionTypeGateway().delete(sessionType) />
	</cffunction>

</cfcomponent>