<cfoutput>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>cf.Objective() 2011: Topic Suggestion Survey and Call for Proposals - Get Involved!</title>
		<link rel="icon" href="/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="/css/default.css" type="text/css" media="all" />
		<link rel="stylesheet" href="/css/typography.css" type="text/css" media="all" />
		<link rel="stylesheet" href="/css/site.css" type="text/css" media="all" />
		<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
		<link type="text/css" href="/css/smoothness/jquery-ui-1.8.5.custom.css" rel="stylesheet" />
		<script type="text/javascript" src="/js/jquery-ui-1.8.5.custom.min.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js##xfbml=1"></script>
	<cfif event.getArg("includeTimePicker", false)>
		<script type="text/javascript" src="/js/timepicker.mod.js"></script>
	</cfif>
	<cfif event.getArg("includeTableSorter", false)>
		<link type="text/css" href="/css/blue/style.css" rel="stylesheet" />
		<script type="text/javascript" src="/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" src="/js/jquery.tablesorter.pager.js"></script>
	</cfif>
	<cfif event.getArg("includeCKEditor", false)>
		<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	</cfif>
	<cfif event.getArg("includeColorPicker", false)>
		<link type="text/css" href="/css/colorpicker.css" rel="stylesheet" />
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/colorpicker.js"></script>
		<script type="text/javascript" src="/js/eye.js"></script>
		<script type="text/javascript" src="/js/utils.js"></script>
	</cfif>
	<cfif event.getArg("includeConfirm", false)>
		<link type="text/css" href="/css/jquery.fastconfirm.css" rel="stylesheet" />
		<script type="text/javascript" src="/js/jquery.fastconfirm.js"></script>
		<script type="text/javascript">
			$(function(){
				$(".confirm").click(function() {
					$(this).fastConfirm({
						position: "right",
						onProceed: function(trigger) {
							window.location.href=$(trigger).attr("href");
						},
						onCancel: function(trigger) {
						}
					});
					return false;
				});
			});
		</script>
	</cfif>
		<!--[if IE]>
				<link rel="stylesheet" href="../css/ie.css" type="text/css" media="all" />
				<script src="../js/DD_roundies.js"></script>
				<script>
				  DD_roundies.addRule('##content,##sidebar', '5px');
				  /* string argument can be any CSS selector */
				</script>
		<![endif]-->
		<!--[if lte IE 6]>
				<script src="../js/DD_belatedPNG.js"></script>
				<script>
				  /* EXAMPLE */
				  DD_belatedPNG.fix('dd.rating, ##container');
				  /* string argument can be any CSS selector */
				</script>
		<![endif]-->
	</head>
	<body class="twoColSR">
		<div id="container">
			<div id="inner">
				<div id="header" class="clearfix">
					<div id="masthead">
						<ul id="navPrimary"> 
							<li class="first" id="navHome"><a href="http://www.cfobjective.com">Home</a></li>
							<li id="navVenue"><a href="http://www.cfobjective.com/index.cfm/venue/" >Venue</a></li>
							<li id="navTravel"><a href="http://www.cfobjective.com/index.cfm/travel/" >Travel</a></li>
							<li class="last" id="navSponsors"><a href="http://www.cfobjective.com/index.cfm/sponsors/" >Sponsors</a></li>
						</ul>
					</div> <!-- /masthead -->
				</div> <!-- /header -->
				<div id="content">
					<h1 class="pageTitle">cf.Objective() 2011</h1>
					#event.getArg('content')#
				</div> <!-- /content -->
				<div id="sidebar">
					<h2>Stuff To Do</h2>
						<cfif StructKeyExists(session, "user")>
							<cfif session.user.getOauthProvider() == "Facebook">
								<cfif structKeyExists(session.user.getUserInfo(),"picture")>
									<img src="#session.user.getUserInfo().picture#" /><br />
								</cfif>
								<span class="smaller">
									<a href="#session.user.getOauthProfileLink()#" target="_blank">#session.user.getUserInfo().name#</a><br />
									<a href="#BuildUrl('logout', 'facebookLogout=true')#">Logout</a><br /><br />
								</span>
							<cfelseif session.user.getOauthProvider() == "Twitter">
								<img src="#session.user.getUserInfo().profile_image_url#" /><br />
								<span class="smaller">
									#session.user.getUserInfo().name#<br />
									(<a href="#session.user.getOauthProfileLink()#" target="_blank">@#session.user.getUserInfo().screen_name#</a>)<br />
									<a href="#BuildUrl('logout')#">Logout</a><br /><br />
								</span>
							</cfif>
						<cfelse>
							<!--- Facebook login
							<fb:login-button perms="publish_stream,create_event,rsvp_event,offline_access,user_hometown,user_location,user_online_presence,user_status,user_website,email" autologoutlink="true"></fb:login-button>
							<div id="fb-root"></div>
							<script>
								window.fbAsyncInit = function() {
									FB.init({appId: '#getProperty('facebookKeys').applicationID#', 
												status: true, cookie: true, xfbml: true});
									FB.Event.subscribe('auth.sessionChange', function(response) {
										if (response.session) {
											// user logged in
											window.location.replace('/index.cfm/postLogin');
										} else {
											// user logged out
											window.location.replace('/index.cfm/login');
										}
									});
								<cfif !StructKeyExists(session, "user")>
									FB.logout(function(response){});
								</cfif>
								};
							  	(function() {
									var e = document.createElement('script');
									e.type = 'text/javascript';
									e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
									e.async = true;
									document.getElementById('fb-root').appendChild(e);
								}());
							</script>
							<br />
							--->
							<cfif !StructKeyExists(session, "user") || session.user.getOauthProvider() != "Twitter">
								<a href="#BuildUrl('postLogin', 'loginMethod=Twitter')#"><img src="/images/twitter_login.png" width="146" height="23" border="0" alt="Login With Twitter" title="Login With Twitter" /></a>
							<cfelse>
								<a href="#BuildUrl('logout')#"><img src="/images/twitter_logout.png" width="136" height="23" border="0" alt="Logout From Twitter" title="Logout From Twitter" /></a>
							</cfif>
						</cfif>

						<cfif not StructKeyExists(session, "user")>
							<p><strong><a href="#BuildUrl('login')#">Login</a></strong></p>
						</cfif>
						
						<p><strong><a href="#BuildUrl('main')#">Home</a></strong></p>
						
						<p><strong>Topic Survey</strong></p>
						<cfif StructKeyExists(session, "user")>
							<ul>
								<li><a href="#BuildUrl('topicSuggestions')#">Suggest,Vote and Comment on Topics</a></li>
								<li><a href="#BuildUrl('topicSuggestions', 'userID=#session.user.getUserID()#')#">My Topic Suggestions</a></li>
							</ul>
						<cfelse>
							<ul>
								<li><a href="#BuildUrl('topicSuggestions')#">View Topic Suggestions</a></li>
							</ul>
						</cfif>
						<p><strong>Call for Speakers</strong></p>
						<cfif StructKeyExists(session, "user")>
							<ul>
								<li><a href="#BuildUrl('proposalForm')#">Submit a Proposal</a></li>
								<li><a href="#BuildUrl('proposals')#">My Proposals</a></li>
							</ul>
						<cfelse>
							<ul>
								<li><a href="#BuildUrl('login')#">Login to propose to speak on a topic</a></li>
							</ul>
						</cfif>
					<cfif StructKeyExists(session, "user") && session.user.getIsAdmin()>
						<p><strong>Administer</strong></p>
						<ul>
							<li><a href="#BuildUrl('proposals')#">Proposals</a></li>
							<li><a href="#BuildUrl('proposals','comments=false')#">Proposals (no Comments)</a></li>
							<li><a href="#BuildUrl('admin.proposalComments')#">Recent Comments on Proposals</a></li>
							<li><a href="#BuildUrl('admin.users')#">Users</a></li>
							<li><a href="#BuildUrl('admin.topTopicPicks')#">Top Topic Picks</a></li>
						</ul>
					</cfif>
					<br />
					
				</div> <!-- /sidebar -->
				<div id="footer">
					<p>&copy; 2011 cf.Objective()</p>
				</div> <!-- /footer -->
			</div> <!-- /inner -->
		</div> <!-- /container -->
	</body>
</html>
</cfoutput>
