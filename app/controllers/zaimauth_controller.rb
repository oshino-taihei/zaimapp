require "json"
require "oauth"
class ZaimauthController < ApplicationController
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']
  CALLBACK_URL = ENV['CALLBACK_URL']
  API_URL = 'https://api.zaim.net/v2/'

  MONEY_DATA = 'money.dat'

  def top
  end

  def login
    set_consumer
    @request_token = @consumer.get_request_token(oauth_callback: CALLBACK_URL)
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    redirect_to @request_token.authorize_url(:oauth_callback => CALLBACK_URL)
  end

  def logout
    session[:request_token] = nil
    session[:access_token] = nil
    redirect_to '/zaimauth'
  end

  def callback
    if session[:request_token] && params[:oauth_verifier]
      set_consumer
      @oauth_verifier = params[:oauth_verifier]
      @request_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_secret])
      access_token = @request_token.get_access_token(:oauth_verifier => @oauth_verifier)
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret
      redirect_to index_path
    else
      logout
    end
  end

  def index

  end

  def money
    set_consumer
    @access_token = OAuth::AccessToken.new(@consumer, session[:access_token], session[:access_secret])
    money = @access_token.get("#{API_URL}home/money")
    @money = JSON.parse(money.body)
    @filename = MONEY_DATA
    download(@filename, @money)
  end

  def view
    @filename = MONEY_DATA
    @money = read_data(@filename)
  end

  private

  def set_consumer
    @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
      site: 'https://api.zaim.net',
      request_token_path: '/v2/auth/request',
      authorize_url: 'https://auth.zaim.net/users/auth',
      access_token_path: '/v2/auth/access')
  end

  def download(filename, data)
    File.open(zaimdata(filename), 'wb') { |f|
      f.write(data)
    }
  end

  def read_data(filename)
    zaimdata_path = zaimdata(filename)
    return nil unless File.exist?(zaimdata_path)
    File.open(zaimdata_path).read
  end

  def zaimdata(filename)
    "public/zaimdata/#{filename}"
  end

end
