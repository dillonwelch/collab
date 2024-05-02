class PlaylistsController < ApplicationController
  def index
    # puts "playlist controller: #{request.original_url} "
    # puts "controller get 1: #{VideoService.get}"
    # puts "controller get id 1: #{VideoService.get_by_video_id('123')}"
    # TODO: Paginate?
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
      # TODO: render success alert?
      redirect_to @playlist
    else
      # TODO: render errors
      # TODO: properly handle uniqueness errors
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # TODO: Not found
    # TODO: User shared form
    @playlist = Playlist.find(params[:id])
  end

  def update
    # TODO: Not found
    @playlist = Playlist.find(params[:id])

    if @playlist.update(name: params[:playlist][:name])
      # TODO: render success alert
      redirect_to @playlist
    else
      # TODO: render errors
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy

    # TODO: Display note
    redirect_to playlists_path, status: :see_other
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name)
  end
end
