require 'rubygems'

require 'net/http'
require 'uri'
require 'cgi'
require 'singleton'
require 'json'

module Oembedder
  VERSION = '0.0.1'

  PROVIDERS = {"youtube.com"    => {:base => "http://www.youtube.com/oembed",           :dot_format => false}, 
               "vimeo.com"      => {:base => "http://vimeo.com/api/oembed",             :dot_format => true }, 
               "flickr.com"     => {:base => "http://www.flickr.com/services/oembed",   :dot_format => false}, 
               "qik.com"        => {:base => "http://qik.com/api/oembed",               :dot_format => true }, 
               "revision3.com"  => {:base => "http://revision3.com/api/oembed",         :dot_format => false},
               "viddler.com"    => {:base => "http://lab.viddler.com/services/oembed",  :dot_format => false},
               "hulu.com"       => {:base => "http://www.hulu.com/api/oembed",          :dot_format => true}}

  class Settings
    include Singleton
    attr_accessor :providers
    def initialize
      @providers = PROVIDERS
    end
  end

  class Oembed
    def self.request(url)
      Request.new(url).response
    end

    def self.settings
      Settings.instance
    end
  end

  class Request
    def initialize(url)
      @url = url
      parse_url
    end
    
    def response
      @response ||= Response.new(Net::HTTP.get_response(URI.parse(api_url)).body)
    end
    
    def api_url
      provider = providers[@host]
      base_url = provider[:base]
      url_to_embed = CGI::escape(@url)
      if provider[:dot_format]
        "#{base_url}.json?url=#{url_to_embed}"
      else
        "#{base_url}?url=#{url_to_embed}&format=json"
      end
    end
    
    protected
    def parse_url
      uri = URI.parse(@url)
      @host = uri.host.sub("www.", "")
    end
  
    def settings
      Settings.instance
    end
    
    def providers
      settings.providers
    end
  end

  class Response
    attr_accessor :html, :thumbnail_url
    
    def initialize(json_response)
      puts json_response
      parsed_response = JSON.parse(json_response)
      @html = parsed_response["html"]
      @thumbnail_url = parsed_response["thumbnail_url"]
    end
  end
end

