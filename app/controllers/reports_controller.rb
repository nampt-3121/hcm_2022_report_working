class ReportsController < ApplicationController
  before_action :find_department, only: %i(new create)
  before_action :find_manager, only: %i(new create)

  def index
    @relationship = Relationship.find_by department_id: params[:department_id], user_id: current_user.id
    if @relationship&.manager? || current_user.admin?
      @reports = Report.where :department_id => params[:department_id]
    else
      @reports = Report.where from_user_id: current_user.id
    end
  end

  def show
    @report = Report.find_by id: params[:id]
  end

  def new
    @report = Report.new
  end

  def create
    @report = @department.reports.build report_params
    @report.from_user_id = current_user.id
    if @report.save
      flash[:success] = t ".create_report_message"
      redirect_to root_path
    else
      flash.now[:danger] = t ".create_report_error"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:report_date, :today_plan, :today_work,
                                   :today_problem, :tomorow_plan, :to_user_id)
  end

  def find_department
    @department = Department.find_by id: params[:department_id]
    return if @department

    flash[:danger] = t "invalid_department"
    redirect_to root_path
  end

  def find_manager
    @managers = Relationship.where department_id: @department.id,
                                   role_type: :manager
    return if @managers.present?

    flash[:warning] = t ".unprepared_manager"
    redirect_to root_path
  end
end
