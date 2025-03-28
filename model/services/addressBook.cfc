<cfcomponent>
    <cffunction  name="fetchContact" access = "public" returnType = "query">
        <cfquery name="local.queryGetContacts">
            SELECT 
                contactid,
                firstname,
                lastname,
                contactprofile,
                email,
                mobile
            FROM 
                cfcontactDetails
            WHERE
             createdBy = <cfqueryparam value = "#session.username#" cfsqltype = "cf_sql_varchar">
        </cfquery> 
        <cfreturn local.queryGetContacts>
    </cffunction>

    <cffunction name ="logIn" access = "public" returnType="string">
        <cfargument name ="userName" type="string" required ="true">
        <cfargument name ="pwd" type="string" required = "true">

        <cfset local.encryptedPassFromUser = Hash(#arguments.pwd#, 'SHA-512')/>
        <cfset local.result = "">        
        <cfquery name ="local.queryUserLogin">
            SELECT 
                userName,
                pwd,
                profilePic,
                fullname,
                emailId
            FROM 
                cfuser 
            WHERE 
                userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>

        <cfif local.queryUserLogin.userName == ''>
            <cfset local.result = "User name doesn't exist">
        <cfelseif local.queryUserLogin.pwd NEQ local.encryptedPassFromUser >
            <cfset local.result = "Invalid password">
        <cfelse>
            <cfset session.isLoggedIn = true>
            <cfset session.userName = local.queryUserLogin.userName>
            <cfset session.fullName = local.queryUserLogin.fullname>
            <cfset session.profilePic = local.queryUserLogin.profilePic>
            <cfset session.emailId = local.queryUserLogin.emailId>
            <cflocation  url = "index.cfm" addToken="no">  
        </cfif>
        <cfreturn local.result>
    </cffunction>
    
    <cffunction  name="logOut" access="remote">
        <cfset structClear(session)>
        <cflocation url="/login.cfm" addtoken="false">
     </cffunction>
</cfcomponent>