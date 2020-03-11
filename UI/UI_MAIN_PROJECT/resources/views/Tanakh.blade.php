<html lang="en">
@include('layout\head')
@include('layout\navbar')

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tanakh</title>
    <link href="{{ URL::asset('css/tanakh.css') }}" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.2/animate.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.2/animate.min.css">
    <style>
        @font-face {
            font-family: "Hebrew Sofer Stam Ashkenaz";
            src: url("{{ asset('fonts/StamAshkenazCLM.ttf') }}");
        }
    </style>
</head>

<body>
    <h1 class="text-center">תנ"ך <br><small class="text-muted">Tanakh</small></h1>

    <div class="container">

        <h2 class="text-center" id="torah">תורה</h2>
        <div style="display: flex; justify-content: space-between;">
            @foreach($data['torah'] as $key => $torahNameHebrew)
            <button type="button" class="btn btn-light btn-lg">{{ $torahNameHebrew->SEFER_HEBREW_NAME }} / {{ $torahNameHebrew->SEFER_ENGLISH_NAME }}</button>
            @if($key == '2')
        </div>
        <div style="display: flex; justify-content: space-between;margin-top:40px;">
            @endif
            <br>
            @endforeach
        </div>
    </div>


    <div class="container">

        <h2 class="text-center" id="neviim">נביים</h2>
        <div style="display: flex; justify-content: space-between;">
            @foreach($data['neviim'] as $key => $neviimNameHebrew)
            <button type="button" class="btn btn-light btn-lg">{{ $neviimNameHebrew->SEFER_HEBREW_NAME }} / {{ $neviimNameHebrew->SEFER_ENGLISH_NAME }}</button>
            @if($key % 3 === 0)
        </div>
        <div style="display: flex; justify-content: space-between;margin-top:40px;">
            @endif
            <br>
            @endforeach
        </div>
    </div>

</body>

</html>