# Activek8s

This gem provides a set of _Rake tasks for a convention based Kubernetes integration_. This means that by following some conventions you will be able to leverage some low level [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) commands using [Rake](https://github.com/ruby/rake).

These Rake tasks provide a set of high level customizable commands with sensible defaults. Not everyone in your teams has to be an expert in the Docker/Kubernetes/Ops area to interact with a Kubernetes cluster. __Activek8s__ can help teams working on any project, this isn't a Rails only solution (__not even a Ruby only solution__).

## Contents

  1. [Installation](https://github.com/fdoxyz/activek8s#installation)
  2. [How it works](https://github.com/fdoxyz/activek8s#how-it-works)
  3. [.ak8s.yml](https://github.com/fdoxyz/activek8s#ak8syml)
  4. [Tutorials & Blog posts](https://github.com/fdoxyz/activek8s#tutorials--blog-posts)
  5. [Development, Contributing & License](https://github.com/fdoxyz/activek8s#development)
  

## Installation

    $ gem install activek8s

## Ruby/Rails project

Add this line to your application's Gemfile:

```ruby
gem 'activek8s'
```

and execute `bundle install`

## How it works

This gem uses a directory named `kube` as a workspace for `deployment.yml`. This YAML file must contain a ConfigMap, Service and Deployment representing the current projects service to be deployed in a Kubernetes cluster. When managing a deployment in a Kubernetes cluster a very common command is `kubectl apply -f <config yml file>`.

__Activek8s__ performs template-like text substitution on your `deployment.yml` to output a file named `last_deployment.yml`. This `last_deployment.yml` file is the one applied against the currently authenticated Kubernetes cluster (via kubectl). This text substitution is meant for container image name, container image tags and environment management (dev/staging/prod).

### Directory structure

```
.
├── Dockerfile
├── kube
│   └── deployment.yml
```

### Things you'll need

  1. A Kubernetes cluster somewhere
  2. [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) authenticated to that cluster from #1 (if `kubectl get pods -n NAMESPACE` works you're good)
  3. A Dockerized project ready to be deployed on #1 or some other services already deployed to #1

### Tasks

  * ak8s:deploy
    * Creates a `last_deployment.yml` from `deployment.yml` and applies the YAML specification on the currently authenticated Kubernetes cluster
    * Ex: `kubectl apply -f kube/last_deployment.yml`
  * ak8s:delete
    * Creates a `last_deployment.yml` from `deployment.yml` and deletes the matching YAML specification on the currently authenticated Kubernetes cluster
    * Ex: `kubectl delete -f kube/last_deployment.yml`
  * ak8s:port_forward
    * Port forwards all services defined in `.ak8s.yml`.
    * Will create a file named `services.env` containing your service names and urls which you can source (i.e. `. services.env`)
  * ak8s:port_forward_current
    * Port forwards the current project's deployment in a certain namespace defined in `.ak8s.yml`.
    * Ex: `kubectl port-forward {service} ...`

## .ak8s.yml

This file lets you configure your port forwarding capabilities. Suppose an environment where you have 5 services deployed in a cluster. You would have something similar to the following:

```
dev:                          # First level keys are namespaces in your cluster.
  - name: webapp              # Inside the list of services to forward the only
  - name: backendwebapp       # required field is 'name'.
  - name: webapi
  - name: analytics
  - name: elasticsearch

staging:
  - name: webapp        
  - name: backendwebapp
  - name: webapi              # You can specify the namespace of any service.     
  - name: analytics           # This would cause the port forwarding to occur
    namespace: logging        # referencing the service deployed on a specific
  - name: elasticsearch       # namespace other than the first level key.

production:
  - name: webapp
  - name: backendwebapp
  - name: webapi
  - name: analytics           # Target port specification allows you to pass in
    target_port: 8080         # the target port of the service (not on the
  - name: elasticsearch       # localhost port where the service will be available
    target_port: 9200

ak8s:                         # ak8s is where general config goes
  first_port: 4200            # first_port lets you specify the first port where
                              # the multiple service port forwarding will start
```

### Port forwarding examples

`rake ak8s:port_forward` will port forward all the services listed by name in the 'dev' namespace __because it was listed first__.

`rake ak8s:port_forward[staging]` will port forward all the services listed within the staging namespace. In this case the elasticsearch service will be port forwarded using the logging namespace, instead of using the default (which is the corresponding first level key, 'staging' in this case).

## Tutorials & Blog posts

  * [Kubernetes integration with Rake tasks](https://dev.to/fdoxyz/kubernetes-integration-with-rake-tasks-j0b)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fdoxyz/activek8s.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
