require "json"
require "oauth"
class ZaimauthController < ApplicationController
  CONSUMER_KEY = ENV['CONSUMER_KEY']
  CONSUMER_SECRET = ENV['CONSUMER_SECRET']
  CALLBACK_URL = ENV['CALLBACK_URL']

  API_SET = ["money", "category", "genre", "account"]
  API_URL = "https://api.zaim.net/v2/home"

  def index

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
    session[:request_secret] = nil
    session[:access_token] = nil
    session[:access_secret] = nil
    redirect_to '/zaimauth/index'
  end

  def callback
    if session[:request_token] && params[:oauth_verifier]
      set_consumer
      @oauth_verifier = params[:oauth_verifier]
      @request_token = OAuth::RequestToken.new(@consumer, session[:request_token], session[:request_secret])
      access_token = @request_token.get_access_token(:oauth_verifier => @oauth_verifier)
      session[:access_token] = access_token.token
      session[:access_secret] = access_token.secret
      redirect_to '/zaimauth/index'
    else
      logout
    end
  end

  def download
    set_consumer
    @access_token = OAuth::AccessToken.new(@consumer, session[:access_token], session[:access_secret])
    @success_files = []
    @failure_files = []
    API_SET.each do |api|
      response = @access_token.get("#{API_URL}/#{api}")
      filename = "#{api}.json"
      if (response.code == "200")
        save_file(filename, response.body)
        @success_files << filename
      else
        @failure_files << filename
      end
    end
  end

  def import_money
    Money.delete_all
    import_db("money.json", "money", Money)
  end

  def import_category
    Category.delete_all
    import_db("category.json", "categories", Category)
  end

  def import_genre
    Genre.delete_all
    import_db("genre.json", "genres", Genre)
  end

  def import_account
    Account.delete_all
    import_db("account.json", "accounts", Account)
  end

  private

  def import_db(filename, dataset_name, model_class)
    data = read_data(filename)
    dataset = data[dataset_name]

    @success = 0
    @failure = 0
    dataset.each_with_index do |m,i|
      zaim_params = model_class.fix_zaim_param(m)
      model = model_class.new(zaim_params)
      if model.save
        @success += 1
      else
        @failure += 1
      end
    end
    render 'import_db'
  end

  def set_consumer
    @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
      site: 'https://api.zaim.net',
      request_token_path: '/v2/auth/request',
      authorize_url: 'https://auth.zaim.net/users/auth',
      access_token_path: '/v2/auth/access')
  end

  def save_file(filename, data)
    File.open(zaimdata(filename), 'wb') do |f|
      f.write(data)
    end
  end

  def read_data(filename)
    zaimdata_path = zaimdata(filename)
    return nil unless File.exist?(zaimdata_path)
    contents = File.open(zaimdata_path).read
    JSON.parse(contents)
  end

  def zaimdata(filename)
    "public/zaimdata/#{filename}"
  end

end
