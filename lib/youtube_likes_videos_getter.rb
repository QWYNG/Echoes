require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'json'

class YoutubeLikesVideosGetter
  attr_accessor :titles

  APPLICATION_NAME = 'Echoes'

  def initialize(credentials_request)
    @titles = ''
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = create_credentials(credentials_request)
    get_likes_list!
  end

  private

  def create_credentials(credentials_request)
    credentials_info = credentials_request.env['omniauth.auth']['credentials']
    Google::Auth::UserRefreshCredentials.new(
        client_id:     ENV['GOOGLE_KEY'],
        client_secret: ENV['GOOGLE_SECRET'],
        access_token:  credentials_info["token"],
        refresh_token: credentials_info["refresh_token"],
        expires_at:    credentials_info["expires_at"]
    )
  end

  def get_likes_list!
    response = @service.list_channels('id,contentDetails', mine: true).to_json
    likes_list_id = JSON.parse(response)["items"].first["contentDetails"]["relatedPlaylists"]["likes"]
    response = @service.list_playlist_items("snippet", playlist_id: likes_list_id, max_results: 50).to_json
    responce_json = JSON.parse(response)
    responce_json['items'].each do |item|
      @titles << item["snippet"]["title"]
    end
  end
end
