# frozen_string_literal: true

class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all
  end

  def show
    @playlist = Playlist.find(params[:id])
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(playlist_params)

    if @playlist.save
      redirect_to @playlist, notice: "Playlist \"#{@playlist.name}\" successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @playlist = Playlist.find(params[:id])
  end

  def update
    @playlist = Playlist.find(params[:id])

    if @playlist.update(name: params[:playlist][:name])
      redirect_to @playlist, notice: "Playlist \"#{@playlist.name}\" successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy

    redirect_to playlists_path, status: :see_other, notice: "Playlist \"#{@playlist.name}\" successfully deleted."
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name)
  end
end
