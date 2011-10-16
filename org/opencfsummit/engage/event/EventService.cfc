<cfcomponent 
		displayname="EventService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="EventService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setEventGateway" access="public" output="false" returntype="void">
		<cfargument name="eventGateway" type="EventGateway" required="true" />
		<cfset variables.eventGateway = arguments.eventGateway />
	</cffunction>
	<cffunction name="getEventGateway" access="public" output="false" returntype="EventGateway">
		<cfreturn variables.eventGateway />
	</cffunction>
	
	<cffunction name="getEventBean" access="public" output="false" returntype="Event">
		<cfreturn CreateObject("component", "Event").init() />
	</cffunction>
	
	<cffunction name="getEvents" access="public" output="false" returntype="query">
		<cfreturn getEventGateway().getEvents() />
	</cffunction>
	
	<cffunction name="getChildEvents" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getEventGateway().getChildEvents(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getParentEvent" access="public" output="false" returntype="Event">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getEvent(getEventGateway().getParentID(arguments.eventID)) />
	</cffunction>
	
	<cffunction name="getLatestEventID" access="public" output="false" returntype="numeric">
		<cfreturn getEventGateway().getLatestEventID() />
	</cffunction>
	
	<cffunction name="getTracksText" access="public" output="false" returntype="string">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getEventGateway().getTracksText(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getEventName" access="public" output="false" returntype="string">
		<cfargument name="eventID" type="string" required="true" />
		
		<cfreturn getEventGateway().getEventName(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getEvent" access="public" output="false" returntype="Event">
		<cfargument name="eventID" type="numeric" required="false" default="0" />
		
		<cfset var theEvent = getEventBean() />

		<cfset theEvent.setEventID(arguments.eventID) />
		<cfset getEventGateway().fetch(theEvent) />
		
		<cfreturn theEvent />
	</cffunction>
	
	<cffunction name="saveEvent" access="public" output="false" returntype="void">
		<cfargument name="theEvent" type="Event" required="true" />
		
		<cfset getEventGateway().save(arguments.theEvent) />
	</cffunction>
	
	<cffunction name="deleteEvent" access="public" output="false" returntype="void">
		<cfargument name="theEvent" type="Event" required="true" />
		
		<cfset getEventGateway().delete(arguments.theEvent) />
	</cffunction>
</cfcomponent>