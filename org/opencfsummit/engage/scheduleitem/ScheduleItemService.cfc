<cfcomponent 
		displayname="ScheduleItemService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="ScheduleItemService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setScheduleItemGateway" access="public" output="false" returntype="void">
		<cfargument name="scheduleItemGateway" type="ScheduleItemGateway" required="true" />
		<cfset variables.scheduleItemGateway = arguments.scheduleItemGateway />
	</cffunction>
	<cffunction name="getScheduleItemGateway" access="public" output="false" returntype="ScheduleItemGateway">
		<cfreturn variables.scheduleItemGateway />
	</cffunction>
	
	<cffunction name="getScheduleItemBean" access="public" output="false" returntype="ScheduleItem">
		<cfreturn CreateObject("component", "ScheduleItem").init() />
	</cffunction>
	
	<cffunction name="getScheduleItems" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getScheduleItemGateway().getScheduleItems(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getScheduleItem" access="public" output="false" returntype="ScheduleItem">
		<cfargument name="scheduleItemID" type="numeric" required="false" default="0" />
		
		<cfset var scheduleItem = getScheduleItemBean() />
		
		<cfset scheduleItem.setScheduleItemID(arguments.scheduleItemID) />
		<cfset getScheduleItemGateway().fetch(scheduleItem) />
		
		<cfreturn scheduleItem />
	</cffunction>
	
	<cffunction name="saveScheduleItem" access="public" output="false" returntype="void">
		<cfargument name="scheduleItem" type="ScheduleItem" required="true" />
		
		<cfset getScheduleItemGateway().save(scheduleItem) />
	</cffunction>
	
	<cffunction name="deleteScheduleItem" access="public" output="false" returntype="void">
		<cfargument name="scheduleItem" type="ScheduleItem" required="true" />
		
		<cfset getScheduleItemGateway().delete(scheduleItem) />
	</cffunction>

</cfcomponent>