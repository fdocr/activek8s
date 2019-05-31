namespace 'ak8s' do
  desc 'Port forwards a microservice from a specific NAMESPACE to a PORT'
  task :port_forward_service,
       [:namespace, :service, :local_port, :target_port] do |_t, args|

    args.with_defaults(namespace: 'dev',
                       service: nil,
                       local_port: '3000',
                       target_port: '3000')

    raise 'Invalid service name' if args.service.nil?

    service = "svc/#{args.service}"
    port_mapping = "#{args.local_port}:#{args.target_port}"
    namespace = "-n #{args.namespace}"
    sh %{kubectl port-forward #{service} #{port_mapping} #{namespace}}
  end
end
