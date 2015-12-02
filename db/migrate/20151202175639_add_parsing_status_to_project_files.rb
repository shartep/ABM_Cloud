class AddParsingStatusToProjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :parsing_status, :string
  end
end
