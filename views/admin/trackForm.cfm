<cfsilent>
	<cfimport prefix="form" taglib="/MachII/customtags/form" />
	<cfset copyToScope("${event.track}") />
</cfsilent>
<cfoutput>
<script type="text/javascript">
	$(function() {
		$('##color').ColorPicker({
			onSubmit: function(hsb, hex, rgb, el) {
				$(el).val(hex);
				$(el).ColorPickerHide();
			}, 
			onBeforeShow: function() {
				$(this).ColorPickerSetColor(this.value);
			}
		})
		.bind('keyup', function() {
			$(this).ColorPickerSelectorColor(this.value);
		});
	});
</script>
	
<cfif track.getTrackID() eq 0>
<h3>Create New Track</h3>
<cfelse>
<h3>Edit Track - #track.getTitle()#</h3>
</cfif>

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

<form:form actionEvent="admin.processTrackForm" bind="track">
<table border="0" width="100%">
	<tr>
		<td align="right">Title</td>
		<td>
			<form:input path="title" size="70" maxlength="255" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Excerpt</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="excerpt" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td colspan="2">Description</td>
	</tr>
	<tr>
		<td colspan="2">
			<form:textarea class="ckeditor" path="description" cols="80" rows="10" />
		</td>
	</tr>
	<tr>
		<td align="right">Color</td>
		<td><form:input path="color" maxlength="6" /></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><form:button name="submit" value="Submit" /></td>
	</tr>
</table>
	<form:hidden path="trackID" />
</form:form>
</cfoutput>
