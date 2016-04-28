#The Odin Project Exercises

In which I work through the exercises in [http://www.theodinproject.com/](http://www.theodinproject.com/) starting with the Ruby Programming course. Some but not all of the exercises have been modified to keep things interesting.

##[Ruby Programming](http://www.theodinproject.com/ruby-programming/)##

###[Building Blocks Project](http://www.theodinproject.com/ruby-programming/building-blocks/)###
* [Caesar cipher](ruby/building-blocks/caesar-cipher/)
* [Stock picker](ruby/building-blocks/stock-picker/) (given an array of stock prices ordered by date, choose the best dates to buy and sell, without shorting)
* [Substring counter](ruby/building-blocks/substrings/) (using Rabin-Karp algorithm)

###[Advanced Building Blocks Project](http://www.theodinproject.com/ruby-programming/advanced-building-blocks/)###
* [Bubble sort](ruby/advanced-building-blocks/bubble_sort/)
* [Fake enumerable methods](ruby/advanced-building-blocks/enumerable_methods/) (Define imitations of various enumerable methods; DTRT when called with or without a block)

###[Object-Oriented Programming Project](http://www.theodinproject.com/ruby-programming/oop/)###
* [Tic-tac-toe](ruby/oop/tic-tac-toe/) (with AI; allows arbitrary board size, though AI is impractically slow for board larger than 3x3)
* [Mastermind](ruby/oop/mastermind/) (with AI)

###[Serialization and Working with Files](http://www.theodinproject.com/ruby-programming/file-i-o-and-serialization/)###
* [Hangman](ruby/file-i-o/hangman/)

###[Ruby on the Web](http://www.theodinproject.com/ruby-programming/ruby-on-the-web/)###
* [Toy server and browser](ruby/ruby-on-the-web/server-and-browser/)

###[Recursion](http://www.theodinproject.com/ruby-programming/recursion/)###
* [Fibonacci sequence](ruby/recursion/fibonacci/)
* [Merge sort](ruby/recursion/merge_sort/)

###[Data Structures and Algorithms](http://www.theodinproject.com/ruby-programming/data-structures-and-algorithms/)###
* [Searching binary trees](ruby/data-structures-and-algorithms/binary_search_trees/) (with red-black tree, though deletion is not implemented)
* [Knight's path](ruby/data-structures-and-algorithms/knights_travails/) (find shortest path to take knight from one point to another - NOT the knight's tour)

###[Testing Ruby with RSpec](http://www.theodinproject.com/ruby-programming/testing-ruby/)
* Added more tests for Building Blocks, Advanced Building Blocks, and Tic-Tac-Toe projects
* [TDD Connect Four](ruby/testing-ruby/connect-four/)

###[Final Project](http://www.theodinproject.com/ruby-programming/ruby-final-project)
* [Chess](https://github.com/cdouglass/odin-project-exercises/tree/master/ruby/chess) Two-player command-line chess program, in progress. Not implemented yet: history-based move validations, pawn promotion, mate detection, or draws.

##[Ruby on Rails](http://www.theodinproject.com/ruby-on-rails/)##

###[Building with Active Record](http://www.theodinproject.com/ruby-on-rails/building-with-active-record/)
* ["Micro-Reddit"](rails/micro-reddit/), a Rails app with no front end. Has appropriately associated user, post, and comment models; tests in Test::Unit; and uniqueness and foreign key contraints at ActiveRecord and database levels.

###[Forms and Authentication](http://www.theodinproject.com/ruby-on-rails/authentication/)
* ["Members Only"](rails/members-only/), a Rails app in which users can create and see posts. Only logged-in users may make posts or view a post's author.

###[Active Record Associations](http://www.theodinproject.com/ruby-on-rails/associations)
* ["Private Events"](rails/private-events), a Rails app in which users can create and be invited to events (so are associated with events in two distinct capacities).

###[Advanced Forms](http://www.theodinproject.com/ruby-on-rails/building-advanced-forms)
* ["Flight Booker"](rails/flight-booker), a Rails app in which users can filter flights by origin, destination, and departure date and create a booking for one or more passengers on that flight. (No login, payment, etc; all data is randomly seeded.)

###[Final Project](http://www.theodinproject.com/ruby-on-rails/final-project)
* ["Social Network"](rails/social-network), a Rails app implementing a basic social network with friendships, posts, comments, etc. Uses Devise and `omniauth-facebook` for sign-in. Uses Paperclip for user profile photo upload. Demo on [Heroku](https://pure-meadow-87105.herokuapp.com/). All features in the assignment are done but it's still unstyled and rough around the edges. Test suite is extensive.

##[HTML5 and CSS3](http://www.theodinproject.com/html5-and-css3)##

###[Embedding Video](http://www.theodinproject.com/html5-and-css3/embedding-images-and-video)
* ["Fake YouTube"](html-css/embedding-images-and-video), a rough imitation of YouTube's video page with embedded media elements. Video and sidebar look reasonable and are responsive. Rest of page is left as a skeleton. View [here](https://htmlpreview.github.io/?https://github.com/cdouglass/odin-project-exercises/blob/master/html-css/embedding-images-and-video/faketube.html).

###[HTML Forms](http://www.theodinproject.com/html5-and-css3/html-forms)
* [Clone of Mint.com's signup page](html-css/html-forms). Not implemented: interactivity, checkbox styling, lock icon in password box, and exact position of nav dividers. Otherwise pixel-perfect, at least in Firefox. View [here](https://htmlpreview.github.io/?https://github.com/cdouglass/odin-project-exercises/blob/master/html-css/html-forms/signup.html).

##[JavaScript and jQuery](http://www.theodinproject.com/javascript-and-jquery)##

###[On-Screen Calculator](http://www.theodinproject.com/javascript-and-jquery/on-screen-calculator)
* [Responsive in-browser calculator](javascript/calculator/) using jQuery. Parsing done with shunting-yard algorithm; unit and integration tests with Mocha and Chai; integration tests with ZombieJS. View [here](https://rawgit.com/cdouglass/odin-project-exercises/master/javascript/calculator/app/calculator.html).

###[Tabbed Content](http://www.theodinproject.com/javascript-and-jquery/manipulating-the-dom-with-jquery)
* [Fake restaurant website](javascript/dom-manipulation/) with tabbed content using jQuery. View [here](https://rawgit.com/cdouglass/odin-project-exercises/master/javascript/dom-manipulation/tabs.html).

###[Snake Game](http://www.theodinproject.com/javascript-and-jquery/jquery-and-the-dom)
* [Clone](javascript/snake/) of the classic Snake game. Play [here](https://rawgit.com/cdouglass/odin-project-exercises/master/javascript/snake/app/snake.html).

###[Image Carousel](http://www.theodinproject.com/javascript-and-jquery/creating-an-image-carousel-slider)
* [Image carousel page](javascript/image-carousel/) using jQuery to transition between slides. View [here](https://rawgit.com/cdouglass/odin-project-exercises/master/javascript/image-carousel/carousel.html).
