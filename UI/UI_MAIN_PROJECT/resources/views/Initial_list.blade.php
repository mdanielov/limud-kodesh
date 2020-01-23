<!DOCTPE html>
<html>
@extends('layout\head')

<head>
  <title>View Abbreviations</title>
</head>

<body>

<div class="form-group">
  <input type="text" name="inputSearch" class="form-control" placeholder="Search an abbreviation" style="width: 20%;">
  <button type="text" id="btnFiterSubmitSearch" class="btn btn-info">Submit</button>
</div>
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
          <th scope="row"> {{ $initial->initial }}</th>
        </tr>
        @endforeach
      </tbody>
    </table>
    {{ $initials->onEachSide(2)->links() }}
  </div>

</body>

<script type="text/javascript">

$(document).ready( function () {
   $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });
$('#initial_table').DataTable({
       processing: true,
       serverSide: true,
       ajax: {
        url: "{{ url('/') }}",
        type: 'GET',
        data: function (d) {
        d.inputSearch = $('#inputSearch').val();
        }
       },
       columns: [
                { data: 'initial', name: 'initial' },
             ]
    });
 });

$('#btnFiterSubmitSearch').click(function(){
   $('#laravel_datatable').DataTable().draw(true);
});

</script>
</html>