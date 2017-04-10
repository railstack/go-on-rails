namespace :gor do
  desc 'Install dependent Golang packages'
  task :deps do
    puts 'Beginning to install Go deps...'
    system "go get \
    github.com/jmoiron/sqlx \
    github.com/gorilla/handlers \
    github.com/gorilla/mux \
    github.com/mattn/go-sqlite3 \
    github.com/go-sql-driver/mysql \
    github.com/lib/pq"
    puts 'Installation completed!'
  end
end
