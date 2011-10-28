class TodoMailer < ActionMailer::Base
  default :from => "admin@artsready.org"
  layout 'email'
  
  def assign_to(user, todo)
    @user = user
    @url = todo_url(todo)
    @todo = todo
    mail(:to => user.email,
         :subject => "You have a new ArtsReady To-Do")
  end
  
  def reassign_to(user, todo)
    @user = user
    @url = todo_url(todo)
    @todo = todo
    mail(:to => user.email,
         :subject => "You have a new To-Do item at ArtsReady!")
  end
  
  def reminder(todo)
    @todo = todo
    mail(:to => todo.user.email,
         :subject => "Your ArtsReady To-Do is Due!")
  end
  
end
