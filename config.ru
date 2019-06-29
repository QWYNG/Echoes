require_relative 'app'

use Rack::Session::Cookie, secret: ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], access_type: 'offline', prompt: 'consent', provider_ignores_state: true, scope: 'email,youtube'
end

run App.new