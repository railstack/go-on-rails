<img align="right" width="260" height="260" src="./go-on-rails.png">

go-on-rails
====

go-on-rails aims at three scenarios:

1. Integrate some APIs written in Golang to existed Rails app for high performance
2. Use your farmiliar Rails tools to develope and manage a Golang app project
3. Convert a *not very complicated* Rails app to Golang equivalent

Here's a simple [example(tutorial)](https://github.com/goonr/example_simple) shows the basic usage of go-on-rails generator, and some real-world examples are coming soon.

## Prerequisites

* Rails development environment
* Golang development environment

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'go-on-rails', '~> 0.1.0'
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

Then change to the `go_app` directory and run:

```bash
go run main.go
```

You can visit the page in http://localhost:3000 by default.

More command details about go-on-rails generator:

```bash
rails g gor --help
```

## What will be generated?

* Go project directory layout (all under the `go_app` directory, like `views`, `controllers`, `public`)
* A Go data struct corresponding to each activerecord model
* And each struct related CRUD functions/methods like FindModel, UpdateModel, DestroyModle etc. All these models related program files under the `go_app/models` directory
* We use [Gin](https://github.com/gin-gonic/gin) as the default web framework, but you can change it to anyone that you favor in `main.go` and `controllers` programs

And the gem is still under development, so there're a lot of known issues.

## Known issues and TODOs

* databases specific functions between MySQL, Postgres are not covered yet
* sql.NullType not supported yet, so you'd better in the migrations set those columns "not null" with a default value that's consistent with Golang's zero value specification, such as "" default for string and text typed column, and 0 default for int, etc.

- [x] Associations
  - [x] has_many
  - [x] has_one
  - [x] belongs_to
  - [x] dependent
- [x] Validations
  - [x] length
  - [x] presence
  - [x] format(string only)
  - [x] numericality(partially)
  - [ ] other validations
- [ ] Callbacks

## Golang dependencies by default

* `github.com/jmoiron/sqlx`: an extension on the standard `database/sql` database API library
* `github.com/mattn/go-sqlite3`: a SQLite driver
* `github.com/go-sql-driver/mysql`: a MySQL driver
* `github.com/lib/pq`: a PostgreSQL driver
* `github.com/asaskevich/govalidator`: for the struct validation
* `gopkg.in/gin-gonic/gin.v1`: a HTTP web framework

## Acknowledgement

When I had the idea to convert Rails app or build Golang app with Rails tools, I searched github and found the project: https://github.com/t-k/ar2gostruct. And from ar2gostruct I copied some codes on handling data structure convertion and models association, it make my idea come true faster than I imagined.

## Contributing

There're two branches at present: `master` and `dev`.

The `dev` branch has a whole Rails environment for development: models, seeds for testing, and under `go_app` directory there's a file named `modles_test.go` used to test generated Golang codes.

- Fork the project switch to branch `dev`.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a future version unintentionally.
- Commit, do not mess with Rakefile or version (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## License

See the [LICENSE](https://github.com/goonr/go-on-rails/blob/master/MIT-LICENSE) file.
