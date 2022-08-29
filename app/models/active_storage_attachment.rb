require 'active_storage/attachment'

class ActiveStorage::Attachment
  after_save :do_something

  def do_something
    puts 'yeah!'
    debugger
  end
end
