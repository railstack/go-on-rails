<img align="right" width="255" height="255" src="./go-on-rails.png">

go-on-rails
====

go-on-rails aims at three scenarios:

1. Integrate some APIs written in Golang to existed Rails app for high performance
2. Use your farmiliar Rails tools to develope and manage a Golang app project
3. Convert a *not very complicated* Rails app to Golang equivalent

One or more examples will be given later on.

## Prerequisites

* Rails development environment
* Golang development environment

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'go-on-rails', '~> 0.0.5'
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

You must have a Rails app or to create one before you can try go-on-rails generator to convert a Rails app to Golang codes.

You can just run the command to convert the application:

```bash
rails g gor [dev(elopment) | pro(duction) | test] [-m model_a model_b model_c ...]
```

Then a directory named "go_app" with Golang codes will be generated under your Rails app root path.

Install the dependent Golang packages:

```bash
rails gor:deps
```

Then change to the "go_app" directory and run:

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
* databases specific functions between mysql, postgres are not covered yet
* model callbacks are not available
* sql.NullType not supported yet, so you'd better in the migrations set those columns "not null" with a default value that's consistent with Golang's zero value specification, such as "" default for string and text typed column, and 0 default for int, etc.

Really a lot...

## Acknowledgement

When I had the idea to convert Rails app or build Golang app with Rails tools, I searched github and found the project: https://github.com/t-k/ar2gostruct. And from ar2gostruct I copied some codes on handling data structure convertion and models association, it make my idea come true faster than I imagined.

## Contributing

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a future version unintentionally.
- Commit, do not mess with Rakefile or version (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## License

See the [LICENSE](https://github.com/goonr/go-on-rails/blob/master/MIT-LICENSE) file.
