class Reminder
  
  def self.todos_nearly_due
    Todo.nearing_due_date.each do |todo|
      TodoMailer.reminder(todo)
    end
  end
  
end