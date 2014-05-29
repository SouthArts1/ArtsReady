module AdminStepHelpers
  def edit_organization(org)
    with_scope table_row_where('name' => org) do
      click_link 'Edit'
    end
  end

  def edit_last_organization
    click_on 'Manage Organizations'
    all(:link, 'Edit').last.click
  end

  def visit_admin_notes_for(org_name)
    click_on 'Manage Organizations'
    edit_organization(org_name)
    click_on 'Notes'
  end

  def payment_table
    # exclude the footer row, since Cucumber::Ast::Table doesn't
    # understand it.
    rows = page.find('#payments').all('thead tr, tbody tr')
    Cucumber::Ast::Table.new(
      rows.map do |row|
        row.
          # exclude the actions column, since it's not germane
          # to our tests
          all('td:not(:last-child), th:not(:last-child)').
          map(&:text)
      end
    )
  end
end
World(AdminStepHelpers)