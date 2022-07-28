class Report < ApplicationRecord
  belongs_to :from_user, class_name: User.name
  belongs_to :to_user, class_name: User.name
  belongs_to :department
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments, allow_destroy: true,
    reject_if: ->(attrs){attrs[:description].blank?}

  enum report_status: {unverifyed: 0, confirmed: 1}

  validates :report_date, presence: true,
            length: {maximum: Settings.digits.length_50}

  validates :today_plan, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :today_work, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :today_problem, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :tomorow_plan, presence: true,
            length: {maximum: Settings.digits.length_255}

  scope :sort_created_at, ->{order :created_at}

  scope :by_department, (lambda do |department_name|
    Report.joins(:department).where("name LIKE (?)", "%#{department_name}%") if department_name.present?
  end)

  scope :by_name, (lambda do |name|
    Report.joins(:from_user).where("full_name LIKE (?)", "%#{name}%") if name.present?
  end)

  scope :by_id, (lambda do |id|
    where(id: id) if id.present?
  end)

  scope :by_created_at, (lambda do |created_at|
    where(created_at: created_at) if created_at.present?
  end)

  scope :by_report_date, (lambda do |report_date|
    where(report_date: report_date) if report_date.present?
  end)

  scope :by_status, (lambda do |status|
    where(report_status: status) if status.present?
  end)

  def approve action
    return unverifyed! if action.eql? Settings.report.unverifyed

    confirmed! if action.eql? Settings.report.confirmed
  end
end
