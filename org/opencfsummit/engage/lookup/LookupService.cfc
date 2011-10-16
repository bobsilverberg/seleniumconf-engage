<cfcomponent 
		displayname="LookupService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="void">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setLookupGateway" access="public" output="false" returntype="void">
		<cfargument name="lookupGateway" type="LookupGateway" required="true" />
		<cfset variables.lookupGateway = arguments.lookupGateway />
	</cffunction>
	<cffunction name="getLookupGateway" access="public" output="false" returntype="LookupGateway">
		<cfreturn variables.lookupGateway />
	</cffunction>
	
	<cffunction name="getSkillLevels" access="public" output="false" returntype="query">
		<cfreturn getLookupGateway().getSkillLevels() />
	</cffunction>
	
</cfcomponent>