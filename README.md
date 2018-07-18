# Bowling scores calculator

A simple Ruby command-line application to calculate the scores of bowling games

## Getting Started

These instructions will get the project up and running on your local machine

### Prerequisites

```
Ruby 2.3.6 (it should work just fine with higher versions)
```

### Installing

##### via zip file

Extract all the content of the zip file

##### via git clone

clone the project

```
$ git clone https://github.com/yonnyquiceno/bowling_score_calculator.git
```
now cd into the project root folder

```
$ cd bowling_score_calculator
```
Install bundler

```
gem install bundler
```

Install the gems

```
bundle install
```

## Usage

The application takes a text file as input were each line follows the format:
`<player name> <score> `
so a valid example would be:

```
Jeff 10
John 3
John 6
Jeff 2
...
```

You'll need to put the text file into the application root folder and then run: 

`ruby bowling_scores.rb -f <filename>.txt`

There's already a sample file on the application folder, so if you run: 

`ruby bowling_scores.rb -f sample-game.txt`

You should see this output representing the final game scoreboard: 
```
"Frame     1         2         3         4         5         6         7         8         9         10        "
"Jeff"
"Pinfalls       X    7    /    9    0         X    0    8    8    /    F    6         X         X    X    8    1    "
"Score     20        39        48        66        74        84        90        120       148       167       "
"John"
"Pinfalls  3    /    6    3         X    8    1         X         X    9    0    7    /    4    4    X    9    0    "
"Score     16        25        44        53        82        101       110       124       132       151       "
```


You can always run `ruby bowling_scores.rb -h` to see the available options

## Running the tests

The application uses Rspec for testing, in order to run the test suite you just need to run

```
$ rspec
```

### coding style tests

The application uses Rubocop for coding style tests, in order to run them excecute:

```
$ Rubocop
```

## Author

**Alexander Quiceno** - [github](https://github.com/yonnyquiceno)
