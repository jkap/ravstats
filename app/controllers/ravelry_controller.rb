class RavelryController < ApplicationController

  def auth
    consumer = OAuth::Consumer.new APP_CONFIG['ravelry_consumer_key'],
                                    APP_CONFIG['ravelry_consumer_secret'],
                                    { site: 'https://api.ravelry.com' }
    request_token = consumer.get_request_token oauth_callback: ravelry_callback_url
    session[:request_token] = request_token
    redirect_to request_token.authorize_url
  end

  def callback
    request_token = session[:request_token]
    if request_token.token = params['oauth_token']
      access_token = request_token.get_access_token oauth_verifier: params[:oauth_verifier]
      token = AccessToken.from_token_and_secret(access_token.token, access_token.secret)
      session[:access_token_id] = token.id
      if session[:after_auth]
        redirect_to session[:after_auth]
      else
        redirect_to root_path
      end
    end
  end
end
