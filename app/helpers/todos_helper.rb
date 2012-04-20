module TodosHelper
  def todo_note_message(note)
    link_to_if note.article, note.message, note.article
  end
end
