require 'oembedder'

describe Oembedder do
  describe ".request" do
    before(:each) do
      @response = Oembedder::Oembed.request("http://www.youtube.com/watch?v=RF8lcGoS9Yc")
    end
    
    it "should return html to embed in the page" do
      @response.html.should_not be_nil
    end
    
    it "should return a url to a thumnbnail image" do
      @response.thumbnail_url.should_not be_nil
    end
  end
end