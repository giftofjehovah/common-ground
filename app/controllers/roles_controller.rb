class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project

  def index
    @roles = Role.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @role = Role.create({
      user_id: current_user.id,
      project_id: 8,
      role: 'collaborator'
      })

    respond_to do |format|
      if @role.save
        format.html { redirect_to project_path(@project), notice: 'Welcome to this project!' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def role_params
      params.require(:role).permit(:user_id, :project_id, :role)
    end
end
