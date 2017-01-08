require "mina/bundler"
require "mina/rails"
require "mina/git"

set :domain, "ec2-54-85-37-40.compute-1.amazonaws.com"
set :deploy_to, "/home/deploy/myapp"
set :repository, "https://github.com/dmitryrck/MyBlog.git"
set :branch, "master"

set :shared_dirs, fetch(:shared_dirs, []).push("log")

set :user, "deploy"
set :forward_agent, true

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :"git:clone"
    invoke :"deploy:link_shared_paths"
    invoke :"bundle:install"
    invoke :"rails:db_migrate"
    invoke :"rails:assets_precompile"
    invoke :"deploy:cleanup"

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end
end
