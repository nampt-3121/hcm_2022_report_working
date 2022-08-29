class CustomImage < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_one_attached(:thumbnail) do |thumbnail|
    attachable.variant :thumbnail, resize_to_limit: [200, 100]
  end
  has_one_attached(:medium) do |medium|
    attachable.variant :medium, resize_to_limit: [700, 600]
  end
  has_one_attached :original

  def attach http_upload_file
    thumbnail.attach http_upload_file
    medium.attach http_upload_file
    original.attach http_upload_file
  end

  def resize http_upload_file, width, height
    path = http_upload_file.tempfile.path
    ImageProcessing::MiniMagick.source(path).resize_to_limit(1200, 1200)
  end
end
