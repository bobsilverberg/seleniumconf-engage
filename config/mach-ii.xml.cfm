<?xml version="1.0" encoding="UTF-8"?>
<!-- <cfsetting enablecfoutputonly="true" /> -->
<!DOCTYPE mach-ii PUBLIC "-//Mach-II//DTD Mach-II Configuration 1.9.0//EN"
	"http://www.mach-ii.com/dtds/mach-ii_1_9_0.dtd" >

<mach-ii version="1.9">
	<!-- INCLUDES -->
	<includes>
		<include file="./mach-ii_coldspringProperty.xml.cfm" />
		<include file="./properties.xml.cfm" />
	</includes>

	<!-- MODULES -->
	<modules>
		<module name="dashboard" file="/MachIIDashboard/config/mach-ii_dashboard.xml">
			<mach-ii>
				<properties>
					<property name="password" value="3ngag3" />
				</properties>
			</mach-ii>
		</module>
	</modules>
	
	<!-- PROPERTIES -->
	<properties>
		<property name="applicationRoot" value="/" />
		<property name="defaultEvent" value="main" />
		<property name="eventParameter" value="event" />
		<property name="parameterPrecedence" value="form" />
		<property name="maxEvents" value="10" />
		<property name="exceptionEvent" value="exception" />
		<property name="urlParseSES" value="true" />
		<property name="urlDelimiters" value="/|/|/" />
		<property name="urlBase" value="/index.cfm" />
		<property name="urlExcludeEventParameter" value="true" />
		
		<!-- CACHING RELATED -->
		<!-- this will create an unnamed cache that caches data for 1 hour in the application scope -->
		<!-- <property name="caching" type="MachII.caching.CachingProperty" /> -->
		
		<!-- LOGGING RELATED -->
		<!-- this will log to the screen -->
		<!-- <property name="logging" type="MachII.logging.LoggingProperty" /> -->
	</properties>

	<!-- LISTENERS -->
	<listeners>
		<listener name="commentListener" type="org.opencfsummit.engage.listeners.CommentListener" />
		<listener name="categoryListener" type="org.opencfsummit.engage.listeners.CategoryListener" />
		<listener name="eventListener" type="org.opencfsummit.engage.listeners.EventListener" />
		<listener name="proposalListener" type="org.opencfsummit.engage.listeners.ProposalListener" />
		<listener name="roomListener" type="org.opencfsummit.engage.listeners.RoomListener" />
		<listener name="sessionListener" type="org.opencfsummit.engage.listeners.SessionListener" />
		<listener name="sessionTypeListener" type="org.opencfsummit.engage.listeners.SessionTypeListener" />
		<listener name="scheduleItemListener" type="org.opencfsummit.engage.listeners.ScheduleItemListener" />
		<listener name="topicSuggestionListener" type="org.opencfsummit.engage.listeners.TopicSuggestionListener" />
		<listener name="trackListener" type="org.opencfsummit.engage.listeners.TrackListener" />
		<listener name="userListener" type="org.opencfsummit.engage.listeners.UserListener" />
	</listeners>

	<!-- EVENT-FILTERS -->
	<event-filters>
		<event-filter name="proposalFilter" type="org.opencfsummit.engage.filters.ProposalFilter" />
		<event-filter name="userFormFilter" type="org.opencfsummit.engage.filters.UserFormFilter" />
	</event-filters>
	
	<!-- PLUGINS -->
	<plugins>
		<plugin name="eventIDPlugin" type="org.opencfsummit.engage.plugins.EventIDPlugin" />
		<plugin name="userPlugin" type="org.opencfsummit.engage.plugins.UserPlugin" />
	</plugins>
	
	<!-- EVENT-HANDLERS -->
	<event-handlers>
		<event-handler event="admin.home" access="public">
			<view-page name="admin.home" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<!-- login -->
		<event-handler event="login" access="public">
			<view-page name="login" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="postLogin" access="public">
			<event-mapping event="fail" mapping="login" />
			<notify listener="userListener" method="login" />
		</event-handler>
		
		<event-handler event="twitterLoginCallback" access="public">
			<event-mapping event="fail" mapping="login" />
			<notify listener="userListener" method="twitterLoginCallback" />
		</event-handler>
		
		<event-handler event="logout" access="public">
			<notify listener="userListener" method="logout" />
		</event-handler>
		
		<!-- public user events -->
		<event-handler event="main" access="public">
			<view-page name="main" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<!-- comment management -->
		<event-handler event="processCommentForm" access="public">
			<event-bean name="comment" type="org.opencfsummit.engage.comment.Comment" />
			<notify listener="commentListener" method="processCommentForm" />
		</event-handler>
		
		<event-handler event="deleteComment" access="public">
			<event-bean name="comment" type="org.opencfsummit.engage.comment.Comment" />
			<notify listener="commentListener" method="deleteComment" />
		</event-handler>
		
		<!-- event management -->
		<event-handler event="admin.events" access="public">
			<call-method bean="eventService" method="getEvents" resultArg="events" />
			<view-page name="admin.events" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.event" access="public">
			<call-method bean="eventService" method="getEvent" args="${event.eventID}" resultArg="theEvent" />
			<call-method bean="eventService" method="getEvents" resultArg="events" />
			<call-method bean="eventService" method="getParentEvent" args="${event.eventID}" resultArg="parentEvent" />
			<call-method bean="eventService" method="getChildEvents" args="${event.eventID}" resultArg="childEvents" />
			<view-page name="admin.event" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.eventForm" access="public">
			<event-arg name="includeTimePicker" value="true" />
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="eventService" method="getEvent" args="${event.eventID}" resultArg="theEvent" overwrite="false" />
			<call-method bean="eventService" method="getEvents" resultArg="events" />
			<call-method bean="eventService" method="getChildEvents" args="${event.eventID}" resultArg="childEvents" />
			<view-page name="admin.eventForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processEventForm" access="public">
			<event-mapping event="success" mapping="admin.events" />
			<event-mapping event="fail" mapping="admin.eventForm" />
			<event-bean name="theEvent" type="org.opencfsummit.engage.event.Event">
				<field name="startDate" ignore="true" />
				<field name="endDate" ignore="true" />
				<field name="proposalDeadline" ignore="true" />
			</event-bean>
			<notify listener="eventListener" method="processEventForm" />
		</event-handler>
		
		<event-handler event="admin.deleteEvent" access="public">
			<event-mapping event="success" mapping="admin.events" />
			<event-mapping event="fail" mapping="admin.events" />
			<event-bean name="theEvent" type="org.opencfsummit.engage.event.Event" />
			<notify listener="eventListener" method="deleteEvent" />
		</event-handler>
		
		<!-- proposal management -->
		<event-handler event="proposals" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<notify listener="proposalListener" method="getProposals" resultArg="proposals" />
			<call-method bean="proposalService" method="getProposalTags" resultArg="proposalTags" />
			<call-method bean="proposalService" method="getProposalStatuses" resultArg="proposalStatuses" />
			<call-method bean="trackService" method="getTracks" args="${event.eventID}" resultArg="tracks" />
			<view-page name="proposals" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.acceptanceLetters" access="public">
			<call-method bean="proposalService" method="getAcceptedProposals" resultArg="proposals" />
			<view-page name="acceptanceLetters" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.updateProposalsRSS" access="public">
			<call-method bean="proposalService" method="updateRSSFeed" resultArg="proposals" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.rejectionLetters" access="public">
			<call-method bean="proposalService" method="getRejectedProposals" resultArg="proposals" />
			<view-page name="rejectionLetters" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="proposal" access="public">
			<filter name="proposalFilter" />
			<event-arg name="includeCKEditor" value="true" />
			<event-arg name="includeConfirm" value="true" />
			<notify listener="commentListener" method="getComments" resultArg="comments" />
			<call-method bean="commentService" method="getComment" args="${event.commentID:0}" resultArg="comment" overwrite="false" />
			<call-method bean="proposalService" method="getProposal" args="${event.proposalID}" resultArg="proposal" />
			<call-method bean="proposalService" method="getProposalStatuses" resultArg="proposalStatuses" />
			<call-method bean="sessionTypeService" method="getSessionTypes" args="${event.eventID}" resultArg="sessionTypes" />
			<call-method bean="lookupService" method="getSkillLevels" resultArg="skillLevels" />
			<call-method bean="trackService" method="getTracks" args="${event.eventID}" resultArg="tracks" />
			<view-page name="commentForm" contentArg="commentForm" />
			<view-page name="proposal" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="proposalForm" access="public">
			<filter name="proposalFilter" />
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="proposalService" method="getProposal" args="${event.proposalID:0}" resultArg="proposal" overwrite="false" />
			<call-method bean="proposalService" method="getProposalStatuses" resultArg="proposalStatuses" />
			<call-method bean="sessionTypeService" method="getSessionTypes" args="${event.eventID}" resultArg="sessionTypes" />
			<call-method bean="lookupService" method="getSkillLevels" resultArg="skillLevels" />
			<call-method bean="trackService" method="getTracks" args="${event.eventID}" resultArg="tracks" />
			<view-page name="proposalForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="processProposalForm" access="public">
			<filter name="proposalFilter" />
			<event-mapping event="newsuccess" mapping="proposalSubmissionConfirmation" />
			<event-mapping event="success" mapping="proposals" />
			<event-mapping event="fail" mapping="proposalForm" />
			<call-method bean="proposalService" method="getProposal" args="${event.proposalID:0}" resultArg="proposal" overwrite="true" />
			<event-bean name="proposal" type="org.opencfsummit.engage.proposal.Proposal" autopopulate="true" reinit="false" />
			<notify listener="proposalListener" method="processProposalForm" />
		</event-handler>
		
		<event-handler event="proposalSubmissionConfirmation" access="public">
			<call-method bean="eventService" method="getEvent" args="${event.eventID}" resultArg="theEvent" />
			<view-page name="proposalSubmissionConfirmation" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="deleteProposal" access="public">
			<filter name="proposalFilter" />
			<event-mapping event="success" mapping="proposals" />
			<event-mapping event="fail" mapping="proposals" />
			<event-bean name="proposal" type="org.opencfsummit.engage.proposal.Proposal" />
			<notify listener="proposalListener" method="deleteProposal" />
		</event-handler>
		
		<event-handler event="admin.updateProposal" access="public">
			<event-mapping event="success" mapping="proposal" />
			<event-mapping event="fail" mapping="proposal" />
			<call-method bean="proposalService" method="getProposal" args="${event.proposalID:0}" resultArg="proposal" overwrite="true" />
			<event-bean name="proposal" type="org.opencfsummit.engage.proposal.Proposal" autopopulate="true" reinit="false" />
			<notify listener="proposalListener" method="updateProposal" />
		</event-handler>
		
		<event-handler event="admin.scoreAndComment" access="public">
			<event-mapping event="success" mapping="proposals" />
			<event-mapping event="fail" mapping="proposals" />
			<call-method bean="proposalService" method="getProposal" args="${event.proposalID:0}" resultArg="proposal" overwrite="true" />
			<event-bean name="proposal" type="org.opencfsummit.engage.proposal.Proposal" autopopulate="true" reinit="false" />
			<notify listener="proposalListener" method="updateProposal" />
 			<announce event="processCommentForm" copyEventArgs="true" />
 		</event-handler>
		
		<event-handler event="admin.proposalScores" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<notify listener="proposalListener" method="getProposalScores" resultArg="proposals" />
			<call-method bean="proposalService" method="getProposalTags" resultArg="proposalTags" />
			<view-page name="proposalScores" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.proposalComments" access="public">
			<call-method bean="proposalService" method="getProposalComments" args="${event.eventID}" resultArg="proposals" />
			<view-page name="proposalComments" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.speakers" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<notify listener="proposalListener" method="getProposalSpeakers" resultArg="speakers" />
			<call-method bean="proposalService" method="getProposalStatuses" resultArg="proposalStatuses" />
			<view-page name="speakers" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<!-- room management -->
		<event-handler event="admin.rooms" access="public">
			<call-method bean="roomService" method="getRooms" args="${event.eventID}" resultArg="rooms" />
			<view-page name="admin.rooms" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.room" access="public">
			<call-method bean="roomService" method="getRoom" args="${event.roomID}" resultArg="room" />
			<view-page name="admin.room" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.roomForm" access="public">
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="roomService" method="getRoom" args="${event.roomID:0}" resultArg="room" overwrite="false" />
			<view-page name="admin.roomForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processRoomForm" access="public">
			<event-mapping event="success" mapping="admin.rooms" />
			<event-mapping event="fail" mapping="admin.roomForm" />
			<event-bean name="room" type="org.opencfsummit.engage.room.Room" />
			<notify listener="roomListener" method="processRoomForm" />
		</event-handler>
		
		<event-handler event="admin.deleteRoom" access="public">
			<event-mapping event="success" mapping="admin.rooms" />
			<event-mapping event="fail" mapping="admin.rooms" />
			<event-bean name="room" type="org.opencfsummit.engage.room.Room" />
			<notify listener="roomListener" method="deleteRoom" />
		</event-handler>
		
		<!-- schedule item management -->
		<event-hander event="admin.scheduleItems" access="public">
			<call-method bean="scheduleItemService" method="getScheduleItems" args="${event.eventID}" resultArg="scheduleItems" />
			<view-page name="admin.scheduleItems" contentArg="content" />
			<execute subroutine="template.main" />
		</event-hander>
		
		<event-handler event="admin.scheduleItem" access="public">
			<call-method bean="scheduleItemService" method="getScheduleItem" args="${event.scheduleItemID}" resultArg="scheduleItem" />
			<view-page name="admin.scheduleItem" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.scheduleItemForm" access="public">
			<event-arg name="includeTimePicker" value="true" />
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="roomService" method="getRooms" args="${event.eventID}" resultArg="rooms" />
			<call-method bean="scheduleItemService" method="getScheduleItem" args="${event.scheduleItemID:0}" resultArg="scheduleItem" 
						overwrite="false" />
			<view-page name="admin.scheduleItemForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processScheduleItemForm" access="public">
			<event-mapping event="success" mapping="admin.scheduleItems" />
			<event-mapping event="fail" mapping="admin.scheduleItemForm" />
			<event-bean name="scheduleItem" type="org.opencfsummit.engage.scheduleitem.ScheduleItem">
				<field name="startDate" ignore="true" />
			</event-bean>
			<notify listener="scheduleItemListener" method="processScheduleItemForm" />
		</event-handler>
		
		<event-handler event="admin.deleteScheduleItem" access="public">
			<event-mapping event="success" mapping="admin.scheduleItems" />
			<event-mapping event="fail" mapping="admin.scheduleItems" />
			<event-bean name="scheduleItem" type="org.opencfsummit.engage.scheduleitem.ScheduleItem" />
			<notify listener="scheduleItemListener" method="deleteScheduleItem" />
		</event-handler>
		
		<!-- session management -->
		<event-handler event="admin.sessions" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<call-method bean="sessionService" method="getSessions" args="${event.eventID}" resultArg="sessions" />
			<view-page name="admin.sessions" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.session" access="public">
			<call-method bean="sessionService" method="getSession" args="${event.sessionID}" resultArg="theSession" />
			<view-page name="admin.session" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.sessionForm" access="public">
			<event-arg name="includeTimePicker" value="true" />
			<call-method bean="sessionService" method="getSession" args="${event.sessionID:0}" resultArg="theSession" overwrite="false" />
			<call-method bean="proposalService" method="getProposals" args="${event.eventID}" resultArg="proposals" />
			<call-method bean="proposalService" method="getProposalStatuses" resultArg="proposalStatuses" />
			<call-method bean="roomService" method="getRooms" args="${event.eventID}" resultArg="rooms" />
			<view-page name="admin.sessionForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processSessionForm" access="public">
			<event-mapping event="success" mapping="admin.sessions" />
			<event-mapping event="fail" mapping="admin.sessionForm" />
			<event-bean name="theSession" type="org.opencfsummit.engage.session.Session">
				<field name="sessionTime" ignore="true" />
			</event-bean>
			<notify listener="sessionListener" method="processSessionForm" />
		</event-handler>
		
		<event-handler event="admin.deleteSession" access="public">
			<event-mapping event="success" mapping="admin.sessions" />
			<event-mapping event="fail" mapping="admin.sessions" />
			<event-bean name="theSession" type="org.opencfsummit.engage.session.Session" />
			<notify listener="sessionListener" method="deleteSession" />
		</event-handler>
		
		<!-- session type management -->
		<event-handler event="admin.sessionTypes" access="public">
			<call-method bean="sessionTypeService" method="getSessionTypes" args="${event.eventID}" resultArg="sessionTypes" />
			<view-page name="admin.sessionTypes" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.sessionType" access="public">
			<call-method bean="sessionTypeService" method="getSessionType" args="${event.sessionTypeID}" resultArg="sessionType" />
			<view-page name="admin.sessionType" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.sessionTypeForm" access="public">
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="sessionTypeService" method="getSessionType" args="${event.sessionTypeID:0}" resultArg="sessionType" 
						overwrite="false" />
			<view-page name="admin.sessionTypeForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processSessionTypeForm" access="public">
			<event-mapping event="success" mapping="admin.sessionTypes" />
			<event-mapping event="fail" mapping="admin.sessionTypeForm" />
			<event-bean name="sessionType" type="org.opencfsummit.engage.sessiontype.SessionType" />
			<notify listener="sessionTypeListener" method="processSessionTypeForm" />
		</event-handler>
		
		<event-handler event="admin.deleteSessionType" access="public">
			<event-mapping event="success" mapping="admin.sessionTypes" />
			<event-mapping event="fail" mapping="admin.sessionTypes" />
			<event-bean name="sessionType" type="org.opencfsummit.engage.sessiontype.SessionType" />
			<notify listener="sessionTypeListener" method="deleteSessionType" />
		</event-handler>

		<!-- topic suggestion management -->
		<event-handler event="topicSuggestions" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<call-method bean="topicSuggestionService" method="getTopicSuggestions" args="${event.eventID},${event.userId:0}" resultArg="topicSuggestions" />
			<notify listener="topicSuggestionListener" method="getUserVotes" resultArg="userVotes" />
			<call-method bean="topicSuggestionService" method="getTopicSuggestionBean" resultArg="topicSuggestion" overwrite="true" />
			<view-page name="topicSuggestionForm" contentArg="content" />
			<view-page name="topicSuggestions" contentArg="content" append="true" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="topicSuggestion" access="public">
			<event-arg name="includeCKEditor" value="true" />
			<event-arg name="includeConfirm" value="true" />
			<notify listener="commentListener" method="getComments" resultArg="comments" />
			<call-method bean="commentService" method="getComment" args="${event.commentID:0}" resultArg="comment" overwrite="false" />
			<call-method bean="topicSuggestionService" method="getTopicSuggestion" args="${event.topicSuggestionID}" resultArg="topicSuggestion" />
			<notify listener="topicSuggestionListener" method="getUserVotes" resultArg="userVotes" />
			<view-page name="commentForm" contentArg="commentForm" />
			<view-page name="topicSuggestion" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="voteForTopicSuggestion" access="public">
			<event-mapping event="success" mapping="topicSuggestion" />
			<event-mapping event="fail" mapping="topicSuggestion" />
			<notify listener="topicSuggestionListener" method="voteForTopicSuggestion" />
		</event-handler>
		
		<event-handler event="topicSuggestionFavorites" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<notify listener="topicSuggestionListener" method="getTopicSuggestionFavorites" resultArg="topicSuggestions" />
			<view-page name="topicSuggestionFavorites" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>

		<event-handler event="topicSuggestionForm" access="public">
			<event-arg name="includeCKEditor" value="true" />
			<call-method bean="topicSuggestionService" method="getTopicSuggestion" args="${event.topicSuggestionID:0}" 
							resultArg="topicSuggestion" overwrite="false" />
			<view-page name="topicSuggestionForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="topicSuggestionMergeForm" access="public">
			<call-method bean="topicSuggestionService" method="getTopicSuggestion" args="${event.topicSuggestionID:0}" 
							resultArg="topicSuggestion" overwrite="false" />
			<call-method bean="topicSuggestionService" method="getTopicSuggestions" args="${event.eventID}" resultArg="topicSuggestions" />
			<view-page name="topicSuggestionMergeForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="processTopicSuggestionForm" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestionForm" />
			<event-bean name="topicSuggestion" type="org.opencfsummit.engage.topicsuggestion.TopicSuggestion" />
			<notify listener="topicSuggestionListener" method="processTopicSuggestionForm" />
		</event-handler>
		
		<event-handler event="processTopicSuggestionMergeForm" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestionMergeForm" />
			<notify listener="topicSuggestionListener" method="processTopicSuggestionMergeForm" />
		</event-handler>
		
		<event-handler event="processTopicSuggestionVotes" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestions" />
			<notify listener="topicSuggestionListener" method="processTopicSuggestionVotes" />
		</event-handler>
		
		<event-hander event="deleteTopicSuggestion" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestions" />
			<event-bean name="topicSuggestion" type="org.opencfsummit.engage.topicsuggestion.TopicSuggestion" />
			<notify listener="topicSuggestionListener" method="deleteTopicSuggestion" />
		</event-hander>
		
		<event-handler event="tweetForUser" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestions" />
			<notify listener="topicSuggestionListener" method="tweetForUser" />
		</event-handler>
		
		<event-handler event="addWallPostForUser" access="public">
			<event-mapping event="success" mapping="topicSuggestions" />
			<event-mapping event="fail" mapping="topicSuggestions" />
			<notify listener="topicSuggestionListener" method="addWallPostForUser" />
		</event-handler>
		
		<event-handler event="admin.topTopicPicks" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<call-method bean="topicSuggestionService" method="getTopPicks" args="${event.eventID}" resultArg="topPicks" />
			<view-page name="admin.topTopicPicks" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<!-- track management -->
		<event-handler event="admin.tracks" access="public">
			<call-method bean="eventService" method="getTracksText" args="${event.eventID}" resultArg="tracksText" />
			<call-method bean="trackService" method="getTracks" args="${event.eventID}" resultArg="tracks" />
			<view-page name="admin.tracks" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.track" access="public">
			<call-method bean="trackService" method="getTrack" args="${event.trackID}" resultArg="track" />
			<view-page name="admin.track" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.trackForm" access="public">
			<event-arg name="includeCKEditor" value="true" />
			<event-arg name="includeColorPicker" value="true" />
			<call-method bean="trackService" method="getTrack" args="${event.trackID:0}" resultArg="track" overwrite="false" />
			<view-page name="admin.trackForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="admin.processTrackForm" access="public">
			<event-mapping event="success" mapping="admin.tracks" />
			<event-mapping event="fail" mapping="admin.trackForm" />
			<event-bean name="track" type="org.opencfsummit.engage.track.Track" />
			<notify listener="trackListener" method="processTrackForm" />
		</event-handler>
		
		<event-handler event="admin.deleteTrack" access="public">
			<event-mapping event="success" mapping="admin.tracks" />
			<event-mapping event="fail" mapping="admin.tracks" />
			<event-bean name="track" type="org.opencfsummit.engage.track.Track" />
			<notify listener="trackListener" method="deleteTrack" />
		</event-handler>
		
		<!-- user management -->
		<event-handler event="admin.users" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<call-method bean="userService" method="getUsers" resultArg="users" />
			<view-page name="admin.users" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>

		<event-handler event="admin.userVotes" access="public">
			<event-arg name="includeTableSorter" value="true" />
			<call-method bean="userService" method="getUserVotes" args="${event.userID:0}" resultArg="userVotes" />
			<view-page name="admin.userVotes" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>

		<event-handler event="userForm" access="public">
			<filter name="userFormFilter" />
			<call-method bean="userService" method="getUser" args="${event.userID:0}" resultArg="user" overwrite="false" />
			<view-page name="userForm" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
		
		<event-handler event="processUserForm" access="public">
			<filter name="userFormFilter" />
			<event-mapping event="success" mapping="admin.users" />
			<event-mapping event="fail" mapping="userForm" />
			<event-bean name="user" type="org.opencfsummit.engage.user.User">
				<field name="isAdmin" ignore="true" />
				<field name="isActive" ignore="true" />
			</event-bean>>
			<notify listener="userListener" method="processUserForm" />
		</event-handler>
		
		<!-- exception -->
		<event-handler event="exception" access="private">
			<view-page name="exception" contentArg="content" />
			<execute subroutine="template.main" />
		</event-handler>
	</event-handlers>
	
	<!-- SUBROUTINES -->
	<subroutines>
		<subroutine name="template.main">
			<view-page name="templates.main" />
		</subroutine>
	</subroutines>
	
	<!-- PAGE-VIEWS -->
	<page-views>
		<view-loader type="MachII.framework.viewLoaders.PatternViewLoader">
			<parameter name="pattern" value="/views/**/*.cfm" />
		</view-loader>
	</page-views>
	
</mach-ii>