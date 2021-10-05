SocialShareButton.configure do |config|
  config.allow_sites = %w(twitter facebook google_bookmark pinterest email linkedin reddit telegram)
end

Graph = Koala::Facebook::API.new ENV["FACEBOOK_ACCESS_TOKEN"]