require 'bundler/capistrano'
# runtime dependencies
depend :remote, :gem, "bundler"

set :application, "artsready"


#options necessary to make Ubuntu’s SSH happy
ssh_options[:paranoid]    = false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :repository,  "git@github.com:fracturedatlas/ArtsReady.git"

set :scm, "git"
set :branch, "develop"
set :deploy_via, :remote_cache

set :user, "johnpaul"  # The server's user for deploys
set :password, "@rtsR3ady!"
#set :scm_passphrase, "@rtsR3ady!"  # The deploy user's password

role :web, "50.19.225.94"                          # Your HTTP server, Apache/etc
role :app, "50.19.225.94"                          # This may be the same as your `Web` server
role :db,  "50.19.225.94", :primary => true # This is where Rails migrations will run

# add email addresses for people who should receive deployment notifications
set :notify_emails, ["johnpaul@transitionpoint.com", "kirsten.nordine@fracturedatlas.org", "justin.karr@fracturedatlas.org", "gary.moore@fracturedatlas.org"]

# Create task to send a notification
namespace :deploy do
  desc "Send email notification"
  task :send_notification do
    Notifier.deploy_notification(self).deliver_now
  end
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:symlink", "deploy:common_symlinks"
after :deploy, 'deploy:send_notification'

namespace :deploy do
  desc "Symlink to common files "
  task :common_symlinks do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/system #{release_path}/public"
  end
end

require './config/boot'
require './config/deploy/cap_notify.rb'


        require './config/boot'
        require 'airbrake/capistrano'
