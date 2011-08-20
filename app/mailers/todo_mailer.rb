class TodoMailer < ActionMailer::Base
  default :from => "no-reply@artsready.com"
  layout 'email'
  
  def assign_to(user, todo)
    @user = user
    @url = todo_url(todo)
    @todo = todo
    mail(:to => user.email,
         :subject => "You have a new To Do item at ArtsReady!", :bcc => 'john.paul.ashenfelter@gmail.com')
  end
  
  def reassigned_todo(user, todo)
    @user = user
    @url = todo_url(todo)
    @todo = todo
    mail(:to => user.email,
         :subject => "You have a new To Do item at ArtsReady!", :bcc => 'john.paul.ashenfelter@gmail.com')
  end
  
end
