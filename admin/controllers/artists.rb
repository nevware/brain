Admin.controllers :artists do

  require 'musicbrainz'

  get :index do
    @artists = Artist.all
    render 'artists/index'
  end

  get :new do
    @artist = Artist.new
    render 'artists/new'
  end

  get :updateFromMusicBrainz do
    MusicBrainz.configure do |c|
      # Application identity (required)
      c.app_name = "MusicMonkey"
      c.app_version = "1.0"
      c.contact = "nevware@hotmail.com"

      # Cache config (optional)
      c.cache_path = "/tmp/musicbrainz-cache"
      c.perform_caching = true

      # Querying config (optional)
      c.query_interval = 1.2 # seconds
      c.tries_limit = 2
    end
    Artist.where("musicbrainzid is null").each do |artist|
      mbArtist = MusicBrainz::Artist.find_by_name(artist.name)
      next unless mbArtist
      artist.musicBrainzID = mbArtist.id
      artist.country = mbArtist.country
      artist.dateBorn = mbArtist.date_begin
      artist.dateDied = mbArtist.date_end
      artist.save

    end
    @artists = Artist.all
    render 'artists/index'
  end

  post :create do
    @artist = Artist.new(params[:artist])
    if @artist.save
      flash[:notice] = 'Artist was successfully created.'
      redirect url(:artists, :edit, :id => @artist.id)
    else
      render 'artists/new'
    end
  end

  get :edit, :with => :id do
    @artist = Artist.find(params[:id])
    render 'artists/edit'
  end

  put :update, :with => :id do
    @artist = Artist.find(params[:id])
    if @artist.update_attributes(params[:artist])
      flash[:notice] = 'Artist was successfully updated.'
      redirect url(:artists, :edit, :id => @artist.id)
    else
      render 'artists/edit'
    end
  end

  delete :destroy, :with => :id do
    artist = Artist.find(params[:id])
    if artist.destroy
      flash[:notice] = 'Artist was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Artist!'
    end
    redirect url(:artists, :index)
  end
end
