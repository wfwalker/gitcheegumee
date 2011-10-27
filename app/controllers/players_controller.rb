class PlayersController < ApplicationController
  before_filter :verify_credentials, :only => [:new, :create, :edit, :play, :register, :index, :update, :destroy]  
  before_filter :verify_and_update_activity_timer
  
  # GET /players
  # GET /players.xml
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
      format.json  { render :json => @player }
    end
  end

  # GET /players/play/1
  # GET /players/play/1.xml
  def play
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
      format.json  { render :json => @player }
    end
  end

  def move
    @player = Player.find(params[:id])
    @passage = Passage.find(params[:passage_id])

    if @player.location_id == @passage.source_id then
      @player.location_id = @passage.destination_id
      @player.save

      happening1 = Happening.new()
      happening1.player_id = @player.id
      happening1.location_id = @passage.source_id
      happening1.passage_id = @passage.id
      happening1.description = "%s headed %s toward %s" % [@player.name, @passage.title, @passage.destination.title]
      happening1.save

      happening2 = Happening.new()
      happening2.player_id = @player.id
      happening2.location_id = @passage.destination_id
      happening2.description = "%s arrived from %s" % [@player.name, @passage.source.title]
      happening2.save
    else
      raise "Illegal move, player %d in location %d using passage with source id %d" % [@player.id, @player.location.id, @passage.source_id]
    end

    redirect_to :action => 'play', :id => @player
  end

  def take
    @player = Player.find(params[:id])
    @item = Item.find(params[:item_id])

    if @player.location_id == @item.location_id then
      @item.player_id = @player.id
      @item.location_id = 0
      @item.save

      happening = Happening.new()
      happening.player_id = @player.id
      happening.location_id = @player.location_id
      happening.item_id = @item.id
      happening.description = "%s took %s" % [@player.name, @item.description]
      happening.save
    else
      raise "Illegal take, player %d in location %d cannot pick up %d" % [@player.id, @player.location.id, @item.id]
    end

    redirect_to :action => 'play', :id => @player
  end

  def drop
    @player = Player.find(params[:id])
    @item = Item.find(params[:item_id])

    if @player.id == @item.player_id then
      @item.player_id = 0
      @item.location_id = @player.location_id
      @item.save

      happening = Happening.new()
      happening.player_id = @player.id
      happening.location_id = @player.location_id
      happening.item_id = @item.id
      happening.description = "%s dropped %s" % [@player.name, @item.description]
      happening.save
    else
      raise "Illegal take, player %d in location %d cannot drop %d" % [@player.id, @player.location.id, @item.id]
    end

    redirect_to :action => 'play', :id => @player
  end

  def say
    @player = Player.find(params[:id])
    # TODO, ensure EITHER this is an admin user OR the :id matches the player_id in the session
    utterance = params[:utterance]

    happening = Happening.new()
    happening.player_id = @player.id
    happening.location_id = @player.location_id
    happening.description = "%s said &#147;%s&#148;" % [@player.name, CGI.escapeHTML(utterance)]
    happening.save

    redirect_to :action => 'play', :id => @player
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/register?email=blah
  # GET /players/register.xml
  def register
    @player = Player.new
    @player.email = params[:email]
    @player.location_id = params[:location_id]

    respond_to do |format|
      format.html # register.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    # login as this guy!

    respond_to do |format|
      if @player.save
        populate_session(@player)
        format.html { redirect_to(:action => 'play', :id => @player, :notice => 'Player was successfully created.') }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    #TODO what if someone is logged in currently as this guy?

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
