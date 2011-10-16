<cfcomponent
	displayname="Track"
	output="false"
	hint="A bean which models the Track form.">

<!--- This bean was generated by the Rooibos Generator with the following template:
Bean Name: Track
Path to Bean: Track
Extends: 
Call super.init(): false
Create cfproperties: false
Bean Template:
	trackID numeric 0
	eventID numeric 0
	title string
	excerpt string
	description string
	color string
	dtCreated date #CreateDateTime(1900,1,1,0,0,0)#
	dtUpdated date #CreateDateTime(1900,1,1,0,0,0)#
	createdBy numeric 0
	updatedBy numeric 0
	isActive boolean false
Create getMemento method: false
Create setMemento method: false
Create setStepInstance method: false
Create validate method: true
Create validate interior: false
Date Format: 
--->

	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="Track" output="false">
		<cfargument name="trackID" type="numeric" required="false" default="0" />
		<cfargument name="eventID" type="numeric" required="false" default="0" />
		<cfargument name="title" type="string" required="false" default="" />
		<cfargument name="excerpt" type="string" required="false" default="" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="color" type="string" required="false" default="" />
		<cfargument name="dtCreated" type="date" required="false" default="#CreateDateTime(1900,1,1,0,0,0)#" />
		<cfargument name="dtUpdated" type="date" required="false" default="#CreateDateTime(1900,1,1,0,0,0)#" />
		<cfargument name="createdBy" type="numeric" required="false" default="0" />
		<cfargument name="updatedBy" type="numeric" required="false" default="0" />
		<cfargument name="isActive" type="boolean" required="false" default="false" />

		<!--- run setters --->
		<cfset setTrackID(arguments.trackID) />
		<cfset setEventID(arguments.eventID) />
		<cfset setTitle(arguments.title) />
		<cfset setExcerpt(arguments.excerpt) />
		<cfset setDescription(arguments.description) />
		<cfset setColor(arguments.color) />
		<cfset setDtCreated(arguments.dtCreated) />
		<cfset setDtUpdated(arguments.dtUpdated) />
		<cfset setCreatedBy(arguments.createdBy) />
		<cfset setUpdatedBy(arguments.updatedBy) />
		<cfset setIsActive(arguments.isActive) />

		<cfreturn this />
 	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setTrackID" access="public" returntype="void" output="false">
		<cfargument name="trackID" type="numeric" required="true" />
		<cfset variables.instance.trackID = arguments.trackID />
	</cffunction>
	<cffunction name="getTrackID" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.trackID />
	</cffunction>

	<cffunction name="setEventID" access="public" returntype="void" output="false">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfset variables.instance.eventID = arguments.eventID />
	</cffunction>
	<cffunction name="getEventID" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.eventID />
	</cffunction>

	<cffunction name="setTitle" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.instance.title = trim(arguments.title) />
	</cffunction>
	<cffunction name="getTitle" access="public" returntype="string" output="false">
		<cfreturn variables.instance.title />
	</cffunction>

	<cffunction name="setExcerpt" access="public" returntype="void" output="false">
		<cfargument name="excerpt" type="string" required="true" />
		<cfset variables.instance.excerpt = trim(arguments.excerpt) />
	</cffunction>
	<cffunction name="getExcerpt" access="public" returntype="string" output="false">
		<cfreturn variables.instance.excerpt />
	</cffunction>

	<cffunction name="setDescription" access="public" returntype="void" output="false">
		<cfargument name="description" type="string" required="true" />
		<cfset variables.instance.description = trim(arguments.description) />
	</cffunction>
	<cffunction name="getDescription" access="public" returntype="string" output="false">
		<cfreturn variables.instance.description />
	</cffunction>

	<cffunction name="setColor" access="public" returntype="void" output="false">
		<cfargument name="color" type="string" required="true" />
		<cfset variables.instance.color = trim(arguments.color) />
	</cffunction>
	<cffunction name="getColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.color />
	</cffunction>

	<cffunction name="setDtCreated" access="public" returntype="void" output="false">
		<cfargument name="dtCreated" type="date" required="true" />
		<cfset variables.instance.dtCreated = arguments.dtCreated />
	</cffunction>
	<cffunction name="getDtCreated" access="public" returntype="date" output="false">
		<cfreturn variables.instance.dtCreated />
	</cffunction>

	<cffunction name="setDtUpdated" access="public" returntype="void" output="false">
		<cfargument name="dtUpdated" type="date" required="true" />
		<cfset variables.instance.dtUpdated = arguments.dtUpdated />
	</cffunction>
	<cffunction name="getDtUpdated" access="public" returntype="date" output="false">
		<cfreturn variables.instance.dtUpdated />
	</cffunction>

	<cffunction name="setCreatedBy" access="public" returntype="void" output="false">
		<cfargument name="createdBy" type="numeric" required="true" />
		<cfset variables.instance.createdBy = trim(arguments.createdBy) />
	</cffunction>
	<cffunction name="getCreatedBy" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.createdBy />
	</cffunction>

	<cffunction name="setUpdatedBy" access="public" returntype="void" output="false">
		<cfargument name="updatedBy" type="numeric" required="true" />
		<cfset variables.instance.updatedBy = arguments.updatedBy />
	</cffunction>
	<cffunction name="getUpdatedBy" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.updatedBy />
	</cffunction>

	<cffunction name="setIsActive" access="public" returntype="void" output="false">
		<cfargument name="isActive" type="boolean" required="true" />
		<cfset variables.instance.isActive = arguments.isActive />
	</cffunction>
	<cffunction name="getIsActive" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isActive />
	</cffunction>

	<cffunction name="validate" access="public" returntype="struct" output="false">
		<cfset var errors = StructNew() />
		
		<cfif trim(getTitle()) eq "">
			<cfset errors.title = "Title is required" />
		</cfif>
		
		<cfif Len(Trim(getTitle())) gt 255>
			<cfset errors.title = "Title is limited to 255 characters" />
		</cfif>
		
		<cfif trim(getExcerpt()) eq "">
			<cfset errors.excerpt = "Excerpt is required" />
		</cfif>
		
		<cfif Len(Trim(getExcerpt())) gt 1000>
			<cfset errors.excerpt = "Excerpt is limited to 1000 characters" />
		</cfif>
		
		<cfif trim(getDescription()) eq "">
			<cfset errors.description = "Description is required" />
		</cfif>
		
		<cfif trim(getColor()) eq "">
			<cfset errors.color = "Color is required" />
		</cfif>
		
		<cfif len(trim(getColor())) gt 6>
			<cfset errors.color = "Color is limited to 6 characters" />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
	<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
</cfcomponent>