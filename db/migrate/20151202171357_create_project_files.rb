class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.attachment :file
      t.string :file_type

      t.timestamps null: false
    end
  end
end
