# config valid for current version and patch releases of Capistrano
lock "~> 3.14.0"

set :application, "email"
set :repo_url, "git@github.com:ThanhKhoaIT/email-hooking.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/email'

set :passenger_restart_with_touch, true

append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", ".bundle"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
#
namespace :bundle do
  before 'deploy:finished', 'bundle:install'

  task :install do
    on roles(:app) do
      within current_path do
        execute :bundle, :install
      end
    end
  end
end

namespace :sidekiq do
  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        execute :pkill, '-f', :sidekiq
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec sidekiq  -d -e #{fetch(:stage)} -l log/sidekiq.log"
      end
    end
  end
end

namespace :smtp do
  task :restart do
    invoke 'smtp:stop'
    invoke 'smtp:start'
  end

  before 'deploy:finished', 'smtp:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        execute :pkill, '-f', :smtp_service
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        execute "RAILS_ENV=#{fetch(:stage)}", :nohup, "$HOME/.rbenv/bin/rbenv exec bundle exec rake smtp_service --trace &> log/smtp.log &"
      end
    end
  end
end
