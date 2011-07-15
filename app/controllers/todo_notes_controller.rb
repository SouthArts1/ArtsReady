class TodoNotesController < ApplicationController

  def new
    @todo_note = TodoNote.new
  end
  
  def create
    @todo_note = TodoNote.new(params[:todo_note])
    if @todo_note.save
      redirect_to todo_path(@todo_note.todo), :notice => 'Note was successfully created.'
    else
      redirect_to todo_path(@todo_note.todo), :notice => 'There was a problem with your note'
    end

  end
end