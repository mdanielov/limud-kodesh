<!DOCTPE html>
  <html>
  @extends('layout\head')

  <head>
    <title>View Abbreviations</title>
    <link href="{{ URL::asset('css/Initial_list.css') }}" rel="stylesheet">
  </head>

  <body>


    <nav class="navbar navbar-expand-lg navbar-light bg-light" style="margin-bottom: 5%;">
      <div class="collapse navbar-collapse" id="navbarNav">
        <a href="#"><img src="{{ URL::asset("img/final_logo.jpg") }}"" width=" 150px" style="border-radius: 50px;" alt="bone_yerushalayim_logo"></a>
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



    <h1 class="text-center">ראשי תיבות <br><small class="text-muted">(Abbreviations)</small></h1>


    <p class="lead text-center" style="margin-bottom: 5%;">Here are all the abbreviations contained in the talmud Bavli ! More than 1300 ! <br> click on the one of your choice to propose a definition</p>

    <div style="width: 30%; margin : 0 auto;">
      <table class="table table-striped table-bordered table-sm data-table" style="text-align: center;" id="initial_table">
        <thead class="thead-dark">
          <tr>
            <th scope="col">Abbreviations List</th>
          </tr>
        </thead>
        <tbody>
          @foreach ($initials as $initial)
          <tr>
            <th scope="row"> <a href="{{ URL::to('initial/'.$initial->initial) }}">{{ $initial->initial }}</a></th>
          </tr>
          @endforeach
        </tbody>
      </table>
      {{ $initials->onEachSide(2)->links() }}
    </div>

  </body>

  </html>