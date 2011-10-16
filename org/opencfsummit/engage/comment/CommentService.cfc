<cfcomponent 
		displayname="CommentService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="CommentService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setCommentGateway" access="public" output="false" returntype="void">
		<cfargument name="commentGateway" type="CommentGateway" required="true" />
		<cfset variables.commentGateway = arguments.commentGateway />
	</cffunction>
	<cffunction name="getCommentGateway" access="public" output="false" returntype="CommentGateway">
		<cfreturn variables.commentGateway />
	</cffunction>
	
	<cffunction name="getCommentBean" access="public" output="false" returntype="Comment">
		<cfreturn CreateObject("component", "Comment").init() />
	</cffunction>
	
	<cffunction name="getComments" access="public" output="false" returntype="query">
		<cfargument name="itemID" type="numeric" required="true" />
		<cfargument name="itemType" type="string" required="true" />
		
		<cfreturn getCommentGateway().getComments(arguments.itemID, arguments.itemType) />
	</cffunction>
	
	<cffunction name="getComment" access="public" output="false" returntype="Comment">
		<cfargument name="commentID" type="numeric" required="true" />
		
		<cfset var comment = getCommentBean() />
		
		<cfif arguments.commentID != 0>
			<cfset comment.setCommentID(arguments.commentID) />
			<cfset getCommentGateway().fetch(comment) />
		</cfif>
		
		<cfreturn comment />
	</cffunction>
	
	<cffunction name="saveComment" access="public" output="false" returntype="void">
		<cfargument name="comment" type="Comment" required="true" />
		
		<cfset getCommentGateway().save(arguments.comment) />
	</cffunction>
	
</cfcomponent>