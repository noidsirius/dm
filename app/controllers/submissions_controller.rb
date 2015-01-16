class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :accept, :reject]

  # GET /submissions
  # GET /submissions.json
  def index
    if current_user.has_role?("admin")
      if params[:all]
        @submissions = Submission.all
      else
        @submissions = Submission.where("status = 0")
      end
    else
      @submissions = current_user.profile.submissions
    end
    #@submissions = Submission.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    if !current_user.has_role?("admin") and @submission.profile != current_user.profile
      redirect_to submissions_path
    end
    @problem = Problem.find(@submission.problem_id)
  end

  def accept
    if !current_user.has_role?("admin")
      redirect_to submissions_path
      return
    end
    @submission.status = 2
    @submission.save
    Invoice.create!(profile_id: params[:pid], amount: @submission.problem.level.bounty)
    UserMailer.submission_response(@submission).deliver
    redirect_to submissions_path
  end

  def reject
    if !current_user.has_role?("admin")
      redirect_to submissions_path
      return
    end
    @submission.status = 1
    @submission.save
    #UserMailer.submission_response(@submission).deliver
    redirect_to submissions_path
    #Invoice.create!(profile_id: params[:pid], amount: @submission.problem.level.bounty)
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
    unless params[:problem_id]
      params[:problem_id] = 1
    end
    @submission.problem_id = params[:problem_id]
    @problem = Problem.find(@submission.problem_id)
    unless @problem.can_submit(current_user.profile)
      redirect_to @problem
    end
    render layout: false
  end

  # GET /submissions/1/edit
  def edit
    if !current_user.has_role?("admin")
      redirect_to submissions_path
      return
    end
  end

  # POST /submissions
  # POST /submissions.json
  def create
    if Submission.where("profile_id = ?", current_user.profile.id).where("problem_id = ?",params[:problem_id]).where("status = 0").any?
      format.html { redirect_to Problem.find(params[problem_id]), notice: 'You have submitted before' }
    end
    @submission = Submission.new(submission_params)
    @submission.profile_id = current_user.profile.id

    puts "XARE NOOB E SAG"
    puts params[:problem_id]


    respond_to do |format|
      if @submission.save
        UserMailer.submission_complete(@submission).deliver
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    if !current_user.has_role?("admin")
      redirect_to submissions_path
      return
    end

    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    if !current_user.has_role?("admin")
      redirect_to submissions_path
      return
    end

    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:profile_id, :problem_id, :status, :description, :attachment)
    end
end
