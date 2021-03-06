class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy, :buy]

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
  end

  # GET /problems/new
  def new
    if !current_user.has_role?("admin")
      redirect_to problems_path
      return
    end

    @problem = Problem.new
    render :layout => "empty"
  end

  # GET /problems/1/edit
  def edit
    if !current_user.has_role?("admin")
      redirect_to problems_path
      return
    end

  end

  # POST /problems
  # POST /problems.json
  def create
    if !current_user.has_role?("admin")
      redirect_to problems_path
      return
    end

    @problem = Problem.new(problem_params)

    respond_to do |format|
      if @problem.save
        format.html { redirect_to @problem, notice: 'Problem was successfully created.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  def buy
    unless @problem.can_view(current_user.profile)
      current_user.profile.buy(@problem)
    end
    redirect_to :back
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    if !current_user.has_role?("admin")
      redirect_to problems_path
      return
    end

    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    if !current_user.has_role?("admin")
      redirect_to problem_path
      return
    end

    @problem.destroy
    respond_to do |format|
      format.html { redirect_to problems_url, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:title, :Description, :level_id, :attachment, :chapter_ids => [])
    end
end
