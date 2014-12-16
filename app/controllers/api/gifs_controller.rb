class Api::GifsController < Api::BaseController
  def get
    new_gifs = Gif.all.order("created_at DESC")
    respond_with new_gifs
  end
end
