class AccessToken < ActiveRecord::Base
  attr_accessible :secret, :token

  validates_presence_of :secret, :token

  def self.from_token_and_secret(token, secret)
    access_token = find_by_token_and_secret!(token, secret)
  rescue ActiveRecord::RecordNotFound
    access_token = create!(secret: secret, token: token)
  end

  def self.usable_token
    token = self.last
    consumer = OAuth::Consumer.new APP_CONFIG['ravelry_consumer_key'],
                                    APP_CONFIG['ravelry_consumer_secret'],
                                    { site: 'https://api.ravelry.com' }
    access_token = OAuth::AccessToken.new(consumer, token.token, token.secret) 
  end
end
