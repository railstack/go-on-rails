class Go::On::Rails::Railtie < Rails::Railtie
  rake_tasks do
    load "tasks/gor.rake"
  end
end
