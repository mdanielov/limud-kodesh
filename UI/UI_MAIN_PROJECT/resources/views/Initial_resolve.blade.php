<!DOCTPE html>
    <html>
    @extends('layout\head')

    <head>
        <script src="https://use.fontawesome.com/c1d8aa1882.js"></script>
        <title>View Abbreviations</title>
        <link href="{{ URL::asset('css/Initial_resolve.css') }}" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    </head>

    <body>

        <nav class="navbar navbar-expand-lg navbar-light bg-light" style="margin-bottom: 5%;">
            <div class="collapse navbar-collapse" id="navbarNav">
                <a href="#"><img src="{{ URL::asset('img/final_logo.jpg') }}" width=" 150px" style="border-radius: 50px;" alt="bone_yerushalayim_logo"></a>
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

        <h1 style="text-align: center;"><span id="abbreviation">{{ $data['initial']}}</span> <br><small class="text-muted">(Total : {{ $data['Total'] }})</small></h1>
        <p class="lead text-center" style="width: 40%; margin: 0 auto;">Please select a source in the Talmud Bavli among those proposed below and propose a definition for this abbreviation in relation to its context in the gemara. <br> If the definition is the same for several places, then you can select multiple sources.</p>
        <br>

        <!--Spinner loading-->
        <div class="d-flex justify-content-center" id="circle">
            <div class="spinner-border" role="status">
            </div>
        </div>
        <p id="loading" style="text-align: center;">Please wait a moment...</p>


        <div style="width: 30%; margin : 0 auto;" id="table">
            <table class="table table-striped table-bordered table-sm data-table" style="text-align: center;" id="initialPosition_table">
                <thead class="thead-dark">
                    <tr>
                        <th>Select</th>
                        <th scope="col">Massechet Name</th>
                        <th scope="col">Daf</th>
                        <th scope="col">Amud</th>
                        <th scope="col">Line number</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($initialPosition as $Massechet)
                    <tr>
                        <th style="padding: 10px;"><input type="checkbox" data-id="{{$loop->index}}"></th>
                        <th scope="row" class="btn_show">{{ $Massechet->MASSECHET_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->DAF_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->AMUD_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->ROW_ID }} <i class="fas fa-chevron-down icon-rotate" id="arrow-right"></i></th>
                    </tr>
                    <tr class="hidden_row_1" data-id="{{$loop->index}}">
                        <th colspan="5"></th>
                    </tr>
                    <tr class="hidden_row_2" data-id="{{$loop->index}}">
                        <th colspan="5"></th>
                    </tr>
                    <tr class="hidden_row_3" data-id="{{$loop->index}}">
                        <th colspan="5"></th>
                    </tr>
                    @endforeach
                </tbody>
            </table>
            {{ $initialPosition->onEachSide(2)->links() }}
        </div>
        <div class="input_definition">
            <label for="input_def">
                <p>Please enter a definition : </p>
            </label>
            <input id="input_def" type="text" class="form-control">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </body>
    <script>
        $(document).ready(function() {

            $counter = 0;
            $counterMax = 0;

            $(".hidden_row_1").each(function($index) {
                $counterMax += 1;
            });

            if ($counter < $counterMax) {

                $('#circle').show();
            }

            $(".hidden_row_1").each(function() {
                var $initial = $('#abbreviation').text();
                var $attribute = $(this).attr("data-id"); // get the foreach loop index
                var $massechet_name = $(this).prev().children().eq(1).text();
                var $daf_name = $(this).prev().children().eq(2).text();
                var $amud_name = $(this).prev().children().eq(3).text();
                var $row_id = $(this).prev().children().eq(4).text();

                loadSentence($attribute, $initial, $massechet_name, $daf_name, $amud_name, $row_id);
            });
        });


        function loadSentence($attribute, $initial, $massechet_name, $daf_name, $amud_name, $row_id) {



            $.ajax({
                url: '/ShowContext/{initial}/{massechet}/{daf}/{amud}/{row}',
                type: "GET",
                data: {
                    initial: $initial,
                    massechet: $massechet_name,
                    daf: $daf_name,
                    amud: $amud_name,
                    row: $row_id
                },
                success: function($response) {

                    $(".hidden_row_1[data-id='" + $attribute + "'").children().html($response[0]['sentence']);
                    $(".hidden_row_2[data-id='" + $attribute + "'").children().html($response[1]['sentence']);
                    $(".hidden_row_3[data-id='" + $attribute + "'").children().html($response[2]['sentence']);

                    console.log($counter);

                    $counter += 1;

                    if ($counter == $counterMax) {
                        $('#circle').removeClass("d-flex").hide();
                        $('#loading').hide();
                        $('#table').removeClass("table").show();
                    };
                }
            });
        };

        $('.btn_show').click(function() {

            console.log(this)

            if ($(this).parent().nextAll('tr:lt(3)').css('display') == 'none') {
                $(this).parent().nextAll('tr:lt(3)')
                $(this).parent().nextAll('tr:lt(3)').slideDown()
                $(this).parent().nextAll('tr:lt(3)').css({
                    'background-color': 'white',
                    'display': 'table-row'
                })
            } else {
                $(this).parent().nextAll('tr:lt(3)').css({
                    'display': 'none'
                })
                $(this).parent().nextAll('tr:lt(3)').slideUp()
            }
        });
    </script>

    </html>