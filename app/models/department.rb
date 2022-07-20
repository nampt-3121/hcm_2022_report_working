class Department < ApplicationRecord
  has_many :reports, dependent: :destroy
  has_many :relationships, dependent: :destroy
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

  scope :by_name, (lambda do |name|
    where(["name LIKE (?)", "%#{name}%"]) if name.present?
  end)

  scope :by_description, (lambda do |description|
    where(["description LIKE (?)", "%#{description}%"]) if description.present?
  end)

  def display_avatar width = Settings.gravatar.width_default,
    height = Settings.gravatar.height_default
    avatar.variant resize_to_limit: [width, height]
  end

  def add_user user
    users << user
  end
end
