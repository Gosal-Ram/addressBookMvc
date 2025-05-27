<cfoutput>
    <h1>Oops! An error occurred.</h1>
    <cfdump  var="#rc#">
    <!--- <p>#rc.message#</p> --->
    <a href="#buildURL('main')#">Go Home</a>
</cfoutput>