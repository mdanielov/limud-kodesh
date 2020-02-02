<!DOCTPE html>
    <html>
    @extends('layout\head')

    <head>
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

        <h1 style="text-align: center;">{{ $data['initial']}} <br><small class="text-muted">(Total : {{ $data['Total'] }})</small></h1>
        <p class="lead text-center" style="width: 40%; margin: 0 auto;">Please select a source in the Talmud Bavli among those proposed below and propose a definition for this abbreviation in relation to its context in the gemara. <br> If the definition is the same for several places, then you can select multiple sources.</p>
        <br>

        <div style="width: 30%; margin : 0 auto;">
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
                        <th style="padding: 10px;"><input type="checkbox"></th>
                        <th scope="row" class="btn_show">{{ $Massechet->MASSECHET_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->DAF_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->AMUD_NAME }}</th>
                        <th scope="row" class="btn_show">{{ $Massechet->ROW_ID }}</th>       
                    </tr>  
                    <tr class="hidden_row">
                        <th colspan="5">First sentence</th>
                    </tr>  
                    <tr class="hidden_row">
                        <th colspan="5">Second sentence</th>
                    </tr> 
                    <tr class="hidden_row">
                        <th colspan="5">Third sentence</th>
                    </tr>      
                    @endforeach
                </tbody>
            </table>
            {{ $initialPosition->onEachSide(2)->links() }}
        </div>

    </body>
    <script>

            $('.btn_show').click(function () {
                var $massechet_name = $(this).parent().children().eq(1).text()
                var $daf_name = $(this).parent().children().eq(2).text()
                var $amud_name = $(this).parent().children().eq(3).text()
                var $row_id = $(this).parent().children().eq(4).text()

                


                if ($(this).parent().nextAll('tr:lt(3)').css('display') == 'none') {
                    $(this).parent().nextAll('tr:lt(3)').slideDown()
                    $(this).parent().nextAll('tr:lt(3)').css({'background-color':'white','display':'table-row'})
                }
                else {
                    $(this).parent().nextAll('tr:lt(3)').css({'display':'none'})
                    $(this).parent().nextAll('tr:lt(3)').slideUp()
                }
            });

    </script>
    </html>