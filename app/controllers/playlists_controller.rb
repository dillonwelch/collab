class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all
  end

  def show
    # TODO: Not found
    @playlist = Playlist.find(params[:id])
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
    # TODO: Not found
    @playlist = Playlist.find(params[:id])
  end

  def update
    # TODO: Not found
    @playlist = Playlist.find(params[:id])

    if @playlist.update(name: params[:playlist][:name])
      redirect_to playlist_path(id: params[:id])
    else
      # TODO: render errors
      render :edit
    end
  end
end
