class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    has_access?
  end

  def access_token
    token = AccessToken.find(session[:access_token_id])
    consumer = OAuth::Consumer.new ENV['ravelry_consumer_key'],
                                    ENV['ravelry_consumer_secret'],
                                    { site: 'https://api.ravelry.com' }
    access_token = OAuth::AccessToken.new(consumer, token.token, token.secret)
  end

  def has_access?
    AccessToken.find(session[:access_token_id]).present?
  rescue
    false
  end

  def get_access
    redirect_to ravelry_auth_path
  end

  def require_access
    unless has_access?
      get_access
    end
  end
end
