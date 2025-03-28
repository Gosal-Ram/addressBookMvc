component accessors="true" {
    property addressBookService; 

    public function default(struct rc) {
        if(structKeyExists(session, "isLoggedIn")){
        rc.contacts = variables.addressBookService.fetchContact();
        }
    }

    public function login(struct rc){
        if(structKeyExists(rc, "submit")){
            rc.result = variables.addressBookService.logIn(rc.userName,rc.pwd)
        }
    }
    remote function logOut(struct rc) {
        structClear(session);
        location(url="/login.cfm",addtoken="false");
        // rc.result = variables.addressBookService.logOut();
    }
}