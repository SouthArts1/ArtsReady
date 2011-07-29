if defined?(ActiveReload) && Rails.env.development?

  puts Rails.logger.debug("Registering notifications for ActiveReload gem")

  ActiveSupport::Notifications.subscribe("active_reload.set_clear_dependencies_hook_replaced") do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    msg = event.name
    # Ubuntu: https://github.com/splattael/libnotify, Example: Libnotify.show(:body => msg, :summary => Rails.application.class.name, :timeout => 2.5, :append => true)
    # Macos: http://segment7.net/projects/ruby/growl/
    puts Rails.logger.warn(" --- #{msg} --- ")
  end

  ActiveSupport::Notifications.subscribe("active_support.dependencies.clear") do |*args|
    msg = "Code reloaded!"
    # Ubuntu: https://github.com/splattael/libnotify, Example: Libnotify.show(:body => msg, :summary => Rails.application.class.name, :timeout => 2.5, :append => true)
    # Macos: http://segment7.net/projects/ruby/growl/
    puts Rails.logger.info(" --- #{msg} --- ")
  end  
end
