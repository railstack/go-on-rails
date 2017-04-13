go-on-rails
====

## Prerequisites

* Rails development environment
* Golang development environment

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'go-on-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install go-on-rails
```
## Usage

go-on-rails is a Rails generator used to generate Golang codes from your ever running Rails app or an application that you would create with familiar Rails command tools. One or more examples will be given later on.

So you must have a Rails app or to create one before you can use go-on-rails generator to convert a Rails app to Golang codes.

You can basically run the command to convert the application:

```bash
rails g gor [dev(elopment) | pro(duction) | test] [-m model_a model_b model_c ...]
```

Then a directory named "go_app" with Golang codes will be generated under your Rails app root path.

Install the dependent Golang packages:

```bash
rails gor:deps
```

Then change to the "go_app" directory, and run:

```bash
go run main.go
```

You can visit the page in http://localhost:3000 by default.

More command details about go-on-rails generator:

```bash
rails g gor --help
```

And the gem is still under development, so there're a lot of known issues.

## Known issues and TODOs

* the generated Golang codes includes the association between models, basic relations like has_many, has_one, belongs_to have been supported
* so some association functions is available
* and the :dependent action is triggered when destroying some related model
* but the :through keyword not supported yet
* databases specific functions between mysql, postgres are not covered yet
* model callbacks is not available

Really a lot...

## Acknowledgement

When I had the idea to convert Rails app or build Golang app with Rails tools, I searched github and found the project: https://github.com/t-k/ar2gostruct. And from ar2gostruct I copied some codes on handling data structure convertion and models association, it make my idea come true faster than I imagined.

## Contributing

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a future version unintentionally.
- Commit, do not mess with Rakefile or version (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

