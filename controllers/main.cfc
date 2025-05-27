component accessors="true" {
    property addressBookService; 

    function init(fw) {
        variables.framework = arguments.fw;
        return this;
    }

    public function default(struct rc) {
        if(structKeyExists(rc, "modalSubmitBtn")){
        rc.result = variables.addressBookService.saveContact( nameTitle =  rc.nameTitle,
            firstName = rc.firstName,
            lastName = rc.lastName,
            gender = rc.gender,
            dob = rc.dob,
            contactProfile = rc.contactProfile,
            address = rc.address,
            street = rc.street,
            district = rc.district,
            state = rc.state,
            country = rc.country,
            pincode = rc.pincode,
            email = rc.email,
            mobile = rc.mobile,
            contactId = rc.contactId,
            role = rc.role);
        }
        if(structKeyExists(session, "isLoggedIn")){
        rc.contacts = variables.addressBookService.fetchContact();
        rc.roles = variables.addressBookService.getRoleNameAndRoleId()
        }
        
    }

    public function login(struct rc){
        rc.result = ""
        if(structKeyExists(rc, "submit")){
            rc.result = variables.addressBookService.logIn(rc.userName,rc.pwd)
        }
    }
    public function signup(struct rc){
        rc.result = ""
        if(structKeyExists(rc, "submit")){
            rc.result = variables.addressBookService.signUp(rc.fullName,rc.emailId,rc.userName,rc.pwd1,rc.profilePic)
        }
    }

    public function logOut() {
        structClear(session);
        variables.framework.renderData().data(true).type( "text" ); // since no view  skip the check
    }

    public function viewContact(struct rc) {
        rc.result = variables.addressBookService.viewContact(rc.contactid)
        variables.framework.renderData().data(rc.result).type( "JSON" ); 
    }

    public function deleteContact(struct rc) {
        rc.result = variables.addressBookService.deleteContact(rc.contactid)
        variables.framework.renderData().data(rc.result).type( "JSON" ); 
    }

    public function urlRequestHandler(struct rc){
        allowedPages = ["main.login" , "main.signup"];
        if (structKeyExists(session, "username") OR arrayContains(allowedPages, rc.action)) {
        } else {
            location(url="/index.cfm?action=main.login", addtoken="no");
        }
    }


}