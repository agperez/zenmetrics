require 'rails_helper'

RSpec.describe "Gifs", :type => :request do
  describe "GET /gifs" do
    it "works! (now write some real specs)" do
      get gifs_path
      expect(response).to have_http_status(200)
    end
  end
end
