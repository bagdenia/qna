# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "qna"
set :repo_url, "git@github.com:bagdenia/qna.git"

set :deploy_to, "/home/deployer/qna"
set :log_level, :debug

set :deploy_user, 'deployer'

set :linked_files, %w{config/database.yml .env config/thinking_sphinx.yml config/production.sphinx.conf}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :sidekiq_processes, 4
set :sidekiq_options_per_process, [
  "--queue default",
  "--queue send_email",
  "--queue update_stats",
  "--queue generate_report",
]

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
      # invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
after 'deploy:restart', 'thinking_sphinx:restart'
