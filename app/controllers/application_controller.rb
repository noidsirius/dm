class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :navbar_init
  before_action :set_locale
  before_action :check_time


  layout :layout_by_resource

  def single_cast(person, text)
    cast_to('/notifications/' + person.id.to_s, text)
  end

  def cast_to_list(followers, text)
    for f in followers
      cast_to('/notifications/' + f.id.to_s, text)
    end
  end

  def cast_to(channel, text)
    message = {:channel => channel, :data => text, :ext => {:serv_token => FAYE_TOKEN}}
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, :message => message.to_json)
  end


  protected

  def navbar_init
    @navbar = {}
    @navbar[:main] = 'discover'
    @navbar[:second] = []

    if self.class == ProfilesController
      @navbar[:second].append('<li class="active"><a href="/">Dashboard</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm">Dashboard</a></li>')
    end
    if self.class == ProblemsController
      @navbar[:second].append('<li class="active"><a href="/dm/problems">Problems</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/problems">Problems</a></li>')
    end
    if self.class == TeamsController
      @navbar[:second].append('<li class="active"><a href="/dm/scoreboard">ScoreBoard</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/scoreboard">ScoreBoard</a></li>')
    end
    if self.class == SubmissionsController
      @navbar[:second].append('<li class="active"><a href="/dm/submissions">Submissions</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/submissions">Submissions</a></li>')
    end
    if self.class == BidsController
      @navbar[:second].append('<li class="active"><a href="/dm/bids">bids</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/bids">Bids</a></li>')
    end
    if self.class == AuctionsController
      @navbar[:second].append('<li class="active"><a href="/dm/auctions">Auctions</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/auctions">Auctions</a></li>')
    end
    if self.class == ChaptersController
      @navbar[:second].append('<li class="active"><a href="/dm/chapters">Chapters</a></li>')
    else
      @navbar[:second].append('<li><a href="/dm/chapters">Chapters</a></li>')
    end
  end

  def layout_by_resource
    if devise_controller?
      'bg'
    else
      'application'
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_time
    @start_time = DateTime.new(2015,6,19,10,15,0,'+430')
    @end_time = DateTime.new(2015,6,19,12,30,0,'+430')

    @now_time = DateTime.now
    # if controller_name != "welcome"
      render 'welcome/index'
      return
      # redirect_to :controller => :welcome, :action => :index
    # end

    # if current_user and !current_user.profile.nil? and (controller_name != "welcome" and controller_name != "teams")
    #   unless current_user.has_role?(:admin)
    #     if @now_time < @start_time
    #       redirect_to :controller => :welcome, :action => :index
    #     elsif @now_time > @end_time
    #       redirect_to :controller => :teams, :action => :scoreboard
    #     end
    #   end
    # end
  end

end
