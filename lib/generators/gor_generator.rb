class GorGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :env_name, type: :string, default: "development"
  class_option :models, type: :array, default: [], aliases: '-m'
  class_option :only_models, type: :boolean, default: false, aliases: '-o', description: "only generate models"

  def generate_gor
    env_names = ActiveRecord::Base.configurations.keys
    rails_env = case env_name
                when "dev"
                  "development"
                when "pro"
                  "production"
                else
                  env_name
                end

    unless env_names.include? rails_env
      printf("Invalid env argument \"%s\": Not in the available list %p\n\n", rails_env, env_names)
      exit
    end

    @models = options[:models]
    if @models.empty?
      @models = get_all_models "app/models"
    else
      @models.map!(&:camelize)
    end
    puts "Rails env: [#{rails_env}]"
    puts "The models: #{@models} will be converted to a Golang App!"

    # read the database configuration
    @db_config = {}
    read_database_config(rails_env)

    @all_structs_info = {}
    # iterate the models to get all the structs' info
    @models.each do |m|
      begin
        klass = m.split('::').inject(Object) { |kls, part| kls.const_get(part) }
        if klass < ActiveRecord::Base && !klass.abstract_class?
          convertor = GoOnRails::Convertor.new(klass, @models, @db_config[:driver_name])
          @all_structs_info[klass.to_s] = convertor.convert
        end
      rescue Exception => e
        puts "Failed to convert the model [#{m}]: #{e.message}"
      end
    end

    # iterate the structs info to generate codes for each model
    @all_structs_info.each do |k, v|
      @model_name, @struct_info = k, v
      if @db_config[:driver_name] == "postgres"
        template "gor_model_postgres.go.erb", "go_app/models/gor_#{@model_name.underscore}.go"
      else
        template "gor_model_mysql.go.erb", "go_app/models/gor_#{@model_name.underscore}.go"
      end
    end

    # generate program for database connection
    template "db.go.erb", "go_app/models/db.go"
    # and utils
    template "utils.go.erb", "go_app/models/utils.go"

    unless options[:only_models]
      # generate the main.go
      copy_file "main.go", "go_app/main.go"
      # generate the controllers and views dir
      template "home_controller.go.erb", "go_app/controllers/home_controller.go"
      copy_file "index.tmpl", "go_app/views/index.tmpl"
      copy_file "favicon.ico", "go_app/public/favicon.ico"
      # generate config files for make and dockerization
      template "docker-compose.yml.erb", "docker-compose.yml"
      template "Dockerfile.go_app.erb", "go_app/Dockerfile"
      copy_file "Makefile", "go_app/Makefile"
    end

    # use gofmt to prettify the generated Golang files
    gofmt_go_files

    # generate go docs for models
    generate_go_docs
  end

  private

  def get_all_models model_dir
    Dir.chdir(model_dir) do
      Dir["**/*.rb"]
    end.map { |m| m.sub(/\.rb$/,'').camelize } - ["ApplicationRecord"]
  end

  def read_database_config rails_env
    @db_config = Rails.configuration.database_configuration[rails_env].symbolize_keys
    @db_config[:host] ||= "localhost"
    case @db_config[:adapter]
    when "sqlite3"
      @db_config[:driver_name] = "sqlite3"
      @db_config[:dsn] = Rails.root.join(@db_config[:database]).to_s
      @db_config[:driver_package] = "_ \"github.com/railstack/go-sqlite3\""
    when "mysql2"
      @db_config[:driver_name] = "mysql"
      @db_config[:port] ||= "3306"
      # MySQL DSN format: username:password@protocol(address)/dbname?param=value
      # See more: https://github.com/go-sql-driver/mysql
      format = "%s:%s@tcp(%s:%s)/%s?charset=%s&parseTime=True&loc=Local"
      @db_config[:dsn] = sprintf(format, *@db_config.values_at(:username, :password, :host, :port, :database, :encoding))
      @db_config[:driver_package] = "_ \"github.com/go-sql-driver/mysql\""
    when "postgresql"
      @db_config[:driver_name] = "postgres"
      @db_config[:port] ||= "5432"
      format = "host=%s port=%s user=%s dbname=%s sslmode=disable password=%s"
      @db_config[:dsn] = sprintf(format, *@db_config.values_at(:host, :port, :username, :database, :password))
      @db_config[:driver_package] = "_ \"github.com/lib/pq\""
    end
  end

  def gofmt_go_files
    go_files = Rails.root.join('go_app', 'models/*.go').to_s
    system "gofmt -w #{go_files} > /dev/null 2>&1"
  end

  def generate_go_docs
    models_dir = Rails.root.join('go_app', 'models').to_s
    return unless Dir.exist?(File.expand_path(models_dir))
    doc_dir = File.join(models_dir, "doc")
    Dir.mkdir(doc_dir) unless Dir.exist?(doc_dir)
    system "godoc -html #{models_dir} | awk '{ gsub(\"/src/target\", \"\"); print }' > #{doc_dir}/models.html"
  end
end

require 'generators/gor/converter'
