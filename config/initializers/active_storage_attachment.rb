require "active_storage/attachment"

class ActiveStorage::Attachment
  after_create_commit :resize_image

  def resize_image
    return unless image?

    thumnail
    medium
  end

  def thumnail
    variant(resize_to_limit: ["150!", "150!"]).processed
  end

  def medium
    variant(resize_to_limit: ["1000!", "1000!"]).processed
  end
end
