<!DOCTPE html>
    <html>
    

    <head>
        <title>View Abbreviations</title>
        <!-- @extends('layout\head') -->
        
        <!-- MDB icon -->
        <link rel="icon" href="img/mdb-favicon.ico" type="image/x-icon">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css">
        <!-- Google Fonts Roboto -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
        <!-- Bootstrap core CSS -->
        <link rel="stylesheet" href="{{ asset('mdb_css/bootstrap.min.css') }}">
        <!-- Material Design Bootstrap -->
        <link rel="stylesheet" href="{{ asset('mdb_css/mdb.min.css') }}">
        <!-- Datatables -->
        <link rel="stylesheet" href="{{ asset('mdb_css/addons/datatables.min.css') }}">
        <!-- My style for mdb CSS -->
        <link rel="stylesheet" href="{{ asset('mdb_css/style.css') }}">


        <!-- jQuery -->
        <script type="text/javascript" src="{{ asset('mdb_js/jquery.min.js') }}"></script>
        <!-- Bootstrap tooltips -->
        <script type="text/javascript" src="{{ asset('mdb_js/popper.min.js') }}"></script>
        <!-- Bootstrap core JavaScript -->
        <script type="text/javascript" src="{{ asset('mdb_js/bootstrap.min.js') }}"></script>
        <!-- MDB core JavaScript -->
        <script type="text/javascript" src="{{ asset('mdb_js/mdb.min.js') }}"></script>
        <!-- Datatables -->
        <script type="text/javascript" src="{{ asset('mdb_js/addons/datatables.min.js') }}"></script>
        <!-- My scripts for mdb JS -->
        <script type="text/javascript" src="{{ asset('mdb_js/scripts.js') }}"></script>
    </head>

    <body>


        <nav class="navbar navbar-expand-lg navbar-light bg-light" style="margin-bottom: 2%;">
            <div class="collapse navbar-collapse" id="navbarNav">
                <a href="#"><img src="{{ URL::asset('img/final_logo.jpg') }}" width=" 150px"
                        style="border-radius: 50px;" alt="bone_yerushalayim_logo"></a>
                <ul class="navbar-nav" style="margin : 0 auto;">
                    <li class="nav-item active">
                        <a class="nav-link" href="#" style="margin: 0 40px 0 -100px">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" style="margin: 0 40px 0 40px">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" style="margin: 0 40px 0 40px">Pricing</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" style="margin: 0 40px 0 40px">Disabled</a>
                    </li>
                </ul>
            </div>
        </nav>



        <h1 class="text-center">ראשי תיבות<br><small class="text-muted">(Abbreviations)</small></h1>


        <p class="lead text-center">Here are all the abbreviations contained in the talmud
            Bavli ! More than 1300 ! <br> click on the one of your choice to propose a definition</p>

        <!-- Dynamic Table -->


        <div class="table-responsive">
            <table id="dynamic_table" class="table table-striped table-bordered table-sm" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th class="th-sm text-center">ראשי תיבות
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($initials as $initial)
                    <tr>
                        <td class="text-center">
                            {{ $initial->initial }}
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </body>

    </html>