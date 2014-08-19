require "./config/environment.rb"

require 'sidekiq/web'


Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "lowkick"]
end

run Rack::URLMap.new('/' => PagesController, '/sidekiq' => Sidekiq::Web)
