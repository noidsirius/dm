class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]

  # GET /auctions
  # GET /auctions.json
  def index
    @auctions = Auction.all
  end

  # GET /auctions/1
  # GET /auctions/1.json
  def show
    @target_label = "NONE"
    @target_time = Time.now
    if !@auction.is_started?
      @target_time = @auction.start_time
      @target_label = "Start"
    elsif !@auction.is_finished?
      @target_time = @auction.end_time
      @target_label = "End"
    end
  end

  # GET /auctions/new
  def new
    if !current_user.has_role?("admin")
      redirect_to auctions_path
      return
    end
    @auction = Auction.new
    render layout: false
  end

  # GET /auctions/1/edit
  def edit
    if !current_user.has_role?("admin")
      redirect_to auctions_path
      return
    end
  end

  # POST /auctions
  # POST /auctions.json
  def create
    if !current_user.has_role?("admin")
      redirect_to auctions_path
      return
    end
    @auction = Auction.new(auction_params)

    respond_to do |format|
      if @auction.save
        format.html { redirect_to @auction, notice: 'Auction was successfully created.' }
        format.json { render :show, status: :created, location: @auction }
      else
        format.html { render :new }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auctions/1
  # PATCH/PUT /auctions/1.json
  def update
    if !current_user.has_role?("admin")
      redirect_to auctions_path
      return
    end
    respond_to do |format|
      if @auction.update(auction_params)
        format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction }
      else
        format.html { render :edit }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.json
  def destroy
    if !current_user.has_role?("admin")
      redirect_to auctions_path
      return
    end
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to auctions_url, notice: 'Auction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = Auction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_params
      params.require(:auction).permit(:name, :base_price, :start_time, :end_time, :problem_id)
    end
end
