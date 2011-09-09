class HappeningsController < ApplicationController
  # GET /happenings
  # GET /happenings.xml
  def index
    @happenings = Happening.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @happenings }
    end
  end

  # GET /happenings/1
  # GET /happenings/1.xml
  def show
    @happening = Happening.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @happening }
    end
  end

  # GET /happenings/new
  # GET /happenings/new.xml
  def new
    @happening = Happening.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @happening }
    end
  end

  # GET /happenings/1/edit
  def edit
    @happening = Happening.find(params[:id])
  end

  # POST /happenings
  # POST /happenings.xml
  def create
    @happening = Happening.new(params[:happening])

    respond_to do |format|
      if @happening.save
        format.html { redirect_to(@happening, :notice => 'Happening was successfully created.') }
        format.xml  { render :xml => @happening, :status => :created, :location => @happening }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @happening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /happenings/1
  # PUT /happenings/1.xml
  def update
    @happening = Happening.find(params[:id])

    respond_to do |format|
      if @happening.update_attributes(params[:happening])
        format.html { redirect_to(@happening, :notice => 'Happening was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @happening.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /happenings/1
  # DELETE /happenings/1.xml
  def destroy
    @happening = Happening.find(params[:id])
    @happening.destroy

    respond_to do |format|
      format.html { redirect_to(happenings_url) }
      format.xml  { head :ok }
    end
  end
end
