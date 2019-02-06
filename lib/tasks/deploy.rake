namespace 'k8s' do
  desc 'Deploys the current microservice TAG version on a specific NAMESPACE'
  task :deploy, [:namespace, :tag, :cleanup] do |_t, args|
    puts "ARGS: [#{args.namespace}, #{args.tag}, #{args.cleanup}]" unless ENV['K8S_DEBUG'].nil?

    deployment_path = ENV['K8S_DEPLOYMENT_FILE'] || 'kube/last_deployment.yml'
    puts "[K8S DEBUG DEPLOYMENT: #{deployment_path}]" unless ENV['K8S_DEBUG'].nil?
    Rake::Task['k8s:build_deployment'].invoke(args.namespace, args.tag)

    unless ENV['K8S_DEBUG'].nil?
      puts '[K8S DEBUG DEPLOYMENT FILE]'
      puts File.read(deployment_path)
      puts '[/K8S DEBUG DEPLOYMENT FILE]'
    end

    sh %{kubectl apply -f #{deployment_path}} do |ok, res|
      cleanup = args.cleanup && File.exist?(deployment_path)
      File.delete(deployment_path) if cleanup

      raise "Error deploying! (status = #{res.exitstatus})" unless ok

      puts 'Deployment successfully applied!'
    end
  end
end
