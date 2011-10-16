<cfcomponent
	displayname="TopicSuggestion"
	output="false"
	hint="A bean which models the TopicSuggestion form.">

<!--- This bean was generated by the Rooibos Generator with the following template:
Bean Name: TopicSuggestion
Path to Bean: TopicSuggestion
Extends: 
Call super.init(): false
Create cfproperties: false
Bean Template:
	topicSuggestionID numeric 0
	eventID numeric 0
	topic string 
	categories array #ArrayNew(1)#
	description string 
	suggestedSpeaker string 
	votes numeric 0
	suggestedBy string 
	dtCreated date #CreateDateTime(1900, 1, 1, 0, 0, 0)#
	dtUpdated date #CreateDateTime(1900, 1, 1, 0, 0, 0)#
	createdBy numeric 0
	updatedBy numeric 0
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
	<cffunction name="init" access="public" returntype="TopicSuggestion" output="false">
		<cfargument name="topicSuggestionID" type="numeric" required="false" default="0" />
		<cfargument name="eventID" type="numeric" required="false" default="0" />
		<cfargument name="topic" type="string" required="false" default="" />
		<cfargument name="categories" type="array" required="false" default="#ArrayNew(1)#" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="suggestedSpeaker" type="string" required="false" default="" />
		<cfargument name="suggestedBy" type="string" required="false" default="" />
		<cfargument name="votes" type="numeric" required="false" default="0" />
		<cfargument name="dtCreated" type="date" required="false" default="#CreateDateTime(1900, 1, 1, 0, 0, 0)#" />
		<cfargument name="dtUpdated" type="date" required="false" default="#CreateDateTime(1900, 1, 1, 0, 0, 0)#" />
		<cfargument name="createdBy" type="numeric" required="false" default="0" />
		<cfargument name="updatedBy" type="numeric" required="false" default="0" />
		<cfargument name="isActive" type="boolean" required="false" default="true" />

		<!--- run setters --->
		<cfset setTopicSuggestionID(arguments.topicSuggestionID) />
		<cfset setEventID(arguments.eventID) />
		<cfset setTopic(arguments.topic) />
		<cfset setDescription(arguments.description) />
		<cfset setSuggestedSpeaker(arguments.suggestedSpeaker) />
		<cfset setSuggestedBy(arguments.suggestedBy) />
		<cfset setVotes(arguments.votes) />
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
	<cffunction name="setTopicSuggestionID" access="public" returntype="void" output="false">
		<cfargument name="topicSuggestionID" type="numeric" required="true" />
		<cfset variables.instance.topicSuggestionID = arguments.topicSuggestionID />
	</cffunction>
	<cffunction name="getTopicSuggestionID" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.topicSuggestionID />
	</cffunction>

	<cffunction name="setEventID" access="public" returntype="void" output="false">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfset variables.instance.eventID = arguments.eventID />
	</cffunction>
	<cffunction name="getEventID" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.eventID />
	</cffunction>

	<cffunction name="setTopic" access="public" returntype="void" output="false">
		<cfargument name="topic" type="string" required="true" />
		<cfset variables.instance.topic = arguments.topic />
	</cffunction>
	<cffunction name="getTopic" access="public" returntype="string" output="false">
		<cfreturn variables.instance.topic />
	</cffunction>

	<cffunction name="setCategories" access="public" returntype="void" output="false">
		<cfargument name="categories" type="array" required="true" />
		<cfset variables.instance.categories = arguments.categories />
	</cffunction>
	<cffunction name="getCategories" access="public" returntype="array" output="false">
		<cfreturn variables.instance.categories />
	</cffunction>

	<cffunction name="setDescription" access="public" returntype="void" output="false">
		<cfargument name="description" type="string" required="true" />
		<cfset variables.instance.description = arguments.description />
	</cffunction>
	<cffunction name="getDescription" access="public" returntype="string" output="false">
		<cfreturn variables.instance.description />
	</cffunction>

	<cffunction name="setSuggestedSpeaker" access="public" returntype="void" output="false">
		<cfargument name="suggestedSpeaker" type="string" required="true" />
		<cfset variables.instance.suggestedSpeaker = arguments.suggestedSpeaker />
	</cffunction>
	<cffunction name="getSuggestedSpeaker" access="public" returntype="string" output="false">
		<cfreturn variables.instance.suggestedSpeaker />
	</cffunction>
	
	<cffunction name="setSuggestedBy" access="public" returntype="void" output="false">
		<cfargument name="suggestedBy" type="string" required="true" />
		<cfset variables.instance.suggestedBy = arguments.suggestedBy />
	</cffunction>
	<cffunction name="getSuggestedBy" access="public" returntype="string" output="false">
		<cfreturn variables.instance.suggestedBy />
	</cffunction>

	<cffunction name="setVotes" access="public" returntype="void" output="false">
		<cfargument name="votes" type="numeric" required="true" />
		<cfset variables.instance.votes = arguments.votes />
	</cffunction>
	<cffunction name="getVotes" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.votes />
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
		<cfset variables.instance.createdBy = arguments.createdBy />
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
		
		<cfif trim(getTopic()) eq "">
			<cfset errors.topic = "Topic is required" />
		</cfif>
		
		<cfif len(trim(getTopic())) gt 500>
			<cfset errors.topic = "Topic is limited to 500 characters" />
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