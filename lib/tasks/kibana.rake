namespace 'ak8s' do
  desc 'Port forwards kibana to access logs'
  task :kibana, [:namespace, :port] do |_t, args|
    args.with_defaults(namespace: 'logging', port: '5601')
    Rake::Task['ak8s:port_forward'].invoke(args.namespace,
                                          'kibana',
                                          args.port,
                                          args.port)
  end
end
