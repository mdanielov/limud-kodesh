<!DOCTPE html>
<html>

@extends('layout\head')

<head>
<title>View Abbreviations</title>
</head>

<body>



<div style="width: 30%; margin : 0 auto;">
<table class="table table-striped table-bordered table-sm" style="text-align: center;">
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
</div>

<!-- <table border = "1" style="margin-left: 40%;">
<tr>
<td>Abbreviations List (Total : @foreach ($count as $count) {{ $count->count }} @endforeach)</td>

</tr>
@foreach ($initials as $initial)
<tr>
<td style="text-align: center;"> {{ $initial->initial }} </td>
</tr>
@endforeach
</table> -->


</body>
</html>