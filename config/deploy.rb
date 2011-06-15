set :application, "artsready"


#options necessary to make Ubuntu’s SSH happy
ssh_options[:paranoid]    = false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :repository,  "git@github.com:fracturedatlas/ArtsReady.git"

set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "johnpaul"  # The server's user for deploys
set :password, "@rtsR3ady!"
#set :scm_passphrase, "@rtsR3ady!"  # The deploy user's password

role :web, "50.19.225.94"                          # Your HTTP server, Apache/etc
role :app, "50.19.225.94"                          # This may be the same as your `Web` server
role :db,  "50.19.225.94", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

after "deploy:symlink", "deploy:common_symlinks"

namespace :deploy do
  desc "Symlink to common files "
  task :common_symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/system #{release_path}/public"
  end
end
