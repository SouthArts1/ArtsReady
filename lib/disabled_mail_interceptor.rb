class DisabledMailInterceptor

  def self.delivering_email(message)
    addrs =  deliverable_recipients(message)

    if addrs.empty?
      message.perform_deliveries = false
    elsif addrs != message.to
      message.to = addrs
    end # else deliver the message unaltered
  end

  def self.deliverable_recipients(message)
    message.to_addrs.select do | addr |
      User.send_email_to_address?(addr)
    end
  end
end
