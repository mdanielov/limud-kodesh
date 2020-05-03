<!DOCTPE html>
  <html>
  @extends('layout\head')
  @include('layout\navbar')

  <head>
    <title>View Abbreviations</title>
    <link href="{{ URL::asset('css/Initial_list.css') }}" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  </head>

  <body>




    <h1 class="text-center">ראשי תיבות <br><small class="text-muted">(Abbreviations)</small></h1>

    <img src="{{ URL::asset('img/wordcloud.png') }}" alt="img" id="wordcloud">

    <p class="lead text-center" style="margin-bottom: 5%;">Here are all the abbreviations contained in the talmud Bavli ! More than 1300 ! <br> <strong> Be a part of the project ! </strong> <br> We need your help to assign a definition to each one of the abbreviations contained in the talmud, according to their context in the gemara.
      <br> Click on the one of your choice to propose a definition</p>

    <div style="width: 30%; margin : 0 auto;">
      <table class="table table-striped table-bordered table-sm data-table" style="text-align: center;">
        <thead class="thead-dark">
          <tr>
            <th scope="col">Abbreviations List</th>
          </tr>
          <tr>
            <th scope="col" rowspan="1" colspan="1"><input type="text" placeholder="Search Abbreviation" id="filter_input"></th>
          </tr>
        </thead>
        <tbody id="initial_table">
          @foreach ($initials as $initial)
          <tr>
            <th scope="row"> <a href="{{ URL::to('initial/'.$initial->initial) }}">{{ $initial->initial }}</a></th>
          </tr>
          @endforeach
        </tbody>
      </table>
      {{ $initials->onEachSide(2)->appends($_GET)->links() }}
    </div>

  </body>

  <script>
    $(document).ready(function() {

      // var dataTable = $('.table').dataTable();


      //$test = '{!! json_encode($initialAll->toArray()) !!}'

      //console.log($test)

      $('#abbreviation').addClass('active');

      $("#filter_input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $("#initial_table tr").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)

        });
      });

    });
  </script>

  </html>