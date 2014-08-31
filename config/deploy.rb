lock '3.2.1'

set :application, 'tix_production'
set :repo_url, 'git@github.com:joseignaciosg/TiX.git'
set :format, :pretty
set :log_level, :info
set :pty, true
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'

  namespace :python_app do
    task :copy_files do
      on roles(:app) do
        execute "mkdir -p #{fetch(:install_to)} || true"
        execute "cp -rv #{fetch(:deploy_to)}/current/TiX/PythonApp/ServerApp/* #{fetch(:install_to)}"
      end
    end

    after :copy_files, :restart_service do
      on roles(:app) do
        env = fetch(:application).gsub(/_releases/,"").gsub(/tix_/,"")
        execute "/etc/init.d/serverTiX-#{env} stop"
        execute "/etc/init.d/serverTiX-#{env} start"
      end
    end
  end

  namespace :web_app do
    task :package_war do
      on roles(:app) do
        execute "cd #{fetch(:deploy_to)}/current/TiX/ && mvn package && cp target/tix*.war /home/pfitba/#{fetch(:war_filename)}"
      end
    end

    after :package_war, :restart_tomcat do
      on roles(:app) do
        if fetch(:application).match /production/
          execute :sudo, :cp, "/home/pfitba/#{fetch(:war_filename)} /var/lib/tomcat7/webapps/ROOT.war"
        else
          execute :sudo, :cp, "/home/pfitba/#{fetch(:war_filename)} /var/lib/tomcat7/webapps/#{fetch(:war_filename)}"
        end
      end
    end
  end

  after :publishing, "python_app:copy_files"
  after :publishing, "web_app:package_war"
end
