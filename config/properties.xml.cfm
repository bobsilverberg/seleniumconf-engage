<?xml version="1.0" encoding="UTF-8"?>
<!-- <cfsetting enablecfoutputonly="true" /> -->
<!DOCTYPE mach-ii PUBLIC "-//Mach-II//DTD Mach-II Configuration 1.9.0//EN"
	"http://www.mach-ii.com/dtds/mach-ii_1_9_0.dtd" >
<mach-ii version="1.9">
	<properties>
		<!-- datasource -->
		<property name="dsn" value="engage-cfo" />
		<!-- site URL -->
		<property name="siteURL" value="http://engage.cfobjective.com" />
		<!-- public events -->
		<property name="publicEvents" value="login,postLogin,twitterLoginCallback,main,logout,topicSuggestions,topicSuggestion,bugs" />
		<!-- social media app ids -->
		<property name="facebookKeys">
			<struct>
				<key name="applicationID" value="118337268228798" />
				<key name="apiKey" value="2b580976033f39f4eacf48901438b442" />
				<key name="applicationSecret" value="349e02a126431ecc4e71bd7df416bd69" />
			</struct>
		</property>
		<property name="twitterKeys">
			<struct>
				<key name="apiKey" value="iYtGa6eL4aroYj93HJC6mw" />
				<key name="consumerKey" value="iYtGa6eL4aroYj93HJC6mw" />
				<key name="consumerSecret" value="eDiN8thBOuWlqc30XcTrRAOV4ul0rtfRQGIUX4AGII" />
				<key name="requestTokenURL" value="https://api.twitter.com/oauth/request_token" />
				<key name="accessTokenURL" value="https://api.twitter.com/oauth/access_token" />
				<key name="authorizeURL" value="https://api.twitter.com/oauth/authorize" />
				<key name="oauthCallbackURL" value="http://local.engage/index.cfm?event=twitterLoginCallback" />
			</struct>
		</property>
	</properties>
</mach-ii>
