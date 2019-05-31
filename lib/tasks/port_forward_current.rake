namespace 'ak8s' do
  desc 'Port forwards the current project using the `kube/deployment.yml` file'
  task :port_forward_current,
       [:namespace, :service, :local_port, :target_port] do |_t, args|
    begin
      service_yaml = File.read('kube/deployment.yml').split('---')[1]
      deployment_hash = Psych.load(service_yaml)
      own_name = deployment_hash['metadata']['name']
    rescue
      docs_location = 'CHECK DOCS AT -> https://github.com/fdoxyz/activek8s'
      raise "WARNING: Unable to load `kube/deployment.yml`. #{docs_location}"
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
