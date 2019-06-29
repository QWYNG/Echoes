# frozen_string_literal: true

# Sample app for Google OAuth2 Strategy
# Make sure to setup the ENV variables GOOGLE_KEY and GOOGLE_SECRET
# Run with "bundle exec rackup"

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'dotenv/load'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
use Rack::Session::Cookie, secret: ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  # For additional provider examples please look at 'omni_auth.rb'
  # The key provider_ignores_state is only for AJAX flows. It is not recommended for normal logins.
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], access_type: 'offline', prompt: 'consent', provider_ignores_state: true, scope: 'email,youtube'
end

# Main example app for omniauth-google-oauth2
class Config < Sinatra::Base
  get '/' do
    <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Google OAuth2 Example</title>
      </head>
      <body>
      <ul>
        <li><a href='/auth/google_oauth2'>Sign in with Google</a></li>
      </ul>
      </body>
    </html>
    HTML
  end

  post '/auth/:provider/callback' do
    content_type 'text/plain'
    begin
      request.env['omniauth.auth'].to_hash.inspect
    rescue StandardError
      'No Data'
    end
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    begin
      request.env['omniauth.auth'].to_hash.inspect
    rescue StandardError
      'No Data'
    end
  end

  get '/auth/failure' do
    content_type 'text/plain'
    begin
      request.env['omniauth.auth'].to_hash.inspect
    rescue StandardError
      'No Data'
    end
  end
end

run Config.new