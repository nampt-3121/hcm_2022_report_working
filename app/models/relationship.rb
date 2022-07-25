class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :department

  enum role_type: {employee: 0, manager: 1}
end
