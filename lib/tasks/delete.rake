namespace 'ak8s' do
  desc 'Deletes the current microservice TAG version on a specific NAMESPACE'
  task :delete, [:namespace, :tag, :cleanup] do |_t, args|
    deployment_path = ENV['K8S_DEPLOYMENT_FILE'] || 'kube/last_deployment.yml'
    Rake::Task['ak8s:build_deployment'].invoke(args.namespace, args.tag)

    sh %{kubectl delete -f #{deployment_path}} do |ok, res|
      cleanup = args.cleanup && File.exist?(deployment_path)
      File.delete(deployment_path) if cleanup

      raise "Error deleting deployment! (status = #{res.exitstatus})" unless ok

      puts 'Deployment successfully deleted!'
    end
  end
end
