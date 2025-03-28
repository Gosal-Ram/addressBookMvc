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
             createdBy = <cfqueryparam value = "brian" cfsqltype = "cf_sql_varchar">
        </cfquery> 
        <cfreturn local.queryGetContacts>
    </cffunction>

    <cffunction name ="logIn" access="public" returnType="string">
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

    <cffunction  name="viewContact" access="remote" returnType="struct" returnFormat = "json" > 
        <cfargument  name = "contactid" required ="true">

        <cfset queryViewPage = getContacts(contactid = arguments.contactid)>
<!---         <cfdump  var="#queryViewPage#"> --->
        <cfset local.contactDetails = structNew()>
        <cfset local.contactDetails["contactid"] = queryViewPage.contactid>
        <cfset local.contactDetails["nametitle"] = queryViewPage.nametitle>
        <cfset local.contactDetails["firstname"] = queryViewPage.firstname>
        <cfset local.contactDetails["lastname"] = queryViewPage.lastname>
        <cfset local.contactDetails["gender"] = queryViewPage.gender>
        <cfset local.contactDetails["dateofbirth"] = queryViewPage.dateofbirth>
        <cfset local.contactDetails["contactprofile"] = queryViewPage.contactprofile>
        <cfset local.contactDetails["address"] = queryViewPage.address>
        <cfset local.contactDetails["street"] = queryViewPage.street>
        <cfset local.contactDetails["district"] = queryViewPage.district>
        <cfset local.contactDetails["state"] = queryViewPage.state>
        <cfset local.contactDetails["country"] = queryViewPage.country>
        <cfset local.contactDetails["pincode"] = queryViewPage.pincode>
        <cfset local.contactDetails["email"] = queryViewPage.email>
        <cfset local.contactDetails["mobile"] = queryViewPage.mobile>
        <cfquery name="local.queryRoleDetails">
            SELECT 
                cfrole.roleName,
                cfrole.roleId
            FROM 
                cfrole
                JOIN contact_role_map ON cfrole.roleId = contact_role_map.roleId
            WHERE 
                contact_role_map.contactId = <cfqueryparam value="#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfset local.contactDetails["role"] = "">
        <cfset local.contactDetails["roleIds"] = []>
        <!---Loop to get all rolenames and roleIds--->
        <cfloop query="local.queryRoleDetails">
            <cfif local.contactDetails["role"] NEQ "">
                <cfset local.contactDetails["role"] = local.contactDetails["role"] & ", ">
            </cfif>
            <cfset local.contactDetails["role"] = local.contactDetails["role"] & local.queryRoleDetails.roleName>
            <cfset ArrayAppend(local.contactDetails["roleIds"] , local.queryRoleDetails.roleId)>
        </cfloop>

        <cfreturn local.contactDetails>
    </cffunction>

    <cffunction  name="getContacts" access="public" returnType="query">
        <cfargument  name="contactid">
        <!--- <cfdump  var="#arguments#"> --->
        
        <cfquery name="local.queryGetAllContactsInfo">
            SELECT 
                cd.contactid,
                cd.nametitle,
                cd.firstname,
                cd.lastname,
                cd.gender,
                cd.dateofbirth,
                cd.contactprofile,
                cd.address,
                cd.street,
                cd.district,
                cd.state,
                cd.country,
                cd.pincode,
                cd.email,
                cd.mobile,
                STRING_AGG(cr.roleName, ',') AS roleNames
            FROM 
                cfcontactDetails cd
            LEFT JOIN 
                contact_role_map crm ON cd.contactid = crm.contactid
            LEFT JOIN 
                cfrole cr ON crm.roleid = cr.roleid
            WHERE 
                cd.contactid = 195
            AND
                cd.activeStatus = 1
            GROUP BY 
                cd.contactid,
                cd.nametitle,
                cd.firstname,
                cd.lastname,
                cd.gender,
                cd.dateofbirth,
                cd.contactprofile,
                cd.address,
                cd.street,
                cd.district,
                cd.state,
                cd.country,
                cd.pincode,
                cd.email,
                cd.mobile
        </cfquery>
<!---         <cfdump  var="#local.queryGetAllContactsInfo#"> --->
        <cfreturn local.queryGetAllContactsInfo>
    </cffunction>
    
<!---     <cffunction  name="logOut" access="remote">
        <cfset structClear(session)>
        <cflocation url="/login.cfm" addtoken="false">
     </cffunction> --->
</cfcomponent>