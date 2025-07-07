class AddChildFirstNameAndLastNameToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_column :attendances, :child_first_name, :string
    add_column :attendances, :child_last_name, :string
  end
end
