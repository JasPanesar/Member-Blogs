<cfcomponent extends="mura.cfobject" output="false">
	
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="filePath" type="string" required="true" />
		<cfset variables.filePath = arguments.filePath />
		<cfset setupDirectory() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setupDirectory" access="private" returntype="void" output="false">
		<cfset var local = {} />
		<cfset local.abortTag = "<cfabort />" />
		<cfset writeToFile("Application.cfm",variables.filePath,local.abortTag) />
	</cffunction>
	
	<cffunction name="getValue" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		
		<cfset var local = {} />
		
		<cfif !super.valueExists(arguments.key)>
			<cfset local.fromFile = readFromFile(arguments.key & '.cfm',variables.filePath) />
			<cfif len(structKeyList(local.fromFile))>
				<cfset setValue(arguments.key,local.fromFile) />
			<cfelse>
				<cfset setValue(arguments.key,getValue('defaultSettings')) />
			</cfif>
		</cfif>
		
		<cfreturn super.getValue(arguments.key) />
	</cffunction>
	
	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="saveToFile" type="boolean" required="false" default="false" />
		
		<cfset super.setValue(arguments.key,arguments.value) />
		
		<cfif arguments.saveToFile && isValid("Struct",arguments.value)>
			<cfset writeToFile(arguments.key & '.cfm',getValue('filePath'),serializejson(arguments.value)) />
		</cfif>
	</cffunction>
	
	<cffunction name="writeToFile" access="private" returntype="void" output="false">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="filePath" type="string" required="true" />
		<cfargument name="fileContent" type="string" required="true" />
		
		<cfif !directoryexists(arguments.filePath)>
			<cfdirectory action="create" directory="#arguments.filepath#" />
		</cfif>
		
		<cffile action="write" file="#arguments.filePath#/#arguments.fileName#" output="#arguments.fileContent#" />
	</cffunction>
	
	<cffunction name="readFromFile" access="private" returntype="struct" output="false">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="filePath" type="string" required="true" />
		
		<cfset var local = {} />
		<cfset local.s = {} />
		
		<cfif fileExists(arguments.filePath & '/' & arguments.fileName)>
			<cfset local.fc = "" />
			<cffile action="read" file="#arguments.filePath#/#arguments.fileName#" variable="local.fileRead" />
			<cftry>
				<cfset local.fc = deserializejson(local.fileRead) />
				<cfcatch><!--- Don't do anything ---></cfcatch>
			</cftry>
			<cfif isValid("Struct",local.fc)>
				<cfset local.s = local.fc />
			</cfif>
		</cfif>
		
		<cfreturn local.s />
	</cffunction>
	
</cfcomponent>