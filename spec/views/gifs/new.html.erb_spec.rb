require 'rails_helper'

RSpec.describe "gifs/new", :type => :view do
  before(:each) do
    assign(:gif, Gif.new(
      :url => "MyString"
    ))
  end

  it "renders new gif form" do
    render

    assert_select "form[action=?][method=?]", gifs_path, "post" do

      assert_select "input#gif_url[name=?]", "gif[url]"
    end
  end
end
