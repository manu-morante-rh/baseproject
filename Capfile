require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p392@base_project' # Defaults to 'default


load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Uncomment if you are using Rails' asset pipeline
# load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasksManu:base_project admin$ 