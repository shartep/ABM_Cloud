json.array!(@project_files) do |project_file|
  json.extract! project_file, :id, :file, :file_type
  json.url project_file_url(project_file, format: :json)
end
