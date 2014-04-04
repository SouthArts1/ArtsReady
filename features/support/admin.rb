module AdminStepHelpers
  def edit_organization(org)
    with_scope table_row_where('name' => org) do
      click_link 'Edit'
    end
  end
end
World(AdminStepHelpers)