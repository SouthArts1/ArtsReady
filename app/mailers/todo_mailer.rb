class TodoMailer < ActionMailer::Base
  default :from => "no-reply@artsready.com"
  
  def todo_mailer(user, todo)
    @user = user
    @url = "http://artsready.com#{todo_path(todo)}"
    @todo = todo
    mail(:to => user.email,
         :subject => "You have a new To Do item at ArtsReady!")
  end
  
end
