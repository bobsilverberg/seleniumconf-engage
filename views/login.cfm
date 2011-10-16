<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
</cfsilent>
<cfoutput>
<h3>Login</h3>

<cfif event.isArgDefined('message')>
	<cfset message = event.getArg('message') />
	<cfset errors = event.getArg('errors') />
	<div id="message" class="#message.class#">
		<h4>#message.text#</h4>
		<ul>
		<cfloop collection="#errors#" item="error">
			<li>#errors[error]#</li>
		</cfloop>
		</ul>
	</div>
</cfif>

<h4>Log in to the Topic Survey using your Facebook or Twitter account!</h4>

<table border="0">
	<tr>
		<td>
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
				<cfif event.getArg("facebookLogout", false)>
					FB.logout(function(response) {});
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
		</td>
		<td>
			<cfif !StructKeyExists(session, "user") || session.user.getOauthProvider() != "Twitter">
				<a href="#BuildUrl('postLogin', 'loginMethod=Twitter')#"><img src="/images/twitter_login.png" width="146" height="23" border="0" alt="Login With Twitter" title="Login With Twitter" /></a>
			<cfelse>
				<a href="#BuildUrl('logout')#"><img src="/images/twitter_logout.png" width="136" height="23" border="0" alt="Logout From Twitter" title="Logout From Twitter" /></a>
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>
