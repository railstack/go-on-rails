lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
    s.name          = 'go-on-rails'
    s.version       = '0.3.0'
    s.date          = '2018-01-11'
    s.summary       = "Use Rails to Develop or Generate a Golang application"
    s.description   = "Modeling, developing and testing your Golang app with your familiar Rails tools like rails generate, db migration, console etc. It is more meant to help integrating some APIs written in Golang to existed Rails app for high performance."
    s.authors       = ["B1nj0y"]
    s.email         = 'idegorepl@gmail.com'
    s.files         = Dir['MIT-LICENSE', 'README.md', 'lib/**/*']
    s.homepage      = 'https://github.com/railstack/go-on-rails'
    s.license       = 'MIT'
    s.require_paths = ['lib']
end
