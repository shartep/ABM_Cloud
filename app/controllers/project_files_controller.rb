class ProjectFilesController < ApplicationController
  before_action :set_project_file, only: [:show, :edit, :update, :destroy]

  # GET /project_files
  # GET /project_files.json
  def index
    @project_files = ProjectFile.all
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
  end

  # GET /project_files/new
  def new
    @project_file = ProjectFile.new
  end

  # GET /project_files/1/edit
  def edit
  end

  # POST /project_files
  # POST /project_files.json
  def create
    @project_file = ProjectFile.new(project_file_params)

    respond_to do |format|
      if @project_file.save
        format.html { redirect_to @project_file, notice: 'Project file was successfully created.' }
        format.json { render :show, status: :created, location: @project_file }
      else
        format.html { render :new }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_files/1
  # PATCH/PUT /project_files/1.json
  def update
    respond_to do |format|
      if @project_file.update(project_file_params)
        format.html { redirect_to @project_file, notice: 'Project file was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_file }
      else
        format.html { render :edit }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_files/1
  # DELETE /project_files/1.json
  def destroy
    @project_file.destroy
    respond_to do |format|
      format.html { redirect_to project_files_url, notice: 'Project file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_file
      @project_file = ProjectFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_file_params
      params.require(:project_file).permit(:file)
    end
end
