require 'rails_helper'

RSpec.describe "gifs/edit", :type => :view do
  before(:each) do
    @gif = assign(:gif, Gif.create!(
      :url => "MyString"
    ))
  end

  it "renders the edit gif form" do
    render

    assert_select "form[action=?][method=?]", gif_path(@gif), "post" do

      assert_select "input#gif_url[name=?]", "gif[url]"
    end
  end
end
