namespace :gor do
  desc 'Install dependent Golang packages'
  task :deps do
    puts 'Beginning to install Go deps...'
    system "go get \
    github.com/jmoiron/sqlx \
    github.com/gin-gonic/gin \
    github.com/goonr/go-sqlite3 \
    github.com/go-sql-driver/mysql \
    github.com/lib/pq \
    github.com/asaskevich/govalidator"
    puts 'Installation completed!'
  end

  desc 'Gofmt the generated codes on models'
  task :fmt do
    go_files = Rails.root.join('go_app', 'models/*.go').to_s
    system "gofmt -w #{go_files} > /dev/null 2>&1"
  end

  desc 'View the doc of all the functions generated on models'
  task :doc do
    models_dir = Rails.root.join('go_app', 'models').to_s
    puts 'Please open "http://localhost:7979/doc/models.html" to view the doc of all functions generated on models.'
    puts 'Use Ctrl-C to terminate this server!'
    if RUBY_PLATFORM =~ /darwin/
      system 'open http://localhost:7979/doc/models.html'
    elsif RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
      system 'start http://localhost:7979/doc/models.html'
    end
    system "godoc -goroot #{models_dir} -http=:7979"
  end
end
