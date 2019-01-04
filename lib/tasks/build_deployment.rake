namespace 'k8s' do
  desc 'Builds the deployment.yml file for execution on a cluster'
  task :build_deployment, [:namespace, :tag] do |_t, args|
    args.with_defaults(namespace: 'dev', tag: 'latest')

    deployment = File.read('kube/deployment.yml')

    deployment.gsub!('{{NAMESPACE}}', args.namespace)
    deployment.gsub!('{{IMAGE_TAG}}', args.tag)

    deployment_path = ENV['K8S_DEPLOYMENT_FILE'] || 'kube/last_deployment.yml'
    File.write(deployment_path, deployment)
  end
end
