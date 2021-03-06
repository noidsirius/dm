class BidsController < ApplicationController
  before_action :set_bid, only: [:show, :edit, :update, :destroy]

  # GET /bids
  # GET /bids.json
  def index
    if current_user.has_role?("admin")
      @bids = Bid.all
    else
      @bids = current_user.profile.bids
    end

  end

  # GET /bids/1
  # GET /bids/1.json
  def show
    if @bid.profile != current_user.profile
      redirect_to bids_path
    end
  end

  # GET /bids/new
  def new
    @bid = Bid.new
    @bid.auction_id = params[:auction_id]
    render layout: false
  end

  # GET /bids/1/edit
  def edit
    unless current_user.has_role?("admin")
      redirect_to bids_path
    end
  end

  # POST /bids
  # POST /bids.json
  def create

    @bid = Bid.new(bid_params)
    @bid.profile = current_user.profile

    respond_to do |format|
      if @bid.save
        Bid.where(:auction => 1).map { |b| b.profile }.uniq.each do |p|
          UserMailer.auction_change(@bid.auction,p.user,@bid).deliver
        end

        format.html { redirect_to @bid, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bids/1
  # PATCH/PUT /bids/1.json
  def update
    if !current_user.has_role?("admin")
      redirect_to bids_path
      return
    end
    respond_to do |format|
      if @bid.update(bid_params)
        format.html { redirect_to @bid, notice: 'Bid was successfully updated.' }
        format.json { render :show, status: :ok, location: @bid }
      else
        format.html { render :edit }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.json
  def destroy
    if !current_user.has_role?("admin")
      redirect_to bids_path
      return
    end
    @bid.destroy
    respond_to do |format|
      format.html { redirect_to bids_url, notice: 'Bid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bid
    @bid = Bid.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bid_params
    params.require(:bid).permit(:profile_id, :auction_id, :price)
  end
end
