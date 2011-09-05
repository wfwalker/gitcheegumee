class PlayersController < ApplicationController
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
    end
  end

  def move
    @player = Player.find(params[:id])
    @passage = Passage.find(params[:passage_id])

    if @player.location_id == @passage.source_id then
      @player.location_id = @passage.destination_id
      @player.save
    else
      raise "Illegal move, player %d in location %d using passage with source id %d" % [@player.id, @player.location.id, @passage.source_id]
    end

    redirect_to :action => 'show', :id => @player
  end

  def take
    @player = Player.find(params[:id])
    @item = Item.find(params[:item_id])

    if @player.location_id == @item.location_id then
      @item.player_id = @player.id
      @item.location_id = 0
      @item.save
    else
      raise "Illegal move, player %d in location %d using passage with source id %d" % [@player.id, @player.location.id, @passage.source_id]
    end

    redirect_to :action => 'show', :id => @player
  end

  def drop
    @player = Player.find(params[:id])
    @item = Item.find(params[:item_id])

    if @player.id == @item.player_id then
      @item.player_id = 0
      @item.location_id = @player.location_id
      @item.save
    else
      raise "Illegal move, player %d in location %d using passage with source id %d" % [@player.id, @player.location.id, @passage.source_id]
    end

    redirect_to :action => 'show', :id => @player
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

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    respond_to do |format|
      if @player.save
        format.html { redirect_to(@player, :notice => 'Player was successfully created.') }
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

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end
