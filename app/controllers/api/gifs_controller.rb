class Api::GifsController < Api::BaseController
  def get
    new_gifs = Gif.where("created_at > ?", Time.now-3.minutes).order("created_at DESC")
    respond_with new_gifs
  end
end
