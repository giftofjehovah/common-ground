class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_mailbox, only: [:show, :create]
  before_action :get_conversation, only: [:show]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
    role = Role.create({
      user: current_user,
      project: @project,
      role: 'admin'
      })
  end

  def edit
    project_admin = Role.find_by(project_id: @project.id, role: 'admin').user_id
    unless current_user.id == project_admin
      redirect_to @project, notice: "This project doesn't belong to you!"
    end
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save

        receipt = current_user.send_message(current_user, params[:body], params[:subject])
        @project.mailboxer_conversation_id = receipt.conversation

        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :overview)
  end
end
