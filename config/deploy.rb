set :stages, %w(production staging)
require 'capistrano/ext/multistage'

server "173.230.136.27", :app, :web, :db, :primary => true

set(:application) { "casecreed_#{stage}" }
set (:deploy_to) { "/home/mohit/apps/#{application}" }
set :user, 'mohit'
set :keep_releases, 3
set :repository, "git@github.com:piemesons/casecreed.git"
set :use_sudo, false
set :scm, :git
default_run_options[:pty] = true
ssh_options[:forward_agent] = false
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

namespace :deploy do
 desc "Restarting mod_rails with restart.txt"
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "touch #{current_path}/tmp/restart.txt"
 end

 [:start, :stop].each do |t|
   desc "#{t} task is a no-op with mod_rails"
   task t, :roles => :app do ; end
 end

 desc "invoke the db migration"
 task:migrate, :roles => :app do
   send(run_method, "cd #{current_path} && rake db:migrate RAILS_ENV=#{stage} ")
 end

 desc "Deploy with migrations"
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
    end

    restart
    web.enable
    cleanup
  end

 task :after_symlink, :roles => :app do
   run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
 end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

end

