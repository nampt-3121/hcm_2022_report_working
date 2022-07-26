class Notify < ApplicationRecord
  belongs_to :user

  enum read: {unread: 0, read: 1}
end
