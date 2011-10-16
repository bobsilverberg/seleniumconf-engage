<cfcomponent 
		displayname="SessionService" 
		output="false">

	<cffunction name="init" access="public" output="false" returntype="SessionService">
		<cfreturn this />
	</cffunction>

	<cffunction name="setSessionGateway" access="public" output="false" returntype="void">
		<cfargument name="sessionGateway" type="SessionGateway" required="true" />
		<cfset variables.sessionGateway = arguments.sessionGateway />
	</cffunction>
	<cffunction name="getSessionGateway" access="public" output="false" returntype="SessionGateway">
		<cfreturn variables.sessionGateway />
	</cffunction>
	
	<cffunction name="setProposalService" access="public" output="false" returntype="void">
		<cfargument name="proposalService" type="org.opencfsummit.engage.proposal.ProposalService" required="true" />
		<cfset variables.proposalService = arguments.proposalService />
	</cffunction>
	<cffunction name="getProposalService" access="public" output="false" returntype="org.opencfsummit.engage.proposal.ProposalService">
		<cfreturn variables.proposalService />
	</cffunction>
	
	<cffunction name="getSessionBean" access="public" output="false" returntype="Session">
		<cfreturn CreateObject("component", "Session").init() />
	</cffunction>
	
	<cffunction name="getSessions" access="public" output="false" returntype="query">
		<cfargument name="eventID" type="numeric" required="true" />
		
		<cfreturn getSessionGateway().getSessions(arguments.eventID) />
	</cffunction>
	
	<cffunction name="getSession" access="public" output="false" returntype="Session">
		<cfargument name="sessionID" type="numeric" required="false" default="0" />
		
		<cfset var theSession = getSessionBean() />
		<cfset var proposal = getProposalService().getProposalBean().init() />
		
		<cfset theSession.setSessionID(arguments.sessionID) />
		<cfset getSessionGateway().fetch(theSession) />
		
		<cfif theSession.getProposalID() neq 0>
			<cfset proposal = getProposalService().getProposal(theSession.getProposalID()) />
		</cfif>
		
		<cfset theSession.setProposal(proposal) />
		
		<cfreturn theSession />
	</cffunction>
	
	<cffunction name="saveSession" access="public" output="false" returntype="void">
		<cfargument name="theSession" type="Session" required="true" />
		
		<cfset getSessionGateway().save(theSession) />
	</cffunction>
	
	<cffunction name="deleteSession" access="public" output="false" returntype="void">
		<cfargument name="theSession" type="Session" required="true" />
		
		<cfset getSessionGateway().delete(theSession) />
	</cffunction>

</cfcomponent>