module AdminStepHelpers
  def edit_organization(org)
    with_scope table_row_where('name' => org) do
      click_link 'Edit'
    end
  end

  def payment_table
    # exclude the footer row, since Cucumber::Ast::Table doesn't
    # understand it.
    rows = page.find('#payments').all('thead tr, tbody tr')
    Cucumber::Ast::Table.new(
      rows.map do |row|
        row.all('td, th').map(&:text)
      end
    )
  end
end
World(AdminStepHelpers)