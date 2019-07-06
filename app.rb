require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'dotenv/load'
require_relative 'echoes'

class App < Sinatra::Base
  get '/' do
    <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Echoes</title>
      </head>
      <body>
        <a href='/auth/google_oauth2'>Sign in with Google</a>
        <a href='/policy'> policy </a>
      </body>
    </html>
    HTML
  end

  get '/auth/:provider/callback' do
    @result_tracks = ::Echoes.run(request)
    slim :result_tracks
  end

  get '/auth/failure' do
    content_type 'text/plain'
    'Some Error'
  end

  get '/policy' do
    slim :policy
  end
end
