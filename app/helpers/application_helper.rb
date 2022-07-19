module ApplicationHelper
  def full_title page_title = ""
    base_title = t "base_title"
    page_title.blank? ? base_title : page_title.concat(" | ").concat(base_title)
  end
end
