class User < ApplicationRecord
  has_many :relationships, dependent: :destroy
  has_many :departments, through: :relationships
  has_many :report_sends, class_name: :Report, foreign_key: :from_user,
            dependent: :destroy
  has_many :report_receives, class_name: :Report, foreign_key: :to_user,
            dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: {user: Settings.role.user, admin: Settings.role.admin}

  VALID_EMAIL_REGEX = Settings.regex.email

  validates :full_name, presence: true,
            length: {maximum: Settings.digits.length_50}

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6},
            allow_nil: true

  validates :avatar,
            content_type: {in: Settings.image.accept_format,
                           message: I18n.t(".invalid_img_type")},
            size: {less_than: Settings.image.max_size.megabytes,
                   message: I18n.t(".invalid_img_size")}

  has_secure_password

  has_one_attached :avatar

  scope :by_email, ->(email){where email: email if email.present?}

  scope :by_full_name, ->(name){where full_name: name if name.present?}

  before_save :downcase_email

  def display_avatar
    avatar.variant(resize_to_limit: Settings.image.size_500_500)
  end

  private

  def downcase_email
    email.downcase!
  end
end
