require 'oembedder'

describe Oembedder do
  
  describe ".request" do

    describe "with valid urls" do
      before(:all) do
        @responses = {
          "youtube" => Oembedder::Oembed.request("http://www.youtube.com/watch?v=RF8lcGoS9Yc"),
          "vimeo" => Oembedder::Oembed.request("http://vimeo.com/7562889"),
          "viddler" => Oembedder::Oembed.request("http://www.viddler.com/explore/Destructoid/videos/1268/")
        }
      end
    
      it "should return html to embed in the page" do
        @responses.each do |provider, response|
          response.html.should_not be_nil, "Failed for #{provider}"
        end
      end
    
      it "should return a url to a thumnbnail image" do
        @responses.each do |provider, response|
          response.thumbnail_url.should_not be_nil, "Failed for #{provider}"
        end
      end
    end
    
    describe "with an invalid url" do
      it "should raise an exception" do
        lambda { Oembedder::Oembed.request("http://www.youtubed.com/watch?v=RF8lcGoS9Yc") }.should raise_error(Oembedder::UnknownProvider)
      end
    end

  end
  
end