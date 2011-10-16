<cfcomponent 
		displayname="ProposalService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="ProposalService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setProposalGateway" access="public" output="false" returntype="void">
		<cfargument name="proposalGateway" type="ProposalGateway" required="true" />
		<cfset variables.proposalGateway = arguments.proposalGateway />
	</cffunction>
	<cffunction name="getProposalGateway" access="public" output="false" returntype="ProposalGateway">
		<cfreturn variables.proposalGateway />
	</cffunction>
	
	<cffunction name="setUserService" access="public" output="false" returntype="void">
		<cfargument name="userService" type="any" required="true" />
		<cfset variables.userService = arguments.userService />
	</cffunction>
	<cffunction name="getUserService" access="public" output="false" returntype="any">
		<cfreturn variables.userService />
	</cffunction>
	
	<cffunction name="getProposalBean" access="public" output="false" returntype="Proposal">
		<cfreturn CreateObject("component", "Proposal").init(userService=getUserService()) />
	</cffunction>
	
	<cffunction name="getProposals" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="false" default="0" />
		<cfargument name="tag" type="string" required="false" default="" />
		<cfargument name="statusId" type="numeric" required="false" default="0" />
		
		<cfreturn getProposalGateway().getProposals(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getAcceptedProposals" access="public" output="false" returntype="query">
		
		<cfreturn getProposalGateway().getAcceptedProposals() />
	</cffunction>
	
	<cffunction name="getRejectedProposals" access="public" output="false" returntype="query">
		
		<cfreturn getProposalGateway().getRejectedProposals() />
	</cffunction>
	
	<cffunction name="getProposalComments" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getProposalGateway().getProposalComments(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getProposalScores" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="false" default="0" />
		<cfargument name="tag" type="string" required="false" />
		
		<cfreturn getProposalGateway().getProposalScores(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getProposalSpeakers" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="statusId" type="numeric" required="false" default="0" />
		
		<cfreturn getProposalGateway().getProposalSpeakers(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getProposalTags" access="public" output="false" returntype="query">
		
		<cfreturn getProposalGateway().getProposalTags() />
	</cffunction>
	
	<cffunction name="getProposalFavorites" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="false" default="0" />
		
		<cfreturn getProposalGateway().getProposalFavorites(arguments.eventID, arguments.userID) />
	</cffunction>
	
	<cffunction name="getProposalStatuses" access="public" output="false" returntype="query">
		<cfreturn getProposalGateway().getProposalStatuses() />
	</cffunction>
	
	<cffunction name="getUserVotes" access="public" output="false" returntype="string">
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfset var votes = getProposalGateway().getUserVotes(arguments.userID) />
		<cfset var votesList = "" />
		
		<cfif votes.RecordCount gt 0>
			<cfset votesList = QueryColumnList(votes, "proposal_id") />
		</cfif>
		
		<cfreturn votesList />
	</cffunction>	

	<cffunction name="addVote" access="public" output="false" returntype="void">
		<cfargument name="proposalID" type="numeric" required="true" />
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfset getProposalGateway().addVote(arguments.proposalID, arguments.userID) />
	</cffunction>
		
	<cffunction name="getProposalUserID" access="public" output="false" returntype="numeric">
		<cfargument name="proposalID" type="numeric" required="true" />
		
		<cfreturn getProposalGateway().getProposalUserID(arguments.proposalID) />
	</cffunction>
			
	<cffunction name="getProposal" access="public" output="false" returntype="Proposal">
		<cfargument name="proposalID" type="numeric" required="false" default="0" />
		
		<cfset var proposal = getProposalBean() />
		
		<cfset proposal.setProposalID(arguments.proposalID) />
		<cfset getProposalGateway().fetch(proposal) />
		
		<cfreturn proposal />
	</cffunction>
	
	<cffunction name="saveProposal" access="public" output="false" returntype="void">
		<cfargument name="proposal" type="Proposal" required="true" />
		<cfargument name="user" type="any" required="true" />
		
		<cfset getProposalGateway().save(arguments.proposal) />
		<cfif arguments.user.getIsAdmin()>
			<cfset getProposalGateway().recordScore(arguments.proposal.getProposalId(),arguments.user.getUserId(),arguments.proposal.getMyScore()) />
		</cfif>

	</cffunction>
	
	<cffunction name="deleteProposal" access="public" output="false" returntype="void">
		<cfargument name="proposal" type="Proposal" required="true" />
		
		<cfset getProposalGateway().delete(arguments.proposal) />
	</cffunction>
	
	<cffunction name="updateRSSFeed" access="public" output="false" returntype="void">
		<!---
		<cfargument name="eventID" type="numeric" required="true" />
		<cfargument name="siteURL" type="string" required="true" />
		--->
				
		<cfscript>
			var proposals = getAcceptedProposals();
			var items = ArrayNew(1);
			var item = StructNew();
			var feed = StructNew();
			var i = 0;
			
			for (i = 1; i <= proposals.RecordCount; i++) {
				item = StructNew();
				
				item.title = XmlFormat(proposals['title'][i]);
				item.description = StructNew();
				item.description.value = proposals['description'][i];
				item.guid = StructNew();
				item.guid.isPermaLink = "yes";
				item.guid.value = "/index.cfm/proposal/proposalID/#proposals['proposal_id'][i]#";
				item.pubdate = proposals['dt_created'][i];
				
				ArrayAppend(items, item);
			}
			
			feed.link = "/sessions.rss";
			feed.title = "cf.Objective() Sessions";
			feed.description = "Approved sessions for cf.Objective()";
			feed.pubdate = Now();
			feed.version = "rss_2.0";
			feed.item = items;
		</cfscript>
		
		<cffeed action="create" name="#feed#" outputfile="#ExpandPath('./sessions.rss')#" overwrite="true" />

		<cfquery name="speakers" dbtype="query">
			select distinct speaker_name, user_id, bio
			from proposals
		</cfquery>
		
		<cfscript>
			items = ArrayNew(1);
			item = StructNew();
			feed = StructNew();
			i = 0;
			
			for (i = 1; i <= speakers.RecordCount; i++) {
				item = StructNew();
				
				item.title = XmlFormat(speakers['speaker_name'][i]);
				item.description = StructNew();
				item.description.value = speakers['bio'][i];
				item.guid = StructNew();
				item.guid.isPermaLink = "yes";
				item.guid.value = "/index.cfm/proposal/proposalID/#speakers['user_id'][i]#";
				
				ArrayAppend(items, item);
			}
			
			feed.link = "/speakers.rss";
			feed.title = "cf.Objective() Speakers";
			feed.description = "Approved speakers for cf.Objective()";
			feed.pubdate = Now();
			feed.version = "rss_2.0";
			feed.item = items;
		</cfscript>
		
		<cffeed action="create" name="#feed#" outputfile="#ExpandPath('./speakers.rss')#" overwrite="true" />
	</cffunction>
	
</cfcomponent>