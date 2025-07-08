class CreateAttendanceHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_histories do |t|
      t.references :attendance, null: false, foreign_key: true
      t.string :status, null: false
      t.text :message
      t.string :child_name, null: false
      t.date :date, null: false
      t.string :parent_name, null: false
      t.string :changed_by, null: false
      t.datetime :changed_at, null: false

      t.timestamps
    end
    
    add_index :attendance_histories, [:attendance_id, :changed_at]
  end
end
