require 'childprocess'

namespace 'k8s' do
  desc 'Port forwards many services from a specific NAMESPACE'
  task :port_forward_many, [:namespace, :first_port, :services] do |_t, args|
    # default "empty char" separated services to be port-forwarded from ENV
    args.with_defaults(namespace: 'dev',
                       first_port: '3001',
                       services: ENV['K8S_SERVICES'].to_s)

    # Build 'dynamic' values
    services = args.services.split(' ').each_with_index.map do |name, index|
      port = args.first_port.to_i + index
      export_env = "#{name.upcase}_SERVICE_URL"
      {
        port: port,
        rake_task: "k8s:port_forward[#{args.namespace},#{name},#{port},3000]",
        env: "#{export_env}=http://localhost:#{port}/"
      }
    end

    # Export ENV variables
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
