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
             AND activeStatus = 1
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
        <!---<cfdump  var="#queryViewPage#"> --->
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
                cd.contactid = <cfqueryparam value="#arguments.contactid#" cfsqltype="integer">
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
        <!---<cfdump  var="#local.queryGetAllContactsInfo#">  --->
        <cfreturn local.queryGetAllContactsInfo>
    </cffunction>

    <cffunction  name="signUp" returnType="string">
        <cfargument  name="fullName" type="string" required="true">
        <cfargument  name="emailId" type="string" required="true">
        <cfargument  name="userName" type="string" required="true">
        <cfargument  name="pwd1" type="string" required="true">
        <cfargument  name="profilePic" type="string" required="true">

        <cfset local.encryptedPass = Hash(#arguments.pwd1#, 'SHA-512')/>
        <cfset local.result = "">
        <cfquery name = "local.queryUniqueUserCheck">
            SELECT 
                COUNT(userName) AS count
            FROM 
                cfuser 
            WHERE
                userName = <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR"> AND 
                emailId = <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfif local.queryUniqueUserCheck.count>
            <cfset local.result = "user name or mail already exists">
        <cfelse>
            <cfif arguments.profilePic =="">
                <cfset local.imagePath = "user-grey-icon.png">
            <cfelse>
                <cfset local.imagePath = expandPath("./assets/userImages")>
                <cffile action="upload" destination="#local.imagePath#" nameConflict="makeunique">
                <cfset local.imagePath = cffile.clientFile>
            </cfif>
            <cfquery name="local.queryInsert">
                INSERT INTO 
                    cfuser(
                        fullName,
                        emailId,
                        userName,
                        pwd,
                        profilePic
                    ) 
                VALUES 
                    (<cfqueryparam value = "#arguments.fullName#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.emailId#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.userName#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.encryptedPass#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.imagePath#" cfsqltype="CF_SQL_VARCHAR">
                )
            </cfquery>
            <cfset local.result = "user created successfully">
        </cfif>
        <cfreturn local.result>
    </cffunction>
    

        <!---<cffunction  name="logOut" access="remote">
            <cfset structClear(session)>
            <cflocation url="/login.cfm" addtoken="false">
        </cffunction> --->

    <cffunction  name="getRoleNameAndRoleId" access="public" returnType = "query">
        <cfquery name="local.queryRoleDetails">
           SELECT 
               roleName,
               roleId
           FROM 
               cfrole
       </cfquery>
       <cfreturn local.queryRoleDetails>
    </cffunction>

    <cffunction  name="deleteContact" returnType="boolean" access="remote">
        <cfargument  name="contactid" required ="true">

        <cfquery name = "local.updateContactTablelEntries">
            UPDATE 
                cfcontactDetails
            SET 
                activeStatus = 0 , 
                deletedBy =<cfqueryparam value = "#session.userName#" cfsqltype="CF_SQL_VARCHAR">
            WHERE 
                contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="saveContact" returnType="any">
        <cfargument type="string" required="true" name="nameTitle">
        <cfargument type="string" required="true" name="firstName">
        <cfargument type="string" required="true" name="lastName">
        <cfargument type="string" required="true" name="gender">
        <cfargument type="string" required="true" name="dob">
        <cfargument type="string" required="true" name="contactProfile">
        <cfargument type="string" required="true" name="address">
        <cfargument type="string" required="true" name="street">
        <cfargument type="string" required="true" name="district">
        <cfargument type="string" required="true" name="state">
        <cfargument type="string" required="true" name="country">
        <cfargument type="string" required="true" name="pincode">
        <cfargument type="string" required="true" name="email">
        <cfargument type="string" required="true" name="mobile">
        <cfargument type="string" required="true" name="role">
        <cfargument type="string" required="true" name="contactId">
        <cfset local.result = "">
        <!---  SETTING DEFAULT PROFILE PICTURE --->
        <cfif arguments.contactProfile =="">
            <cfif len(trim(arguments.contactId))>
                <cfquery name="local.queryFetchContactProfile">
                    SELECT 
                        contactprofile
                    FROM 
                        cfcontactDetails
                    WHERE
                        contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype="CF_SQL_integer">
                </cfquery>
                <cfset local.file = local.queryFetchContactProfile.contactprofile>  
            <cfelse>
                <cfset local.file = "user-grey-icon.png">
            </cfif>
        <cfelse>
            <cfset local.path = expandPath("./assets/contactImages/")> 
            <cffile  action="upload" destination = "#local.path#" nameConflict="makeUnique">  
            <cfset local.file = cffile.clientFile>  
        </cfif>
        <!---     UNIQUE CONTACT CHECK SECTION     --->
        <cfif len(trim(arguments.contactId))>
            <!--- FOR UPDATE--->
            <cfquery name = "local.queryCheckUnique">
                SELECT 
                    email,
                    contactid
                FROM 
                    cfcontactDetails
                WHERE 
                    email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > AND 
                    activeStatus = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">  AND
                    createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" > AND
                    NOT contactid = <cfqueryparam value = "#arguments.contactId#" cfsqltype = "CF_SQL_integer">  
            </cfquery>
        <cfelse>
            <!--- FOR CREATE--->
            <cfquery name = "local.queryCheckUnique">
                SELECT 
                    email
                FROM 
                    cfcontactDetails
                WHERE 
                    email= <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR" > AND
                    createdBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR" > AND  
                    activeStatus = <cfqueryparam value="1" cfsqltype="cf_sql_INTEGER">       
            </cfquery>
        </cfif>

        <cfif local.queryCheckUnique.recordcount GT 0 OR arguments.email EQ session.emailId>
            <cfset local.result ="mobile number or email already exists">
        <cfelse>
            <!---IF ARG CONTACTID PASSED   =>EDIT(UPDATE) --->
            <cfif len(trim(arguments.contactId))>
                <!--- UPDATE ROLE SECTION        DELETING ALL SELECTED ROLES      --->
                <cfquery name = "local.queryDeleteSelectedRoles">
                    DELETE FROM 
                        contact_role_map  
                    WHERE 
                        contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype="CF_SQL_integer">
                </cfquery>
                <!---INSERTING NEW SELECTED ROLES --->
                <cfset insertRole(arguments.role, arguments.contactid)>  
                <!--- UPDATE OTHER CONTACT DETAILS SECTION--->
                <cfquery name = "local.queryInsertEdits">
                    UPDATE 
                        cfcontactDetails
                    SET 
                        nameTitle = <cfqueryparam value = "#arguments.nameTitle#" cfsqltype = "CF_SQL_VARCHAR">,
                        firstname = <cfqueryparam value = "#arguments.firstname#" cfsqltype = "CF_SQL_VARCHAR">,
                        lastname = <cfqueryparam value = "#arguments.lastname#" cfsqltype = "CF_SQL_VARCHAR">,
                        gender = <cfqueryparam value = "#arguments.gender#" cfsqltype = "CF_SQL_VARCHAR">,
                        dateofbirth = <cfqueryparam value = "#arguments.dob#" cfsqltype = "CF_SQL_VARCHAR">,
                        contactprofile = <cfqueryparam value = "#local.file#" cfsqltype = "CF_SQL_VARCHAR">,
                        address = <cfqueryparam value = "#arguments.address#" cfsqltype = "CF_SQL_VARCHAR">,
                        street = <cfqueryparam value = "#arguments.street#" cfsqltype = "CF_SQL_VARCHAR">,
                        district = <cfqueryparam value = "#arguments.district#" cfsqltype = "CF_SQL_VARCHAR">,
                        STATE = <cfqueryparam value = "#arguments.state#" cfsqltype = "CF_SQL_VARCHAR">,
                        country = <cfqueryparam value = "#arguments.country#" cfsqltype = "CF_SQL_VARCHAR">,
                        pincode = <cfqueryparam value = "#arguments.pincode#" cfsqltype = "CF_SQL_VARCHAR">,
                        email = <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR">,
                        mobile = <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR">,
                        updatedBy = <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR">,
                        updatedOn = <cfqueryparam value = "#Now()#" cfsqltype = "CF_SQL_TIMESTAMP">
                    WHERE 
                        contactid = <cfqueryparam value = "#arguments.contactid#" cfsqltype = "CF_SQL_integer"> 
                </cfquery>
                <!---                 <cfset local.result = "contact edited succesfully"> --->
                <cfset local.result = "UPDATED">
            <cfelse>
                <!---  =>CREATE NEW CONTACT(INSERT) --->
                <cfquery name="local.queryInsertContact" result = "local.resultInsertContact">
                    INSERT INTO 
                        cfcontactDetails (
                            nameTitle,
                            firstname,
                            lastname,
                            gender,
                            dateofbirth,
                            contactprofile,
                            address,
                            street,
                            district,
                            STATE,
                            country,
                            pincode,
                            email,
                            mobile,
                            createdBy
                        )
                    VALUES (
                        <cfqueryparam value = "#arguments.nameTitle#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.firstname#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.lastname#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.gender#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.dob#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#local.file#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.address#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.street#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.district#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.state#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.country#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.pincode#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.email#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#arguments.mobile#" cfsqltype = "CF_SQL_VARCHAR">,
                        <cfqueryparam value = "#session.userName#" cfsqltype = "CF_SQL_VARCHAR">
                    )
                </cfquery>
                <cfif len(trim(arguments.role)) > 
                    <cfset insertRole(arguments.role, local.resultInsertContact.generatedkey)>
                </cfif>
                <!---                 <cfset local.result = "contact created succesfully"> --->
                <cfset local.result = "INSERTED">
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="insertRole" returnType="void" access="public">
        <cfargument name="roleList" type="string" required="true">
        <cfargument name="contactId" type="integer" required="true">
        
        <cfloop list="#arguments.roleList#" index="roleId">
            <cfquery name="insertRoleQuery">
                INSERT INTO 
                    contact_role_map (
                        roleId,
                        contactid
                    )
                VALUES (
                    <cfqueryparam value="#roleId#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#arguments.contactId#" cfsqltype="CF_SQL_integer">
                )
            </cfquery>
        </cfloop>
    </cffunction>


</cfcomponent>