class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :add_redis_user_auth


  # GET /profiles
  # GET /profiles.json
  def index
    if check_profile
      redirect_to :action => :show, :id => current_user.profile
    else
      redirect_to :action => :new
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    redirect_to :action => :show_with_username, :username => Profile.find(params[:id]).username
  end

  def show_with_username
    @profile = Profile.find_by_username(params[:username])
  end

  # GET /profiles/new
  def new
    if current_user.profile
      redirect_to :action => :index
    else
      @profile = Profile.new
    end
  end

  # GET /profiles/1/edit
  def edit
    unless check_owner(Profile.find(params[:id]))
      redirect_to :action => :index
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    unless check_owner(Profile.find(params[:id]))
      redirect_to :action => :index
    end
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end

  def follow_list
    @profiles = Profile.all
  end

  def search
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { }
    end
  end

  def follow
    @profile = Profile.find(params[:id])
    @me = current_user.profile
    if @me == @profile
      flash[:alert] = 'Something is wrong, you can\'t follow yourself'
    elsif @me.follow(@profile)
      flash[:notice] = 'You now follow ' + @profile.first_name
      cast_to_list(@me.followers, @me.first_name + ' is now following ' + @profile.first_name)
    else
      flash[:notice] = 'You already follow ' + @profile.first_name
    end
    redirect_to :back
  end

  def unfollow
    @profile = Profile.find(params[:id])
    @me = current_user.profile
    if @me == @profile
      flash[:alert] = 'You wern\'t supposed to be able to follow yourself, how did you do that? :D'
    elsif @me.unfollow(@profile)
      flash[:alert] = 'You have unfollowed ' + @profile.first_name
      cast_to_list(@me.followers, @me.first_name + ' no longer follows ' + @profile.first_name)
    else
      flash[:alert] = 'You don\'t follow ' + @profile.first_name
    end
    redirect_to :back
  end

  def following
    @profiles = Profile.find_by_username(params[:username]).following
    render :layout => false
  end

  def followers
    @profiles = Profile.find_by_username(params[:username]).followers
    render :layout => false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :birth_day, :is_female, :info, :about, :username, :avatar)
  end

  def check_owner(profile)
    if current_user.profile
      current_user.profile == profile
    else
      false
    end
  end

  def check_profile
    @user = current_user
    if @user.profile
      true
    else
      false
    end
  end

  def add_redis_user_auth
    channel = String(current_user.id)
    digest = Digest::SHA1.hexdigest(channel)
    if $redis.get('/notifications/' + channel) == nil or $redis.get('/notifications/' + channel) != digest
      $redis.set('/notifications/' + channel, digest)
    end
  end
end
