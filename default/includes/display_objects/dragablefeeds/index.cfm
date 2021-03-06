<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfsilent>
	<cfset rbFactory=$.siteConfig("rbFactory")>
	<cfset loadJSLib() />
	<cfset $.addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds.cfm") />
	<cfswitch expression="#$.getJsLib()#">
		<cfcase value="jquery">
			<cfset $.addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds-jquery.cfm") />
		</cfcase>
		<cfdefaultcase>
			<cfset $.addToHTMLHeadQueue("dragablefeeds/htmlhead/dragablefeeds-prototype.cfm") />
		</cfdefaultcase>
	</cfswitch>

	<cfset defaultFeeds = application.feedManager.getDefaultFeeds($.event('siteID')) />
	<cfset remoteFeeds = application.feedManager.getFeeds($.event('siteID'), "remote",true) />
	<cfset localFeeds = application.feedManager.getFeeds($.event('siteID'), "local",true) />

	<cfquery dbtype="query" name="reorderedDefaultFeeds">
		SELECT * 
		FROM defaultFeeds
		WHERE isActive = 1
		ORDER BY name DESC
	</cfquery>
</cfsilent>
<cfoutput>
	<div class="row">
		<div class="col-lg-12">
			<div id="svRSSFeeds">
				<cfif not len(getPersonalizationID()) and application.settingsManager.getSite($.event('siteID')).getExtranetPublicReg() eq 1>
					<p class="rssBlurb"><a class="btn btn-default" href="#application.settingsManager.getSite($.event('siteID')).getLoginURL()#&returnURL=#URLEncodedFormat(application.contentRenderer.getCurrentURL())#">#$.rbKey('dragablefeeds.createaccount')#</a></p>
				</cfif>
			</div>
		</div>
	</div>

	<!--- Want More Feeds? --->
	<#$.getHeaderTag('subHead2')# class="addFeeds">
		#$.rbKey('dragablefeeds.wantmore')#
	</#$.getHeaderTag('subHead2')#>

	<!--- Add New Feeds --->
	<div id="svAddNewFeed" class="well clearfix">
		<!--- The Form --->
		<form role="form" class="form-horizontal" method="post">
			<!--- Select a Feed --->
			<div class="col-lg-6">
				<fieldset id="rssInternal">
					<div class="row">
						<legend>#$.rbKey('dragablefeeds.selectafeed')#</legend>
						<!--- Select a Feed Menu --->
						<div class="form-group">
							<div class="col-lg-10">
								<label class="sr-only" for="rssURL">#HTMLEditFormat($.rbKey('dragablefeeds.selectafeed'))#</label>
								<select class="form-control" id="rssURL" name="rssURL">
									<option value="">#HTMLEditFormat($.rbKey('dragablefeeds.selectafeed'))#</option>
									<optgroup label="Our Favorites">
										<cfloop query="remoteFeeds">
											<cfset feedLink = "#channelLink#">
											<option value="#feedLink#">#name#</option>
										</cfloop>
									<optgroup label="#rbFactory.getResourceBundle().messageFormat($.rbKey('dragablefeeds.sitefeeds'),getSite().getSite())#">
										<cfloop query="localFeeds">
											<cfset feedLink = "http://#application.settingsManager.getSite($.event('siteID')).getDomain()##application.configBean.getServerPort()##$.globalConfig('context')#/tasks/feed/?feedID=#feedID#">
											<option value="#feedLink#">#name#</option>
										</cfloop>
								</select>
							</div>
						</div>
						<!--- Add Feed Button --->
						<div class="form-group">
							<div class="col-lg-2">
								<button class="btn btn-default" type="button" onclick="createFeed(this.form)" value="Create">
									#HTMLEditFormat($.rbKey('dragablefeeds.addfeed'))#
								</button>
							</div>
						</div>
					</div>
				</fieldset>
			</div>

			<!--- Add Your Own Feed --->
			<div class="col-lg-6">
				<fieldset id="rssExternal">
					<div class="row">
						<legend>#$.rbKey('dragablefeeds.addyourown')#</legend>
						<!--- URL --->
						<div class="form-group">
							<div class="col-lg-10">
								<label class="sr-only" for="rssURLtext">URL</label>
								<input class="form-control" type="text" name="rssURLtext" size="30" value="" maxlength="255" placeholder="URL">
							</div>
						</div>
						<!--- Add Feed Button --->
						<div class="form-group">
							<div class="col-lg-2">
								<button class="btn btn-default" type="button" onclick="createFeed(this.form)" value="Create">
									#HTMLEditFormat($.rbKey('dragablefeeds.addfeed'))#
								</button>
							</div>
						</div>
					</div>
				</fieldset>
			</div>
		</form>
	</div>

	<script type="text/javascript">
		var siteID="#$.event('siteID')#";
		var appContext="#$.globalConfig('context')#";
		addLoadEvent(initDragableBoxesScript);
		
		<cfif len(getPersonalizationID())>
			<cfset userFeeds = application.favoriteManager.getFavorites(getPersonalizationID(), "RSS", $.event('siteID'))>
			userID = "#getPersonalizationID()#";
			siteID = "#$.event('siteID')#";
			<cfif userFeeds.recordCount gt 0 >
				function createBoxes(){
				<cfloop query="userFeeds">
					//user
					createARSSBox('#favorite#','#columnNumber#',false,'#maxRssItems#',20);
				</cfloop>
				}
			<cfelse>
				<cfset middle = defaultFeeds.recordCount / 2>
				<cfset feedIndex = 1>
				function createBoxes(){
				<cfloop query="defaultFeeds">
					<cfif feedIndex lte middle>
						<cfset columnNumber = 1>
					<cfelse>
						<cfset columnNumber = 2>
					</cfif>
					<cfif type eq "Local">
						<cfset feedLink = "http://#application.settingsManager.getSite($.event('siteID')).getDomain()##application.configBean.getServerPort()##$.globalConfig('context')#/tasks/feed/?feedID=#feedID#">
					<cfelse>
						<cfset feedLink = "#channelLink#">
					</cfif>
					// default non user
					createARSSBox('#feedLink#','#columnNumber#',false,5,60);
					<cfset feedIndex = feedIndex + 1>
				</cfloop>
				}
			</cfif>
		<cfelse>
			<!---<cfdump var="#defaultFeeds#">--->
			<cfset middle = defaultFeeds.recordCount / 2>
			<cfset feedIndex = 1>
			function createBoxes(){
			<cfloop query="reorderedDefaultFeeds">
				<cfif feedIndex gt middle>
					<cfset columnNumber = 1>
				<cfelse>
					<cfset columnNumber = 2>
				</cfif>
				<cfif type eq "Local">
					<cfset feedLink = "http://#application.settingsManager.getSite($.event('siteID')).getDomain()##application.configBean.getServerPort()##$.globalConfig('context')#/tasks/feed/?feedID=#feedID#">
				<cfelse>
					<cfset feedLink = "#channelLink#">
				</cfif>
				// default
				createARSSBox('#feedLink#','#columnNumber#',false,5,60);
				<cfset feedIndex = feedIndex + 1>
			</cfloop>
			}
		</cfif>
	</script>
</cfoutput>