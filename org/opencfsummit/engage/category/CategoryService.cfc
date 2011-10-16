<cfcomponent 
		displayname="CategoryService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="CategoryService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setCategoryGateway" access="public" output="false" returntype="void">
		<cfargument name="categoryGateway" type="CategoryGateway" required="true" />
		<cfset variables.categoryGateway = arguments.categoryGateway />
	</cffunction>
	<cffunction name="getCategoryGateway" access="public" output="false" returntype="CategoryGateway">
		<cfreturn variables.categoryGateway />
	</cffunction>

</cfcomponent>