require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'
require 'json'
require 'pry'

class YoutubeLikesVideosGetter
  attr_accessor :titles

  APPLICATION_NAME = 'Echoes'

  def initialize(credentials_request)
    @titles = ''
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = create_credentials(credentials_request)
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

  private

  def create_credentials(credentials_request)
    Google::Auth::UserRefreshCredentials.new(
        client_id:     ENV['GOOGLE_KEY'],
        client_secret: ENV['GOOGLE_SECRET'],
        access_token:  credentials_request["token"],
        refresh_token: credentials_request["refresh_token"],
        expires_at:    credentials_request["expires_at"]
    )
  end
end
