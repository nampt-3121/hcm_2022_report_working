class Department < ApplicationRecord
  has_many :reports
  has_many :relationships
  has_many :users, through: :relationships
end
