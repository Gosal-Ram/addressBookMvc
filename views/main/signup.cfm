<div class="mainDiv mt-5 bg-light mx-auto shadow-lg">
    <div class="leftFlex d-flex justify-content-center">
        <img src="/assets/images/contact-book.png" alt="" width="110" height="110" class="m-auto">
    </div>
    <div class="rightFlex ">
        <h3 class="text-center rightFlexHeading">SIGN UP</h3>
        <form method = "post" class="d-flex flex-column" enctype="multipart/form-data" onsubmit = "return signInValidate()">
            <input type="text" name="fullName" id="fullName" class="formInput" placeholder="Full Name">
            <span id="fullNameError" class="ms-3 text-danger fw-bold"></span>
            <input type="mail" name="emailId" id="emailId" class="formInput" placeholder="Email ID">
            <span id="emailIdError" class="ms-3 text-danger fw-bold"></span>
            <input type="text" name="userName" id="userName" class="formInput" placeholder="Username">
            <span id="userNameError" class="ms-3 text-danger fw-bold"></span>
            <input type="password" name="pwd1" id="pwd1" class="formInput" placeholder="Password">
            <span id="pwd1Error" class="ms-3 text-danger fw-bold"></span>
            <input type="password" name="pwd2" id="pwd2" class="formInput" placeholder="Confirm Password">
            <span id="pwd2Error" class="ms-3 text-danger fw-bold"></span>
            <label for="file" class="ms-3">Upload Profile picture</label>
            <input type="file" name="profilePic" id="profilePic" class="fileInput">
            <span id="profilePicError" class="ms-3 text-danger fw-bold"></span>
            <input type="submit" name="submit" class="registerBtn" value="Register">
        </form>
        <cfoutput>
            <span class="text-info ms-5 fs-6 text-center">#rc.result#</span>                
        </cfoutput>  
    </div>
</div>