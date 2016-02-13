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
* ["Flight Picker](rails/flight-picker), a Rails app in which users can filter flights by origin, destination, and departure date and create a booking for one or more passengers on that flight. (No login, payment, etc; all data is randomly seeded.)
