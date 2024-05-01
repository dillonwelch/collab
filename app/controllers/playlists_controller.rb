class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all
  end

  def show
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(name: params[:playlist][:name])

    if @playlist.save
      redirect_to playlists_path
    else
      # TODO: render errors
      # TODO: properly handle uniqueness errors
      render :new
    end
  end

  def edit
  end
end
