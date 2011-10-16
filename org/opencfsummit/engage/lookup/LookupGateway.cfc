<cfcomponent 
		displayname="LookupGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="LookupGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getSkillLevels" access="public" output="false" returntype="query">
		<cfset skillLevels = 0 />
		
		<cfquery name="skillLevels" datasource="#getDSN()#">
			SELECT 	skill_level_id, skill_level, ordering 
			FROM 	skill_level 
			ORDER BY ordering ASC
		</cfquery>
		
		<cfreturn skillLevels />
	</cffunction>

</cfcomponent>