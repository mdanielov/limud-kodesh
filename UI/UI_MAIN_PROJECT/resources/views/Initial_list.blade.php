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


    <p class="lead text-center" style="margin-bottom: 5%;">Here are all the abbreviations contained in the talmud Bavli ! More than 1300 ! <br> <strong> Be a part of the project ! </strong> <br> We need your help to assign a definition to each one of the abbreviations contained in the talmud, according to their context in the gemara.
      <br> Click on the one of your choice to propose a definition</p>

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

  <script>
    $(document).ready(function() {

      $('#abbreviation').addClass('active');

      // Setup - add a text input to each footer cell
      $('#initial_table thead tr').clone(true).appendTo('#initial_table thead');
      $('#initial_table thead tr:eq(1) th').each(function(i) {
        var title = $(this).text();
        $(this).html('<input type="text" placeholder="Search ' + title + '" id="filter_input" />');

        $('#filter_input', this).on('keyup change', function() {
          
          console.log(this.value);
          console.log(table.column(i).search(this.value).draw())
          if (table.column(i).search(this.value) == true) {
            table
              .column(i)
              .search(this.value)
              .draw();
          }
        });
      });

      var table = $('#initial_table').DataTable({
        orderCellsTop: true,
        fixedHeader: true,
        bStateSave: false,
        //"bPaginate": true,
        //"bLengthChange": false,
        //"bFilter": false,
        //"bInfo": false,
      });

      (function() {

        function removeAccents(data) {
          if (data.normalize) {
            // Use I18n API if avaiable to split characters and accents, then remove
            // the accents wholesale. Note that we use the original data as well as
            // the new to allow for searching of either form.
            return data + ' ' + data
              .normalize('NFD')
              .replace(/[\u0300-\u036f]/g, '');
          }

          return data;
        }

        var searchType = jQuery.fn.DataTable.ext.type.search;

        searchType.string = function(data) {
          return !data ?
            '' :
            typeof data === 'string' ?
            removeAccents(data) :
            data;
        };

        searchType.html = function(data) {
          return !data ?
            '' :
            typeof data === 'string' ?
            removeAccents(data.replace(/<.*?>/g, '')) :
            data;
        };

      }());


    });
  </script>

  </html>