# Provide list of supported providers with metadata (title, icon)
# Detect provider usage in hosting app
module Vxod
  class OmniAuthProvider
    def initialize(name, icon, title)
      @name = name
      @icon = icon
      @title = title
    end

    attr_reader :name, :icon, :title

    def show?
      @show ||= begin
        OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(name.to_s)}")
        true
      rescue NameError
        false
      end
    end

    def href
      "#{OmniAuth.config.path_prefix}/#{name}"
    end

    def self.any?
      all.any?{ |provider| provider.show? }
    end

    def self.all
      @all ||= [
        [:vkontakte, 'fa-vk', 'Login with vk.com'],
        [:twitter, 'fa-twitter', 'Login with Twitter'],
        [:facebook, 'fa-facebook', 'Login with Facebook'],
        [:google_oauth2, 'fa-google-plus', 'Login with Google'],
        [:github, 'fa-github-alt', 'Login with Github'],
      ].map{ |data| OmniAuthProvider.new(*data) }
    end
  end
end