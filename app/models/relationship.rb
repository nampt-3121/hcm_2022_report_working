class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :department

  delegate :id, :full_name, to: :user

  enum role_type: {employee: 0, manager: 1}
end
