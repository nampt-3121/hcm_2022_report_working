module NotifiesHelper
  def create_notify assign_uid, msg, link
    @notify = Notify.create user_id: assign_uid, msg: msg, link: link
    NotifyMailer.new_notify(@notify).deliver_now if @notify.save
  end
end
