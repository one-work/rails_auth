require 'bundler/setup'
require 'sdoc'
require 'rdoc/task'

RDoc::Task.new(:sdoc) do |rdoc|
  rdoc.rdoc_dir = 'docs'
  rdoc.title = 'RailsAuth'
  rdoc.options << '--format=sdoc'
  rdoc.options << '-g'
  rdoc.template = 'rails'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('app/models/**/*.rb')
end

APP_RAKEFILE = File.expand_path('test/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'


Bundler::GemHelper.install_tasks
