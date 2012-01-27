require 'rubygems'
require 'graphviz'  # this loads the ruby-graphviz gem

class LocationsController < ApplicationController

  before_filter :verify_admin_credentials, :except => [:show_recent_happenings, :show_recently_updated_players, :show_items]
  before_filter :verify_and_update_activity_timer  

  TMP_GRAPHVIZ_IMAGE_PATH = Rails.root.join('tmp/locations.png')

  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
      format.dot # index.dot.erb
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
      format.json  { render :json => @location }
    end
  end

  def show_recently_updated_players
    @location = Location.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @location.players.recently_updated }
      format.json  { render :json => @location.players.recently_updated }
    end
  end

  def show_recent_happenings
    logger.error("recenthappenings: %s" % session[:email])

    @location = Location.find(params[:id])
    recent_happenings = @location.happenings.recent

    respond_to do |format|
      format.xml  { render :xml => recent_happenings }
      format.json  { render :json => recent_happenings }
    end
  end

  def show_items
    @location = Location.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @location.items }
      format.json  { render :json => @location.items }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end

  def serve_graph()
    send_file TMP_GRAPHVIZ_IMAGE_PATH
  end

  def generate_graph()
    # initialize new Graphviz graph
    g = GraphViz.new( :G, :type => :digraph )

    nodes = {}
    for location in Location.find(:all)
      nodes[location.id] = g.add_node(location.title)
    end

    for passage in Passage.find(:all)
      g.add_edge(nodes[passage.source_id], nodes[passage.destination_id])
    end

    g.output( :png => TMP_GRAPHVIZ_IMAGE_PATH )

    respond_to do |format|
      format.json { render :json => {:path => 'locations/serve_graph'} }
    end
  end
end
