require 'rails_helper'

RSpec.describe "gifs/index", :type => :view do
  before(:each) do
    assign(:gifs, [
      Gif.create!(
        :url => "Url"
      ),
      Gif.create!(
        :url => "Url"
      )
    ])
  end

  it "renders a list of gifs" do
    render
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
