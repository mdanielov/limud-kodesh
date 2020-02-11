<html lang="en">
@include('layout\head')
@include('layout\navbar')

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>
    <link href="{{ URL::asset('css/home.css') }}" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-parallax-js@5.2.0/dist/simpleParallax.min.js"></script>
    <link rel="stylesheet" href="{{ URL::asset('css/jquery.incremental-counter.css')}}">
    <script type="text/javascript" src="{{ URL::asset('js/jquery.incremental-counter.js')}}"></script>
    <script type="text/javascript" src="{{ URL::asset('js/jQuery-inView.js')}}"></script>
    <style>
        @font-face {
            font-family: "Hebrew Sofer Stam Ashkenaz";
            src: url("{{ asset('fonts/StamAshkenazCLM.ttf') }}");
        }
    </style>
</head>

<body>



    <img src="{{ URL::asset('img/sefer.jpg') }}" class="parallax">

    <div class="section1">
        <h1 class="text-center">Welcome to the Bone Yerushalayim Project !</h1> <br>
        <br>
        <h1 class="text-center hebrew">! ברוכים הבאים לבונה ירושלים פרויקט</h1>
        <br>
        <p class="text-center lead">The first source that allows you to make precise search in all the Tanakh and Talmud.</p>
    </div>

    <h2 class="text-center">Start the exploration :</h2>

    <div class="section2">
        <a href="#">
            <div class="circle">
                <h2 class="category hebrew">תורה</h2>
            </div>
        </a>
    </div>
    <div class="section2 second">
        <a href="#">
            <div class="circle k">
                <h2 class="category hebrew">כתובים</h2>
            </div>
        </a>
        <a href="#">
            <div class="circle n">
                <h2 class="category hebrew">נביים</h2>
            </div>
        </a>
    </div>
    <div class="section2 third">
        <a href="#">
            <div class="circle y">
                <h2 class="category hebrew">תלמוד <br> ירושלמי</h2>
            </div>
        </a>
        <a href="#">
            <div class="circle b">
                <h2 class="category hebrew">תלמוד <br> בבלי</h2>
            </div>
        </a>
    </div>

    <h1 class="text-center statistic" id="statistic">Some statistics</h1>

    <div class="counter-container">
        <div>
            <h1>Words in Talmud Bavli:</h1>
            <div class="incremental-counter" data-value="1822182"></div>
        </div>

        <div>
            <h1>Abbreviations in Talmud Bavli:</h1>
            <div class="incremental-counter" data-value="40359"></div>
        </div>
    </div>

    <script>
        var image = document.getElementsByClassName('parallax');
        new simpleParallax(image, {
            scale: 2.5
        });

        let isInView = $('#statistic').inView('top');
        if (isInView){
            $increment = $(".incremental-counter");
            $increment.incrementalCounter();
        }

        // $increment = $(".incremental-counter");
        // $increment.incrementalCounter();

        $(document).ready(function() {

            var $nav = $("#navbar");
            $nav.addClass('scrolled');

            $(function() {
                $(document).scroll(function() {
                    if ($(this).scrollTop() > $nav.height()) {
                        $nav.removeClass('scrolled', 1000, "linear");
                    } else {
                        $nav.addClass('scrolled');
                    }
                });
            });

            $('#home').addClass('active');

        });
    </script>
</body>

</html>