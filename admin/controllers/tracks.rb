Admin.controllers :tracks do


  get :index do
    @tracks = Track.all
    render 'tracks/index'
  end

  get :new do
    @track = Track.new
    render 'tracks/new'
  end

  get :populate do
    require 'mp3info'

    Dir.glob("/Users/neville.kuyt/Music/iTunes/iTunes Media/**/*.mp3") do |f|
      track = Track.new
      mbArtist = nil
      Mp3Info.open(f) do |mp3info|
        title = mp3info.tag2.TIT2
        next unless title
        track.title = title
        artistName = mp3info.tag.artist
        next unless artistName
        artist = Artist.find_or_create_by_name(artistName)
        track.save
        track.artists << artist
      end


    end
    @tracks = Track.all
    render 'tracks/index'
  end
  post :create do
    @track = Track.new(params[:track])
    if @track.save
      flash[:notice] = 'Track was successfully created.'
      redirect url(:tracks, :edit, :id => @track.id)
    else
      render 'tracks/new'
    end
  end

  get :edit, :with => :id do
    @track = Track.find(params[:id])
    render 'tracks/edit'
  end

  put :update, :with => :id do
    @track = Track.find(params[:id])
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Track was successfully updated.'
      redirect url(:tracks, :edit, :id => @track.id)
    else
      render 'tracks/edit'
    end
  end

  delete :destroy, :with => :id do
    track = Track.find(params[:id])
    if track.destroy
      flash[:notice] = 'Track was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Track!'
    end
    redirect url(:tracks, :index)
  end
end
