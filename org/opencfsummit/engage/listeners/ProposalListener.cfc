<cfcomponent 
		displayname="ProposalListener" 
		output="false" 
		extends="MachII.framework.Listener" 
		depends="proposalService,userService,sessionTypeService">

	<cffunction name="configure" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="getProposals" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userID = arguments.event.getArg('speaker',0) />
		<cfset var statusId = arguments.event.getArg('statusId',0) />
		
		<cfif not session.user.getIsAdmin()>
			<cfset userID = session.user.getUserID() />
			<cfset statusId = 6 />
		</cfif>
		
		<cfreturn getProposalService().getProposals(arguments.event.getArg('eventID'), userID, arguments.event.getArg('tag',''), statusId) />
	</cffunction>
	
	<cffunction name="getProposalScores" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userID = arguments.event.getArg('speaker',0) />
		
		<cfif not session.user.getIsAdmin()>
			<cfset userID = session.user.getUserID() />
		</cfif>
		
		<cfreturn getProposalService().getProposalScores(arguments.event.getArg('eventID'), userID, arguments.event.getArg('tag','')) />
	</cffunction>
	
	<cffunction name="getProposalSpeakers" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userID = arguments.event.getArg('speaker',0) />
		
		<cfreturn getProposalService().getProposalSpeakers(arguments.event.getArg('eventID'), arguments.event.getArg('statusId',0)) />
	</cffunction>
	
	<cffunction name="getProposalFavorites" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getProposalService().getProposalFavorites(arguments.event.getArg('eventID'), session.user.getUserID()) />
	</cffunction>
	
	<cffunction name="voteForProposal" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />

		<!--- make sure the user is voting using their user ID --->
		<cfif arguments.event.getArg('userID') neq session.user.getUserID()>
			<cfset redirectEvent("fail", "", true) />
		</cfif>
		
		<cfset message.text = "Your vote was recorded!" />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getProposalService().addVote(arguments.event.getArg("proposalID"), 
														session.user.getUserID()) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getUserVotes" access="public" output="false" returntype="string">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var userVotes = "" />
		
		<cfif StructKeyExists(session, "user")>
			<cfset userVotes = getProposalService().getUserVotes(session.user.getUserID()) />
		</cfif>
		
		<cfreturn userVotes />
	</cffunction>
		
	<cffunction name="processProposalForm" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var proposal = arguments.event.getArg('proposal') />
		<cfset var eventID = arguments.event.getArg('eventID') />
		<cfset var errors = StructNew() />
		<cfset var message = StructNew() />
		<cfset var uploadResults = 0 />
		<cfset var newProposal = proposal.getProposalID() eq 0 />
		<cfset var successEvent = "success" />

		<cfif proposal.getUserID() eq 0>
			<cfset proposal.setUserID(session.user.getUserID()) />
			<cfset successEvent = "newSuccess" />
		</cfif>
		
		<cfif newProposal>
			<cfset proposal.setCreatedBy(session.user.getUserID()) />
			<cfset proposal.setSessionTypeId(getSessionTypeService().getSessionTypeByTitle(eventID,"Regular Session").session_type_id) />
		<cfelse>
			<cfset proposal.setUpdatedBy(session.user.getUserID()) />
		</cfif>

		<!--- for some reason the user fields don't get set
				properly on Twitter accounts, so let's just
				set them all to be safe --->
		<cfscript>
			proposal.getUser().setAddress(arguments.event.getArg('user.address'));
			proposal.getUser().setBio(arguments.event.getArg('user.bio'));
			proposal.getUser().setCityStateZip(arguments.event.getArg('user.cityStateZip'));
			proposal.getUser().setCompany(arguments.event.getArg('user.company'));
			proposal.getUser().setEmail(arguments.event.getArg('user.email'));
			proposal.getUser().setName(arguments.event.getArg('user.name'));
			proposal.getUser().setPhone(arguments.event.getArg('user.phone'));
		</cfscript>

		<cfset errors = proposal.validate() />
		
		<cfset message.text = "The proposal was saved." />
		<cfset message.class = "success" />
		
		<cfif !StructIsEmpty(errors)>
			<cfset message.text = "Please correct the following errors:" />
			<cfset message.class = "error" />
			<cfset arguments.event.setArg("errors", errors) />
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("fail", "", true) />
		<cfelse>
			<cftry>
				<cfset getUserService().saveUser(proposal.getUser()) />
				<cfset getProposalService().saveProposal(proposal,session.user) />
				<cfset arguments.event.setArg("message", message) />
				<cfset arguments.event.setArg("proposalID", proposal.getProposalID()) />
				<!---<cfset getProposalService().updateRSSFeed(arguments.event.getArg('eventID'), getProperty('siteURL')) />--->
				<cfset redirectEvent(successEvent, "", true) />
				
				<cfcatch type="any">
					<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
					<cfset message.text = "A system error occurred:" />
					<cfset message.class = "error" />
					<cfset arguments.event.setArg("errors", errors) />
					<cfset arguments.event.setArg("message", message) />
					<cfset redirectEvent("fail", "", true) />
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteProposal" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The proposal was deleted." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset getProposalService().deleteProposal(arguments.event.getArg('proposal')) />
			<!---<cfset getProposalService().updateRSSFeed(arguments.event.getArg('eventID'), getProperty('siteURL')) />--->
			<cfset arguments.event.setArg("message", message) />
			<cfset redirectEvent("success", "", true) />
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="updateProposal" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var proposal = arguments.event.getArg('proposal') />
		<cfset var message = StructNew() />
		<cfset var errors = StructNew() />
		
		<cfset message.text = "The proposal was updated." />
		<cfset message.class = "success" />
		
		<cftry>
			<cfset proposal.setUpdatedBy(session.user.getUserID()) />
			<cfset getProposalService().saveProposal(proposal,session.user) />
			<cfset arguments.event.setArg("message", message) />
			<cfset arguments.event.setArg("proposalID", proposal.getProposalID()) />
			<cfset arguments.event.setArg("message", message) />
			<cfif not arguments.event.isArgDefined("comment")>
				<cfset redirectEvent("success", "", true) />
			</cfif>
			
			<cfcatch type="any">
				<cfset errors.systemError = CFCATCH.Message & " - " & CFCATCH.Detail />
				<cfset message.text = "A system error occurred:" />
				<cfset message.class = "error" />
				<cfset arguments.event.setArg("errors", errors) />
				<cfset arguments.event.setArg("message", message) />
				<cfset redirectEvent("fail", "", true) />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>