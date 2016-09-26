server 'deeprec.davelabs.ru', port: 4242, user: 'deploy', roles: %w{app db web}, primary: true

set :rails_env, :production
set :enable_ssl, false
set :rvm_ruby_version, '2.3.1@deeprec'

set ssh_options: {
    keys: %w(~/.ssh/github_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
}
