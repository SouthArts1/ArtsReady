class TodoNotesController < ApplicationController

  def new
    @todo_note = TodoNote.new
  end
  
  def create
    todo = current_user.todos.find(params[:todo_note].delete(:todo_id))
    @todo_note = current_user.todo_notes
      .merge(todo.todo_notes)
      .new(todo_note_params)

    if @todo_note.save
      redirect_to todo_path(@todo_note.todo), :notice => 'Note was successfully created.'
    else
      redirect_to todo_path(@todo_note.todo), :notice => 'There was a problem with your note'
    end

  end

  private

  def todo_note_params
    params.require(:todo_note).permit(
      :message
    )
  end
end