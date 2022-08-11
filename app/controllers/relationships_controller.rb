class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_relationship, only: %i(update destroy)
  before_action :paginate_users, only: :new
  before_action :relationship_params, only: :create
  Pagy::DEFAULT[:items] = Settings.relationship.per_page

  def new
    @departments = Department.sort_created_at
    @relationship = Relationship.new
  end

  def create
    Relationship.insert relationship_params[:department],
                        relationship_params[:user_id]

    flash[:info] = t "autd_success"
    redirect_to new_relationship_path
  end

  def update
    if @relationship.update_role params[:role]
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

  def find_relationship
    @relationship = Relationship.find params[:id]
    require_manager @relationship.department_id
  end

  def paginate_users
    @filter = User.sort_created_at.ransack(params[:filter])
    @pagy, @users = pagy @filter.result
  end

  def relationship_params
    params.require(:relationship).permit Relationship::UPDATEABLE_ATTRS
  end
end
