class RelationshipsController < ApplicationController
  before_action :find_department, only: %i(new create)
  before_action :find_user, only: :create
  before_action :find_relationship, only: %i(update destroy)
  before_action :paginate_users, only: :new
  Pagy::DEFAULT[:items] = Settings.relationship.per_page

  def new; end

  def create
    @user.join_department @department
    create_notify @user.id, t("join_department"),
                  department_path(@department.id)
    flash[:success] = t ".success_message"
    redirect_back(fallback_location: root_path)
  end

  def update
    role = params[:role]
    if @relationship.update(role_type: role)
      create_notify @relationship.user_id, t("role_department"),
                    department_path(@relationship.department.id)
      flash[:success] = t ".update_success"
    else
      flash[:danger] = t ".update_failure"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @relationship.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_failure"
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def show_error message
    flash[:danger] = message
    redirect_to root_path
  end

  def find_department
    require_manager params[:department_id]
    @department = Department.find_by id: params[:department_id]
    show_error t ".department_not_found" if @department.nil?
  end

  def find_user
    @user = User.find_by id: params[:user_id]
    show_error t ".user_not_found" if @user.nil?
  end

  def find_relationship
    @relationship = Relationship.find_by id: params[:id]
    require_manager @relationship.department_id
    show_error t ".relationship_not_found" if @relationship.nil?
  end

  def paginate_users
    @pagy, @users = pagy filter_user.includes([:avatar_attachment])
                                    .users_not_in_department @department.id
  end

  def filter_user
    return User.all unless params[:filter]

    @users = User.by_email(params[:filter][:email_search])
                 .by_full_name(params[:filter][:full_name_search])
  end
end
