module Activek8s
  # Railtie for Rails integration
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/build_deployment.rake'
      load 'tasks/deploy.rake'
      load 'tasks/delete.rake'
      load 'tasks/port_forward.rake'
      load 'tasks/port_forward_many.rake'
      load 'tasks/kibana.rake'
    end
  end
end
