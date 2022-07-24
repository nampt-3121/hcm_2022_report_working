class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :report

  validates :description, presence: true,
            length: {maximum: Settings.digits.length_255}
end
