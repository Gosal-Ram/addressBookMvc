component extends="framework.one" {
    this.sessionManagement = true;
    this.dataSource = "database_gosal";
    allowedPages = ["/index.cfm"];

    public void function setupRequest() {
        controller('main.urlRequestHandler');
    }
}
