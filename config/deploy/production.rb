role :app, %w{deployer@78.155.217.115}
role :web, %w{deployer@78.155.217.115}
role :db,  %w{deployer@78.155.217.115}

set :rails_env, :production
set :stage, :production

server '78.155.217.115', user: 'deployer', roles: %w{web app db}, primary: true


set :ssh_options, {
   keys: %w(/Users/bagdenia/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey password),
   port: 4321
}

