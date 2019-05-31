require 'childprocess'

namespace 'ak8s' do
  desc 'Port forwards many services from a specific NAMESPACE'
  task :port_forward, [:namespace] do |_t, args|
    # Config with defaults setup
    config = YAML.load_file(ENV['AK8S_CONFIG'] || '.ak8s.yml')
    config_namespaces = config.keys.reject { |n| n == 'ak8s' }
    args.with_defaults(namespace: config_namespaces.first)
    raise 'Bad config file format' if args.namespace.nil?

    # Helper variables setup
    first_port = config.dig('ak8s', 'first_port') || 4200
    namespaced_services = config[args.namespace]['services']
    raise 'No services listed in .ak8s.yml' if namespaced_services.empty?

    # All services to port forward (an array of hashes)
    services = namespaced_services.each_with_index.map do |service, index|
      port = first_port.to_i + index
      export_env = "#{service['name'].upcase}_ENDPOINT"
      target_port = service['target_port'] || 3000
      service_namespace = service['namespace'] || args.namespace

      rake_task_params = [
        service_namespace,
        service['name'],
        port,
        target_port
      ].map(&:to_s).join(',')

      {
        port: port,
        rake_task: "ak8s:port_forward_service[#{rake_task_params}]",
        env: "export #{export_env}=\"http://localhost:#{port}/\""
      }
    end

    # Export ENV variables to `services.env`
    env_file = services.map { |service| service[:env] }.join("\n")
    File.write('services.env', env_file)

    # Execute each 'rake_task' in a child process until CTRL+C is received
    begin
      processes = services.map do |service|
        ChildProcess.build('bin/rake', service[:rake_task])
      end
      processes.each(&:start)

      puts 'Services should be port forwarded to localhost in a few seconds.'
      puts 'Execute ". services.env" to source each service URL.'
      loop { sleep 3 }
    rescue Interrupt
      puts "\nExiting child processes..."
      processes.each(&:stop)
      puts 'Done!'
    end
  end
end
