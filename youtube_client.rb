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
  attr_accessor :service, :titles, :descriptions

  REDIRECT_URI = 'http://localhost'
  APPLICATION_NAME = 'YouTube Data API Ruby Tests'
  CLIENT_SECRETS_PATH = 'client_secret.json'
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                               "youtube-quickstart-ruby-credentials.yaml")
  SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY

  def initialize
    @titles = ''
    @descriptions = ''
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
      puts "Open the following URL in the browser and enter the " +
               "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: REDIRECT_URI)
    end
    credentials
  end

  def get_likes_list!
    response = @service.list_channels('id,contentDetails', mine: true).to_json
    likes_list_id = JSON.parse(response)["items"].first["contentDetails"]["relatedPlaylists"]["likes"]
    response = @service.list_playlist_items("snippet", playlist_id: likes_list_id).to_json
    responce_json = JSON.parse(response)
    responce_json['items'].each do |item|
      @titles << item["snippet"]["title"]
      @descriptions << item["snippet"]["description"]
    end
  end
end
