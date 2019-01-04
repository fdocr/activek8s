namespace 'k8s' do
  desc 'Port forwards a microservice from a specific NAMESPACE to a PORT'
  task :port_forward,
       [:namespace, :service, :local_port, :target_port] do |_t, args|
    begin
      service_yaml = File.read('kube/deployment.yml').split('---')[1]
      deployment_hash = Psych.load(service_yaml)
      own_name = deployment_hash['metadata']['name']
    rescue
      puts 'WARNING: Unable to load default metadata from "kube/deployment.yml"'
      own_name = 'CHECK DOCS AT -> https://github.com/fdoxyz/activek8s'
    end

    args.with_defaults(namespace: 'dev',
                       service: own_name,
                       local_port: '3000',
                       target_port: '3000')

    service = "svc/#{args.service}"
    port_mapping = "#{args.local_port}:#{args.target_port}"
    namespace = "-n #{args.namespace}"
    sh %{kubectl port-forward #{service} #{port_mapping} #{namespace}}
  end
end
