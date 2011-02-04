deploy.template = :rails3
deploy.repository = "git://github.com/ifunam/siesta.git"
# if you use built-in caches for javascripts and stylesheets, set cache_dirs
# deploy.cache_dirs = %w(public/javascripts/main.js public/stylesheets/main.css)
case ENV['environment']
when 'production'
  deploy.application = "siesta"
  deploy.user = "deployer"
  deploy.hosts = ["siesta.fisica.unam.mx"]
  deploy.path = "/home/#{deploy.user}/apps"
  deploy.server = :passenger
when 'development'
  deploy.application = "siesta"
  deploy.user = "deployer"
  deploy.hosts = ["beta.fisica.unam.mx"]
  deploy.path = "/home/#{deploy.user}/apps"
  deploy.server = :passenger
end
