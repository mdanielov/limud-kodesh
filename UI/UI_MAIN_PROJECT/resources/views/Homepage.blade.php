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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.2/animate.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.2/animate.min.css">
    <link rel="stylesheet" href="public/css/home.css">

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
        <h1 class="text-center">Welcome to My Limud Project !</h1> <br>
        <br>
        <h1 class="text-center hebrew">!ברוכים הבאים לפרוייקט לימוד שלי</h1>
        <br>
        <div class="description">
            <p class="text-center text-justify">“My Limud” is an effort to make Torah learning accessible to all Jews around the world. Even though when we learn Torah we make a “kinian” – i.e. take ownership of it, still it isn’t our personal property. It belongs to all Israel. To this end we will make an effort to give you all the tools necessary to make your own journey.</p>
        </div>
    </div>

    <div class="container-text">
        <div class="text1 animated">
            <i class="fas fa-search fa-5x"></i> <br>
            <h3 class="text-center">Searching and Browsing</h3>
            <p class="text-justify">“My limiud” allows you to search words, cross references, sugia in talmud, book or a word definition.
                We have also included a browsing option so that you can browse by category, book category, book chapter and verses.
            </p>
        </div>

        <div class="text2 animated">
            <i class="fas fa-question-circle fa-5x"></i> <br>
            <h3 class="text-center">Who can use it ?</h3>
            <p class="text-justify">My Limud is meant for all Jewish Souls in their present incarnation.
            </p>
        </div>
    </div>

    <h2 class="text-center" id="start">Start the exploration :</h2>


    <div class="section2">
        <a href="/tanakh/torah">
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
        <a href="tanakh/neviim">
            <div class="circle n">
                <h2 class="category hebrew">נביאים</h2>
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
            <h1>Words in Tanakh:</h1>
            <div class="incremental-counter" data-value="306781"></div>
        </div>
    </div>
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

        $increment = $(".incremental-counter");
        $increment.incrementalCounter();

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

            function isScrolledIntoView(elem) {
                var height = $(window).height()
                var docViewTop = $(window).scrollTop();
                return docViewTop / height >= 0.11;
            }


            $(window).scroll(function() {
                $(".text1.animated").each(function() {
                    if (isScrolledIntoView(this) === true) {
                        $(this).addClass("fadeInLeft");
                    }
                });
                $(".text2.animated").each(function() {
                    if (isScrolledIntoView(this) === true) {
                        $(this).addClass("fadeInRight");
                    }
                });
            });
        });
    </script>

    <div class="Footer">

        <li></li>
        <li></li>
        <li></li>
        <button data-id="btn6" class="btn btn6"><div id="circle"></div><span>Stay in touch</span></button>
        <button data-id="btn6" class="btn btn6"><div id="circle"></div><span>Mor about us</span></button>
        <h6 class="AllRights">| &copy all rights deserved to Zeved tov LTD |</h6>

    </div>

</body>

</html>
