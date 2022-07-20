class Department < ApplicationRecord
  has_many :reports, dependent: :destroy
  has_many :relationshipsm, dependent: :destroy
  has_many :users, through: :relationships

  validates :name, presence: true,
            length: {maximum: Settings.digits.length_50},
            uniqueness: true

  validates :description, presence: true,
            length: {maximum: Settings.digits.length_255}

  validates :avatar,
            content_type: {in: Settings.image.accept_format,
                           message: I18n.t(".invalid_img_type")},
            size: {less_than: Settings.image.max_size.megabytes,
                   message: I18n.t(".invalid_img_size")}

  has_one_attached :avatar

  before_save :downcase_name

  def display_avatar width = Settings.gravatar.width_default,
    height = Settings.gravatar.height_default
    avatar.variant resize_to_limit: [width, height]
  end

  private

  def downcase_name
    name.downcase!
  end
end
