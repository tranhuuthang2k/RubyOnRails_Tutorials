class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[ show edit update destroy ]
  skip_before_action :redirect_to_users
  
  # GET /microposts or /microposts.json
  def index
  
    @content = params[:content]
    @microposts = ( @content.present? ? Micropost.where("content LIKE ?", "%" + @content + "%") : Micropost.all).paginate(page: params[:page])
  end

  # GET /microposts/1 or /microposts/1.json
  def show

  end

  # GET /microposts/new
  def new
  
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
    unless current_user.admin || current_user?(@micropost.user)
      redirect_to microposts_path	
      flash[:danger] = t "You must be admin or this user"
    end
    @edit=true
  end

  # POST /microposts or /microposts.json
  def create
    @micropost = current_user.microposts.new(micropost_params)
    respond_to do |format|
      if @micropost.save
        flash[:success] = t "Micropost was successfully created"
        format.html { redirect_to current_user }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        flash[:success] = t "Micropost was successfully updated"
        format.html { redirect_to @micropost }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    @micropost.destroy
    respond_to do |format|
      flash[:success] = t "Micropost was successfully destroyed"
      format.html { redirect_to current_user}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:content,:image)
    end
end
