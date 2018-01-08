[![Gem Version](https://badge.fury.io/rb/go-on-rails.svg)](https://badge.fury.io/rb/go-on-rails)
[![Build Status](https://travis-ci.org/goonr/go-on-rails.svg?branch=dev)](https://travis-ci.org/goonr/go-on-rails)

<img align="right" width="260" height="260" src="./go-on-rails.png">

go-on-rails
====

`go-on-rails` 是一个 Rails 的 generator，其目标功能主要有：

1. 对于 Rails 应用中的某些需要高性能的接口，使用 go-on-rails 来生成代码，并把生成的 Go 接口集成进 Rails 项目进行替换
2. Rails 程序员可以使用熟悉的工具链开发和管理一个 Golang 的项目

下面是几个示例教程：
* [简单示例](https://github.com/goonr/example_simple) 仿照 Rails guides 里那个入门的 [demo](http://guides.rubyonrails.org/getting_started.html)，演示如何使用 go-on-rails 创建和生成一个简单 blog 的 Go API。
* [高级教程](https://github.com/goonr/example_with_admin)  如何创建一个 Go 项目，并和 rails_admin, devise, cancancan 等集成，为 Go 项目快速增加一个管理后台。同时该项目演示了如何使用 Rails 5.1 新发布的 webpacker 工具，并利用 React 制作独立的前端界面在 Rails 中调用 Go 接口。
* [如何从 Go API 读取 Rails session](https://github.com/goonr/example_read_rails_session) 讲述如何在一个 go-on-rails 生成的 Go 接口中读取 Rails 的 session 做用户验证，以便于将需要用户验证的 Go API 集成进 Rails 项目

## 安装环境要求

* Rails 4.2 及以上
* Go 1.5 及以上

## 安装

在 Rails 项目的 Gemfile 中添加下面一行:

```ruby
gem 'go-on-rails', '~> 0.2.0'
```

然后运行:
```bash
$ bundle
```

## 用法

在运行生成 Go 代码的命令之前，你得保证在 Rails 中至少已经创建了一个 Model，然后运行如下格式的命令来生成 Go 代码：

```bash
rails g gor [dev(elopment) | pro(duction) | test] [-m model_a model_b model_c ...]
```

运行后会在 Rails 项目的根目录生成一个 `go_app` 的文件夹。

接下来运行命令安装这个 Go 项目默认依赖的包：

```bash
rails gor:deps
```

然后进入到 `go_app` 目录下，启动 Go 服务器：

```bash
cd go_app
go run main.go
```

这时可以在浏览器中访问 http://localhost:4000 ，正常的话会看到一个类似新建的 Rails 项目的默认首页。

关于这个生成器命令行的更多用法可以查看 go-on-rails 的帮助选项：

```bash
rails g gor --help
```

## 该命令都会生成些什么？

* 一个 Go 项目的目录布局（所有程序都在 `go_app` 文件夹下，在其下面包括如 `views`、 `controllers`、 `public` 等文件夹）
* 针对每个 activerecord 的 Model 生成相应的 Go 数据结构
* 同时针对每个数据结构生成相关的 CRUD 函数／方法，如 FindModel, UpdateModel, DestroyModle 等等。所有这些 Model 相关的代码都生成在 `go_app/models` 目录下。
* 在文件夹 `go_app/models/doc` 下生成的所有函数的 godoc 文档
* 我们默认使用 [Gin](https://github.com/gin-gonic/gin) 作为我们的 Web 框架，你也可以通过改动 `main.go` 以及 `controllers` 等文件来使用你喜欢的框架，同时配合使用生成的 Model 相关的函数

### 查看生成函数(方法)的 godoc

可以通过运行如下命令在浏览器中查看所有生成的函数文档：

```bash
rails gor:doc
```

浏览器地址为：http://localhost:7979/doc/models.html 。

另外，这里有一个生成好的[示例项目](https://github.com/goonr/gor_models_sample)，在 godoc.org 可以浏览该示例项目的 godoc 文档，[详情](https://github.com/goonr/gor_models_sample)。

## 已知问题

* 没有针对不同的数据库，比如 MySQL, Postgres 分别生成其不同的版本
* 没有支持 sql.NullType 的数据类型，所以如果某个表中的字段出现 Null 时程序可能会出错，所以目前临时的做法是：你最好在 migration 中定义好 "not null"，给一个和 Go 的数据类型的零值相一致的默认值。同时，我们给出了一个使用零值的解决方案，详见 wiki: [Working with database nullable fields](https://github.com/goonr/go-on-rails/wiki/Working-with-database-nullable-fields) 。

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
- [x] Pagination(details see [wiki](https://github.com/goonr/go-on-rails/wiki/Pagination))
- [ ] Callbacks
- [ ] Transactions

## Wiki

* [内置的分页 Helper](https://github.com/goonr/go-on-rails/wiki/Pagination)
* [如何处理数据库的 NULL 值](https://github.com/goonr/go-on-rails/wiki/Working-with-database-nullable-fields)
* [几条 Make 命令](https://github.com/goonr/go-on-rails/wiki/Some-Make-commands)
* [如何使用 Docker 发布 Go on Rails 应用](https://github.com/goonr/go-on-rails/wiki/Dockerize-a-Go-on-Rails-application)

## 默认需要的 Go 依赖包

* [github.com/jmoiron/sqlx](https://github.com/jmoiron/sqlx): 标准 `database/sql` API 库的一个扩展版本
* [github.com/goonr/go-sqlite3](https://github.com/goonr/go-sqlite3): SQLite driver(这是 [mattn/go-sqlite3](https://github.com/mattn/go-sqlite3) 的一个 fork 版本，这里有说明[为什么我们使用这个 fork 的版本](https://github.com/mattn/go-sqlite3/pull/468))
* [github.com/go-sql-driver/mysql](https://github.com/go-sql-driver/mysql): 一个 MySQL driver
* [github.com/lib/pq](https://github.com/lib/pq): 一个 PostgreSQL driver
* [github.com/asaskevich/govalidator](https://github.com/asaskevich/govalidator): 一个用作数据验证的包
* [github.com/gin-gonic/gin](https://github.com/gin-gonic/gin): 一个易用的高性能 Web 框架


## 许可证

详见 [许可文件](https://github.com/goonr/go-on-rails/blob/master/MIT-LICENSE)。
