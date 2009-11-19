require 'rubygems'
require 'open-uri'
require 'uri'
require 'cgi'
require 'singleton'
require 'json'

module Oembedder
  VERSION = '0.1.1'

  class UnknownProvider < StandardError; end

  # Global settings. To add providers:
  #   Oembedder::Settings.instance.providers[:provide_name] = {:base => "<base-api-url>"}
  # For more options see PROVIDERS
  class Settings
    include Singleton
    attr_accessor :providers
    def initialize
      @providers = PROVIDERS
    end
  end

  # Proxies the Request class. Uses a custom handler if specified.
  #   Oembed.request("http://www.youtube.com/watch?v=RF8lcGoS9Yc")
  class Oembed
    def self.request(url)
      host = host_for(url)
      provider = provider_for(host)
      if custom_handler = provider[:custom_handler]
        custom_handler::Request.new(url, host).response
      else
        Request.new(url, host).response
      end
    end

    def self.settings
      Settings.instance
    end
    
    def self.host_for(url)
      uri = URI.parse(url)
      uri.host.sub("www.", "")
    end

    def self.provider_for(host)
      settings.providers[host] || raise(UnknownProvider.new)
    end
  end

  # Standard request. Constructs a URI from the providers base uri
  class Request
    def initialize(url, host)
      @url = url
      @host = host
    end
    
    def response
      @response ||= if custom_handler = settings.providers[@host][:custom_handler]
        custom_handler::Response.new(open(api_url).read)        
      else
        Response.new(open(api_url).read)
      end
    end    

    # Constructs an api call. Inspired by Ben McRedmond's http://github.com/benofsky/ohembedr/
    def api_url
      provider = settings.providers[@host]
      base_url = provider[:base]
      url_to_embed = CGI::escape(@url)
      api_url = provider[:dot_format] ? "#{base_url}.json?url=#{url_to_embed}" : "#{base_url}?url=#{url_to_embed}&format=json"
    end
    
    protected  
    def settings
      Oembed.settings
    end
  end

  # Standard response. Takes JSON from the request to set html and thumbnail_url
  class Response
    attr_accessor :html, :thumbnail_url
    
    def initialize(json_response)
      parsed_response = JSON.parse(json_response)
      @html = parsed_response["html"]
      @thumbnail_url = parsed_response["thumbnail_url"]
    end
  end
  
  # YouTube custom handler. The youtube oembed service does not return a thumbnail, so we're using the youtube api instead.
  # This approach inspired by http://oohembed.com
  module YouTube
    def self.video_id(url)
      url =~ /youtube\.com\/watch.+v=([\w-]+)?/
      return $1
    end
    
    class Request < Oembedder::Request
      def api_url
        "http://gdata.youtube.com/feeds/api/videos/#{YouTube.video_id(@url)}?alt=json"
      end
    end
    
    class Response < Oembedder::Response
      def initialize(json_response)
        parsed_response = JSON.parse(json_response)
        player = parsed_response["entry"]["media$group"]["media$content"].detect { |content| content["yt$format"] == 5 }
        thumbnail = parsed_response["entry"]["media$group"]["media$thumbnail"].detect { |thumbnail| thumbnail["url"] =~ /1.jpg$/ }
        @html = "<embed src='#{player["url"]}&fs=1' allowfullscreen='true' type='#{player["type"]}' wmode='transparent' width='425' height='344'></embed>"
        @thumbnail_url = thumbnail["url"]
      end
    end
  end
  
  # Providers. Inspired by Ben McRedmond's http://github.com/benofsky/ohembedr/
  #   :base => base uri for the provider's oembed api
  #   :dot_format => determines whether or not the api supports http://<base-uri>/oembed.json or ?format=json
  #   :custom_handler => a module that must implement both a request and a response class. See YouTube for an example
  PROVIDERS = {"youtube.com"    => {:custom_handler => YouTube}, 
               "vimeo.com"      => {:base => "http://vimeo.com/api/oembed",             :dot_format => true }, 
               "flickr.com"     => {:base => "http://www.flickr.com/services/oembed",   :dot_format => false}, 
               "qik.com"        => {:base => "http://qik.com/api/oembed",               :dot_format => true }, 
               "revision3.com"  => {:base => "http://revision3.com/api/oembed",         :dot_format => false},
               "viddler.com"    => {:base => "http://lab.viddler.com/services/oembed",  :dot_format => false},
               "hulu.com"       => {:base => "http://www.hulu.com/api/oembed",          :dot_format => true}}
end