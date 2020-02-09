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
</head>

<body>


    <div>
        <img src="{{ URL::asset('img/sefer.jpg') }}" class="parallax">
    </div>

    <div class="section1">
        <h1 class="text-center">Welcome to the Bone Yerushalayim Project</h1> <br>
    </div>

    <script>
        var image = document.getElementsByClassName('parallax');
        new simpleParallax(image, {
            scale: 2.5
        });

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