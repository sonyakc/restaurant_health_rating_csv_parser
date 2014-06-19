require 'rubygems'
require 'oauth'
require 'httpclient'

consumer_key = 'CONSUMER_KEY'
consumer_secret = 'CONSUMER_SECRET'
token = 'TOKEN'
token_secret = 'TOKEN_SECRET'

api_host = 'api.yelp.com'

consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
access_token = OAuth::AccessToken.new(consumer, token, token_secret)

temp = URI.encode "/v2/search?term=food&bounds=37.900000,-122.500000|37.788022,-122.399797&limit=3"

p access_token.get(temp).body
p access_token.get(temp).response