namespace :gor do
  desc 'Install dependent Golang packages'
  task :deps do
    puts 'Beginning to install Go deps...'
    system "go get \
    github.com/jmoiron/sqlx \
    gopkg.in/gin-gonic/gin.v1 \
    github.com/mattn/go-sqlite3 \
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
end
