component accessors="true" {
    property addressBookService; 

    function init(fw) {
        variables.framework = arguments.fw;
        return this;
    }

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

    remote function logOut() {
        structClear(session);
        variables.framework.renderData().data(true).type( "text" ); // since no view  skip the check
    }

    public function viewContact(struct rc) {
        rc.result = variables.addressBookService.viewContact(rc.contactid)
        variables.framework.renderData().data(rc.result).type( "JSON" ); // since no view  skip the check
    }


}