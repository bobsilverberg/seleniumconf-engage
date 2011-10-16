<cfcomponent 
		displayname="TrackService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="TrackService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setTrackGateway" access="public" output="false" returntype="void">
		<cfargument name="trackGateway" type="TrackGateway" required="true" />
		<cfset variables.trackGateway = arguments.trackGateway />
	</cffunction>
	<cffunction name="getTrackGateway" access="public" output="false" returntype="TrackGateway">
		<cfreturn variables.trackGateway />
	</cffunction>
	
	<cffunction name="getTrackBean" access="public" output="false" returntype="Track">
		<cfreturn CreateObject("component", "Track").init() />
	</cffunction>
	
	<cffunction name="getTracks" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getTrackGateway().getTracks(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getTrack" access="public" output="false" returntype="Track">
		<cfargument name="trackID" type="numeric" required="false" default="0" />
		
		<cfset var track = getTrackBean() />
		
		<cfset track.setTrackID(arguments.trackID) />
		<cfset getTrackGateway().fetch(track) />
		
		<cfreturn track />
	</cffunction>
	
	<cffunction name="saveTrack" access="public" output="false" returntype="void">
		<cfargument name="track" type="Track" required="true" />
		
		<cfset getTrackGateway().save(arguments.track) />
	</cffunction>
	
	<cffunction name="deleteTrack" access="public" output="false" returntype="void">
		<cfargument name="track" type="Track" required="true" />
		
		<cfset getTrackGateway().delete(arguments.track) />
	</cffunction>

</cfcomponent>