module AdminStepHelpers
  def within_organization_row(org)
    with_scope table_row_where('name' => org) do
      yield
    end
  end

  def edit_organization(org)
    click_on 'Manage Organizations' if first(:link, 'Manage Organizations')

    within_organization_row(org) do
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
    # exclude the footer row, since Cucumber::Ast::DataTable doesn't
    # understand it.
    rows = page.find('#subscription_events').all('thead tr, tbody tr')
    Cucumber::Ast::Table.new(Cucumber::Core::Ast::DataTable.new(
      rows.map do |row|
        row.
          # exclude the actions column, since it's not germane
          # to our tests
          all('td:not(:last-child), th:not(:last-child)').
          map(&:text)
      end,
      Cucumber::Core::Ast::Location.of_caller
    ))
  end
end
World(AdminStepHelpers)