class ReportsController < ApplicationController
  before_action :find_department, only: %i(new create)
  before_action :find_manager, only: %i(new create)
  before_action :find_relationship, only: :index
  before_action :find_report, only: :show
  before_action :paginate_reports, only: :index

  def index; end

  def show; end

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

  def find_relationship
    @relationship = Relationship.find_by department_id: params[:department_id],
                                         user_id: current_user.id
    return if @relationship.present?

    flash[:warning] = t ".invalid_relationship"
    redirect_to root_path
  end

  def find_report
    @report = Report.find_by id: params[:id]
    return if @report.present?

    flash[:warning] = t ".invalid_report"
    redirect_to root_path
  end

  def paginate_reports
    @pagy, @reports = pagy find_all_reports, items: Settings.report.per_page
  end

  def filter_report
    filter = params[:filter]
    return @reports unless filter

    @reports = @reports.by_id(filter[:id])
                       .by_department(filter[:department])
                       .by_name(filter[:name])
                       .by_created_at(filter[:date_created])
                       .by_report_date(filter[:date_reported])
                       .sort_created_at
  end

  def find_all_reports
    @reports = if @relationship&.manager? || current_user.admin?
                 Report.where department_id: params[:department_id]
               else
                 Report.where from_user_id: current_user.id
               end
    filter_report
  end
end
