<?xml version="1.0" encoding="UTF-8"?>
<!-- <cfsetting enablecfoutputonly="true" /> -->
<beans>
	<!-- CATEGORY -->
	<bean id="categoryGateway" class="org.opencfsummit.engage.category.CategoryGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="categoryService" class="org.opencfsummit.engage.category.CategoryService">
		<property name="categoryGateway"><ref bean="categoryGateway" /></property>
	</bean>
	
	<!-- COMMENT -->
	<bean id="commentGateway" class="org.opencfsummit.engage.comment.CommentGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="commentService" class="org.opencfsummit.engage.comment.CommentService">
		<property name="commentGateway"><ref bean="commentGateway" /></property>
	</bean>
	
	<!-- EVENT -->
	<bean id="eventGateway" class="org.opencfsummit.engage.event.EventGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="eventService" class="org.opencfsummit.engage.event.EventService">
		<property name="eventGateway"><ref bean="eventGateway" /></property>
	</bean>
	
	<!-- LOOKUP -->
	<bean id="lookupGateway" class="org.opencfsummit.engage.lookup.LookupGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="lookupService" class="org.opencfsummit.engage.lookup.LookupService">
		<property name="lookupGateway"><ref bean="lookupGateway" /></property>
	</bean>
	
	<!-- PROPOSAL -->
	<bean id="proposalGateway" class="org.opencfsummit.engage.proposal.ProposalGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="proposalService" class="org.opencfsummit.engage.proposal.ProposalService">
		<property name="proposalGateway"><ref bean="proposalGateway" /></property>
		<property name="userService"><ref bean="userService" /></property>
	</bean>
	
	<!-- ROOM -->
	<bean id="roomGateway" class="org.opencfsummit.engage.room.RoomGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="roomService" class="org.opencfsummit.engage.room.RoomService">
		<property name="roomGateway"><ref bean="roomGateway" /></property>
	</bean>
	
	<!-- SCHEDULE ITEM -->
	<bean id="scheduleItemGateway" class="org.opencfsummit.engage.scheduleitem.ScheduleItemGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="scheduleItemService" class="org.opencfsummit.engage.scheduleitem.ScheduleItemService">
		<property name="scheduleItemGateway"><ref bean="scheduleItemGateway" /></property>
	</bean>
	
	<!-- SECURITY -->
	<bean id="securityGateway" class="org.opencfsummit.engage.security.SecurityGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="securityService" class="org.opencfsummit.engage.security.SecurityService">
		<property name="securityGateway"><ref bean="securityGateway" /></property>
	</bean>
	
	<!-- SESSION -->
	<bean id="sessionGateway" class="org.opencfsummit.engage.session.SessionGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="sessionService" class="org.opencfsummit.engage.session.SessionService">
		<property name="sessionGateway"><ref bean="sessionGateway" /></property>
		<property name="proposalService"><ref bean="proposalService" /></property>
	</bean>
	
	<!-- SESSION TYPE -->
	<bean id="sessionTypeGateway" class="org.opencfsummit.engage.sessiontype.SessionTypeGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="sessionTypeService" class="org.opencfsummit.engage.sessiontype.SessionTypeService">
		<property name="sessionTypeGateway"><ref bean="sessionTypeGateway" /></property>
	</bean>
	
	<!-- TOPIC SUGGESTION -->
	<bean id="topicSuggestionGateway" class="org.opencfsummit.engage.topicsuggestion.TopicSuggestionGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="topicSuggestionService" class="org.opencfsummit.engage.topicsuggestion.TopicSuggestionService">
		<property name="topicSuggestionGateway"><ref bean="topicSuggestionGateway" /></property>
	</bean>
	
	<!-- TRACK -->
	<bean id="trackGateway" class="org.opencfsummit.engage.track.TrackGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="trackService" class="org.opencfsummit.engage.track.TrackService">
		<property name="trackGateway"><ref bean="trackGateway" /></property>
	</bean>
	
	<!-- USER -->
	<bean id="userGateway" class="org.opencfsummit.engage.user.UserGateway">
		<property name="dsn"><value>${dsn}</value></property>
	</bean>
	
	<bean id="userService" class="org.opencfsummit.engage.user.UserService">
		<property name="userGateway"><ref bean="userGateway" /></property>
	</bean>
	
</beans>