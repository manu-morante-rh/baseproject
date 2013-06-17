set :application, "base_project"
set :repository,  "svn://svn.nuatt.es/base_project/trunk"
set :deploy_to, "/var/www/#{application}"

set :user, "baseuser"
set :use_sudo, false

set :stage, "staging" unless variables[:stage]
case stage
when "staging"
  server "newdev.nuatt.es", :app, :web, :db, :primary => true
when "production"
  server "prod1.nuatt.es", :app, :web, :db, :primary => true
else
  raise "unsupported staging environment: #{stage}"
end

after 'deploy:update_code', 'other:symlink'
after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:update_code', 'sunspot:restart'

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "cd #{current_path} && passenger stop -p 3044"
    run "cd #{current_path} && passenger start -a 127.0.0.1 -p 3044 -d -e #{stage}"

    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :sunspot do
  task :restart do
    p "********************** SUNSPOT:RESTART ******************************"
    begin
      run "cd #{release_path} && rake sunspot:solr:stop RAILS_ENV=#{stage} && rake sunspot:solr:start RAILS_ENV=#{stage}"
    rescue
      run "cd #{release_path} && rake sunspot:solr:start RAILS_ENV=#{stage}"
    end
  end
end

namespace :other do
  task :symlink do
    p "********************** OTHER:SYMLINK ******************************"
    shared_log_path = "#{shared_path}/log"

    run("mkdir -p #{shared_log_path} && ln -nfs #{shared_log_path} #{release_path}/log")
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end

  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end

  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end
