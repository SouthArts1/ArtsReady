if Rails.env.development?

  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if defined?(DevelopmentMailInterceptor)

  Footnotes.run! if defined?(Footnotes)
  Footnotes::Notes::AssignsNote.ignored_assigns += [:@_env]

end