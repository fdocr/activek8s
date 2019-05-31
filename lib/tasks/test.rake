require 'optparse'

namespace 'k8s' do
  desc 'TEST'
  task :test do
    # options = { port: 4200 }
    # OptionParser.new do |opts|
    #   opts.banner = "Usage: rake k8s:port_forward [options]"
    #   opts.on("-n", "--namespace ARG", String) do |namespace|
    #     options[:namespace] = namespace
    #   end
    #   opts.on("-p", "--port ARG", Integer) do |port|
    #     options[:port] = port
    #   end
    # end.parse!

    # dir_name = File.dirname(__FILE__)
    # puts "#{Dir.pwd}"
    puts "#{ARGV}"
  end
end
