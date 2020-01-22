<!DOCTPE html>
<html>

@extends('layout\head')
@extends('layout\navbar')
<head>
<title>View Abbreviations</title>
</head>
<body>


<table border = "1" style="margin-left: 40%;">
<tr>
<td>Abbreviations List (Total : @foreach ($count as $count) {{ $count->count }} @endforeach)</td>

</tr>
@foreach ($initials as $initial)
<tr>
<td style="text-align: center;"> {{ $initial->initial }} </td>
</tr>
@endforeach
</table>


</body>
</html>