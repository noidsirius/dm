class CommentsController < ApplicationController

  before_filter :load_commentable

  def index
    @comments = @commentable.comments
  end

  def show
    @comment = @commentable.comments.find(params[:id])
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.profile = current_user.profile
    respond_to do |format|
      if @comment.save
        NeoComment(@comment.commentable_type, @comment.commentable_id)
        format.js {}
        format.html { redirect_to @commentable, notice: "Comment created." }
      else
        render :new
      end
    end
  end

  def edit
    @comment = @commentable.comments.find(params[:id])
    unless check_owner(@comment.profile)
      redirect_to :action => :index, notice: "You dont have access to edit."
    end
  end

  def update
    @comment = @commentable.comments.find(params[:id])
    unless check_owner(@comment.profile)
      redirect_to :action => :index, notice: "You dont have access to edit."
    end
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.delete
    NeoUncomment(@comment.commentable_type, @comment.commentable_id)
    @id = params[:id]
    respond_to do |format|
      format.js {}
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  # def load_commentable
  # klass = [Article, Photo, Event].detect { |c| params["#{c.name.underscore}_id"] }
  # @commentable = klass.find(params["#{klass.name.underscore}_id"])
  # end
  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type)
  end

  def check_owner(profile)
    if current_user.profile
      current_user.profile == profile
    else
      false
    end
  end

end
