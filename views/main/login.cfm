<cfdump  var="#rc#">
<div class="mainDivLogin mt-5 bg-light mx-auto shadow-lg">
    <div class="leftFlexLogin d-flex justify-content-center">
        <img src="./assets/images/contact-book.png" alt="" width="110" height="110" class="m-auto">
    </div>
    <div class="rightFlexLogin ">
        <h3 class="text-center rightFlexHeading">LOGIN</h3>
        <form class="d-flex flex-column" method="POST" onsubmit = "return loginValidate()">
            <input type="text" name="userName" id="userName" class="formInput" placeholder="Username">
            <span class="ms-5 text-danger fw-bold" id="userNameError"></span>
            <input type="password" name="pwd" id="pwd" class="formInput" placeholder="Password">
            <span class="ms-5 text-danger fw-bold" id="pwdError"></span>
            <input type="submit" name="submit"  class="registerBtn" value="Login">
        </form>
        <!--- <cfif structKeyExists(form,"submit")>  
            <cfset result = application.obj.logIn(form.userName,form.pwd)>
            <cfoutput>
                <span class="text-danger fw-bold ms-5">
                    #result#
                </span>
            </cfoutput>
        </cfif>  --->  
        <div class="text-center">
            <div class="my-3 text-secondary loginFooterTxt">Or Sign In Using</div>
            <div class="d-flex align-items-center justify-content-center">
                <a href="" class="mx-2"><img src="./assets/images/facebook-icon.png" alt="" width="50" height="50"></a>
                <a href="./GoogleSignIn.cfm" class="mx-2"><img src="./assets/images/google-icon.png" alt="" width="45" height="45"></a>  
            </div>
            <div class="my-3 loginFooterTxt">Don't have a account <a href="index.cfm" class="text-decoration-none ">Register here</a></div>
        </div>
    </div>
</div>
</main>