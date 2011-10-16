<cfcomponent 
		displayname="CommentGateway" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="CommentGateway">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDSN" access="public" output="false" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getComments" access="public" output="false" returntype="query">
		<cfargument name="itemID" type="numeric" required="true" />
		<cfargument name="itemType" type="string" required="true" />
		
		<cfset var comments = 0 />
		
		<cfquery name="comments" datasource="#getDSN()#">
			SELECT 	c.comment_id, c.item_id, c.item_type, c.comment, 
					c.dt_created, c.dt_updated, c.created_by, c.updated_by, c.active, 
					u.name AS commenter_name, u.oauth_profile_link AS commenter_profile_link 
			FROM 	comment c 
			INNER JOIN user u 
				ON c.created_by = u.user_id 
			WHERE 	c.item_id = <cfqueryparam value="#arguments.itemID#" cfsqltype="cf_sql_integer" /> 
			AND 	c.item_type = <cfqueryparam value="#arguments.itemType#" cfsqltype="cf_sql_varchar" maxlength="20" /> 
			ORDER BY c.dt_created ASC
		</cfquery>
		
		<cfreturn comments />
	</cffunction>
	
	<!--- CRUD --->
	<cffunction name="fetch" access="public" output="false" returntype="void">
		<cfargument name="comment" type="Comment" required="true" />
		
		<cfset var getComment = 0 />
		<cfset var updatedBy = 0 />
		<cfset var dtUpdated = CreateDateTime(1900, 1, 1, 0, 0, 0) />
		
		<cfif arguments.comment.getCommentID() != 0>
			<cfquery name="getComment" datasource="#getDSN()#">
				SELECT 	comment_id, item_id, item_type, comment, 
						dt_created, dt_updated, created_by, updated_by, active 
				FROM 	comment 
				WHERE 	comment_id = <cfqueryparam value="#arguments.comment.getCommentID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif getComment.RecordCount gt 0>
				<cfif getComment.updatedBy != "">
					<cfset updatedBy = getComment.updated_by />
				</cfif>
				
				<cfif getComment.dt_updated != "">
					<cfset dtUpdated = getComment.dtUpdated />
				</cfif>
				
				<cfset arguments.comment.init(getCommment.comment_id, getComment.item_id, getComment.item_type, 
												getComment.comment, getComment.dt_created, dtUpdated, 
												getComment.created_by, updatedBy, getComment.active) />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="comment" type="Comment" required="true" />
		
		<cfset var saveComment = 0 />
		
		<cfif arguments.comment.getCommentID() == 0>
			<cfquery name="saveComment" datasource="#getDSN()#">
				INSERT INTO comment (
					item_id, item_type, comment, dt_created, created_by, active
				) VALUES (
					<cfqueryparam value="#arguments.comment.getItemID()#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.comment.getItemType()#" cfsqltype="cf_sql_varchar" maxlength="20" />, 
					<cfqueryparam value="#arguments.comment.getComment()#" cfsqltype="cf_sql_longvarchar" />, 
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
					<cfqueryparam value="#arguments.comment.getCreatedBy()#" cfsqltype="cf_sql_tinyint" />, 
					<cfqueryparam value="#arguments.comment.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				)
			</cfquery>
		<cfelse>
			<cfquery name="saveComment" datasource="#getDSN()#">
				UPDATE 	comment 
				SET 	item_id = <cfqueryparam value="#arguments.comment.getItemID()#" cfsqltype="cf_sql_integer" />, 
						item_type = <cfqueryparam value="#arguments.comment.getItemType()#" cfsqltype="cf_sql_varchar" maxlength="20" />, 
						comment = <cfqueryparam value="#arguments.comment.getComment()#" cfsqltype="cf_sql_longvarchar" />, 
						dt_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
						updated_by = <cfqueryparam value="#arguments.comment.getUpdatedBy()#" cfsqltype="cf_sql_tinyint" />, 
						active = <cfqueryparam value="#arguments.comment.getIsActive()#" cfsqltype="cf_sql_tinyint" /> 
				WHERE 	comment_id = <cfqueryparam value="#arguments.comment.getCommentID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="comment" type="Comment" required="true" />
		
		<cfset var deleteComment = 0 />
		
		<cfif arguments.comment.getCommentID() != 0>
			<cfquery name="deleteComment" datasource="#getDSN()#">
				DELETE FROM comment 
				WHERE comment_id = <cfqueryparam value="#arguments.comment.getCommentID()#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>