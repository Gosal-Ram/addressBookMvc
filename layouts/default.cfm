<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home</title>
        <link rel="stylesheet" href="/bootstrap-5.0.2-dist/css/bootstrap.min.css">
        <script src="/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="/assets/css/style.css">
        <link href="/assets/images/favicon.png" rel="icon">
    </head>
<body>
    <cfoutput>
        <header class="d-flex p-1 align-items-center">
            <div class="nameTxtContainer ms-4">
                <img src="/assets/images/contact-book.png" alt="" width="45" height="45">
                <a href="#buildURL('main')#" class = "titleLink text-light"
                    <span class="headerHeadingName">ADDRESS BOOK</span>    
                </a>
            </div>
            <div class="ms-auto d-flex me-5">
                <div class="loginCont">
                <a class="btn text-light" onClick="return logOut()"> 
                    <img src="/assets/images/exit.png" alt="" width="18" height="18">
                    Logout
                </a>
                </div>
            </div>
        </header>
        <main class = "mx-auto homeMain">
            #body#
        </main>
    </cfoutput> <!-- View content goes here -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="./assets/js/script.js"></script>
</body>
</html>