# Mastermind

This project is a command line game of Mastermind built in Ruby.

An assignment in:
[The Odin Project](https://www.theodinproject.com/) > [Ruby Programming](https://www.theodinproject.com/courses/ruby-programming) > [Intermediate Ruby](https://www.theodinproject.com/courses/ruby-programming#intermediate-ruby) > [OOP](https://www.theodinproject.com/courses/ruby-programming/lessons/oop).


## What is Mastermind?

A two-player game, where the _codemaker_ picks a code and the _codebreaker_ figures out the code. 

The original _Mastermind_ was a board game, where the code is a sequence of 4 colors picked from 6 possible colors, and you have 12 guesses to figure out the code. After each guess, you are told how many of your 4 colors are:
- the correct color in the correct position
- the correct color in a wrong position
- a wrong color

With these hints, the codebreaker tries to figure out the code with 12 guesses or less.


## My version of Mastermind

In my version, you play against a computer. And instead of colors, you pick 4 numbers in the range `[1..6]`. Otherwise the rules are the same: you have 12 guesses to figure out the code, and after each guess you get the hints described above.

You can play as either the codemaker or the codebreaker.