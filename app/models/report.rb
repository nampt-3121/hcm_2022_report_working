class Report < ApplicationRecord
  belongs_to :from_user, class_name: :User
  belongs_to :to_user, class_name: :User
  belongs_to :department
  has_many :comments, dependent: :destroy

  enum report_status: {Unverifyed: 0, confirmed: 1}

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
end
