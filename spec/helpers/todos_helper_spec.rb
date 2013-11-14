require 'spec_helper'

describe TodosHelper do
  describe '#todo_note_message' do
    let(:rendered) { helper.todo_note_message(note) }

    context '(given a note with an article)' do
      let(:note) { FactoryGirl.create(:todo_note, :article => article) }
      let(:article) { FactoryGirl.create(:article) }

      it 'links to the article' do
        rendered.should have_selector(
          "a[href='#{url_for(article)}']", :text => article.title)
      end
    end

    context '(given a note with no article)' do
      let(:note) { FactoryGirl.create(:todo_note) }

      it 'renders the text' do
        rendered.should_not have_selector('a')
        rendered.should have_content(note.message)
      end
    end
  end
end

