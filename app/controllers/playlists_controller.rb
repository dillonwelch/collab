class PlaylistsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(name: params[:name])

    if @playlist.save
      redirect_to playlists_path
    else
      render :new
    end
  end

  def edit
  end
end
