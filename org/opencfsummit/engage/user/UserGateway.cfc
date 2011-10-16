<cfcomponent 
		displayname="UserGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="UserGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getUsers" access="public" output="false" returntype="query">
		<cfset var users = 0 />
		
		<cfquery name="users" datasource="#getDSN()#">
			SELECT 	u.user_id, email, name, 
					oauth_provider, oauth_uid, is_registered, is_admin, 
					dt_created, active, top_topic_suggestion_id, 
					company, address, city_state_zip, phone, bio, votes
			FROM 	user u
			LEFT OUTER JOIN (
				SELECT 	user_id, count(*) as votes
				FROM	topic_suggestion_vote
				GROUP BY user_id
			) t
			ON		u.user_id = t.user_id 
			ORDER BY dt_created DESC
		</cfquery>
		
		<cfreturn users />
	</cffunction>
	
	<cffunction name="getUserVotes" access="public" output="false" returntype="query">
		<cfargument name="userId" type="numeric" required="true" />
		<cfset var users = 0 />
		
		<cfquery name="users" datasource="#getDSN()#">
			SELECT 	u.user_id, email, name, 
					oauth_provider, oauth_uid, is_registered, is_admin, 
					top_topic_suggestion_id, 
					company, address, city_state_zip, phone, bio,
					t.topic_suggestion_id, topic, suggested_speaker, t.dt_created as topic_date
			FROM 	user u
			LEFT OUTER JOIN topic_suggestion_vote v
			ON		u.user_id = v.user_id 
			LEFT OUTER JOIN topic_suggestion t
			ON		v.topic_suggestion_id = t.topic_suggestion_id
			WHERE 	u.user_id =  <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
			ORDER BY t.topic_suggestion_id DESC
		</cfquery>
		
		<cfreturn users />
	</cffunction>
	
	<cffunction name="userExists" access="public" output="false" returntype="boolean">
		<cfargument name="oauthUID" type="string" required="true" />
		<cfargument name="oauthProvider" type="string" required="true" />
		
		<cfset var checkUser = 0 />
		
		<cfquery name="checkUser" datasource="#getDSN()#">
			SELECT 	user_id 
			FROM 	user 
			WHERE 	oauth_uid = <cfqueryparam value="#arguments.oauthUID#" cfsqltype="cf_sql_longvarchar" /> 
			AND 	oauth_provider = <cfqueryparam value="#arguments.oauthProvider#" cfsqltype="cf_sql_varchar" maxlength="10" />
		</cfquery>
		
		<cfif checkUser.RecordCount gt 0>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="user" type="User" required="true" />
		
		<cfset var getUser = 0 />
		<cfset var dtUpdated = CreateDateTime(1900, 1, 1, 0, 0, 0) />
		<cfset var updatedBy = 0 />

		<cfquery name="getUser" datasource="#getDSN()#">
			SELECT 	user_id, email, name, oauth_provider, oauth_uid, oauth_profile_link, 
					is_registered, is_admin, dt_created, dt_updated, created_by, updated_by, active, top_topic_suggestion_id,
					company, address, city_state_zip, phone, bio
			FROM 	user
			<!--- assume we'll either have a user ID, or an oauth provider and uid ---> 
			<cfif arguments.user.getUserID() neq 0>
			WHERE 	user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			<cfelse>
			WHERE 	oauth_provider = <cfqueryparam value="#arguments.user.getOauthProvider()#" cfsqltype="cf_sql_varchar" maxlength="10" /> 
			AND 	oauth_uid = <cfqueryparam value="#arguments.user.getOauthUID()#" cfsqltype="cf_sql_longvarchar" />
			</cfif>
		</cfquery>
		
		<cfif getUser.RecordCount neq 0>
			<cfif getUser.dt_updated neq "">
				<cfset dtUpdated = getUser.dt_updated />
			</cfif>
			
			<cfif getUser.updated_by neq "">
				<cfset updatedBy = getUser.updated_by />
			</cfif>
			
			<cfset arguments.user.init(getUser.user_id, getUser.email, getUser.name, 
										getUser.oauth_provider, getUser.oauth_uid, getUser.oauth_profile_link, 
										StructNew(), getUser.is_registered, getUser.is_admin, 
										getUser.dt_created, dtUpdated, getUser.created_by, updatedBy, getUser.active, val(getUser.top_topic_suggestion_id),
										getUser.company, getUser.address, getUser.city_state_zip, getUser.phone, getUser.bio) />
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="user" type="User" required="true" />
		
		<cfset var saveUser = 0 />
		<cfset var getUserID = 0 />
		
		<cfif arguments.user.getUserID() eq 0>
			<cftransaction>
				<cfquery name="saveUser" datasource="#getDSN()#">
					INSERT INTO user (
						email, name, 
						oauth_provider, oauth_uid, oauth_profile_link, 
						is_registered, is_admin, 
						dt_created, created_by, active
					) VALUES (
						<cfqueryparam value="#arguments.user.getEmail()#" cfsqltype="cf_sql_varchar" maxlength="255" 
										null="#Not Len(arguments.user.getEmail())#" />, 
						<cfqueryparam value="#arguments.user.getName()#" cfsqltype="cf_sql_varchar" 
										maxlength="500" null="#Not Len(arguments.user.getName())#" />, 
						<cfqueryparam value="#arguments.user.getOauthProvider()#" cfsqltype="cf_sql_varchar" 
										maxlength="10" />, 
						<cfqueryparam value="#arguments.user.getOauthUID()#" cfsqltype="cf_sql_longvarchar" />, 
						<cfqueryparam value="#arguments.user.getOauthProfileLink()#" cfsqltype="cf_sql_varchar" 
										maxlength="500" />, 
						<cfqueryparam value="#arguments.user.getIsRegistered()#" cfsqltype="cf_sql_tinyint" />, 
						<cfqueryparam value="#arguments.user.getIsAdmin()#" cfsqltype="cf_sql_tinyint" />, 
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						<cfqueryparam value="#arguments.user.getCreatedBy()#" cfsqltype="cf_sql_integer" />, 
						<cfqueryparam value="#arguments.user.getIsActive()#" cfsqltype="cf_sql_tinyint" />
					)
				</cfquery>
				
				<cfquery name="getUserID" datasource="#getDSN()#">
					SELECT last_insert_id() AS new_id 
					FROM user
				</cfquery>
			</cftransaction>
			
			<cfif getUserID.RecordCount gt 0>
				<cfset arguments.user.setUserID(getUserID.new_id) />
			</cfif>
		<cfelse>
			<cfquery name="saveUser" datasource="#getDSN()#">
				UPDATE 	user 
				SET 	email = <cfqueryparam value="#arguments.user.getEmail()#" cfsqltype="cf_sql_varchar" 
											maxlength="255" null="#Not Len(arguments.user.getEmail())#" />, 
						name = <cfqueryparam value="#arguments.user.getName()#" cfsqltype="cf_sql_varchar" 
												maxlength="500" null="#Not Len(arguments.user.getName())#" />,
						oauth_provider = <cfqueryparam value="#arguments.user.getOauthProvider()#" cfsqltype="cf_sql_varchar" 
													maxlength="10" null="#Not Len(arguments.user.getOauthProvider())#" />, 
						oauth_uid = <cfqueryparam value="#arguments.user.getOauthUID()#" cfsqltype="cf_sql_longvarchar" 
													null="#Not Len(arguments.user.getOauthUID())#" />, 
						is_registered = <cfqueryparam value="#arguments.user.getIsRegistered()#" cfsqltype="cf_sql_tinyint" />, 
						is_admin = <cfqueryparam value="#arguments.user.getIsAdmin()#" cfsqltype="cf_sql_tinyint" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.user.getUpdatedBy()#" cfsqltype="cf_sql_integer" />, 
						active = <cfqueryparam value="#arguments.user.getIsActive()#" cfsqltype="cf_sql_tinyint" />,
						company = <cfqueryparam value="#arguments.user.getCompany()#" cfsqltype="cf_sql_varchar" 
												maxlength="250" null="#Not Len(arguments.user.getCompany())#" />,
						address = <cfqueryparam value="#arguments.user.getAddress()#" cfsqltype="cf_sql_varchar" 
												maxlength="500" null="#Not Len(arguments.user.getAddress())#" />,
						city_state_zip = <cfqueryparam value="#arguments.user.getCityStateZip()#" cfsqltype="cf_sql_varchar" 
												maxlength="500" null="#Not Len(arguments.user.getCityStateZip())#" />,
						phone = <cfqueryparam value="#arguments.user.getPhone()#" cfsqltype="cf_sql_varchar" 
												maxlength="20" null="#Not Len(arguments.user.getPhone())#" />,
						bio = <cfqueryparam value="#arguments.user.getBio()#" cfsqltype="cf_sql_longvarchar" null="#Not Len(arguments.user.getBio())#" />
				WHERE 	user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="user" type="User" required="true" />
		
		<cfset var deleteUser = 0 />
		<cfset var deleteComments = 0 />
		<cfset var deleteProposals = 0 />
		<cfset var deleteTopicSuggestions = 0 />
		<cfset var deleteProposalVotes = 0 />
		<cfset var deleteTopicSuggestionVotes = 0 />
		
		<cftransaction>
			<cfquery name="deleteUser" datasource="#getDSN()#">
				DELETE FROM user 
				WHERE user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfquery name="deleteComments" datasource="#getDSN()#">
				DELETE FROM comment 
				WHERE created_by = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfquery name="deleteProposals" datasource="#getDSN()#">
				DELETE FROM proposal 
				WHERE user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfquery name="deleteTopicSuggestions" datasource="#getDSN()#">
				DELETE FROM topic_suggestion 
				WHERE created_by = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfquery name="deleteProposalVotes" datasource="#getDSN()#">
				DELETE FROM proposal_vote 
				WHERE user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfquery name="deleteTopicSuggestionVotes" datasource="#getDSN()#">
				DELETE FROM topic_suggestion_vote 
				WHERE user_id = <cfqueryparam value="#arguments.user.getUserID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cftransaction>
	</cffunction>

</cfcomponent>