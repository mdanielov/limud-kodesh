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
        <div class="description">
            <p class="text-center text-justify">“Bone Yerushalayim” is an effort of a top quality team of Jewish studies scholars and a group of IT-Professionals to create a large library of the essential “sifrei kodesh”, with the user in mind.
                The highlight of “Bone Yerushalayim” software is its sophisticated search engine, which allows maximum accessibility to the content of sifrei kodesh, simply by typing a word or sequence of words.</p>
        </div>
    </div>

    <div class="container-text">
        <div class="text1 animated">
            <i class="fas fa-search fa-5x"></i> <br>
            <h3 class="text-center">Searching and Browsing</h3>
            <p class="text-justify">“Bone Yerushalayim” allows you to search words, cross references, sugia in talmud, book or a word definition.
                We have also included a browsing option so that you can browse by category, book category, book chapter and verses.
            </p>
        </div>

        <div class="text2 animated">
            <i class="fas fa-question-circle fa-5x"></i> <br>
            <h3 class="text-center">Who can use it ?</h3>
            <p class="text-justify">Bone Yerushalayim is a great platform that can serve a wide range of users - from individuals, talmidei chachamim and Judaic researchers, to institutions.
            </p>
        </div>
    </div>

    <h2 class="text-center" id="start">Start the exploration :</h2>


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
</body>

</html>