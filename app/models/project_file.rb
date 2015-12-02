class ProjectFile < ActiveRecord::Base
  before_save :set_file_type
  after_create :parse_file

  has_attached_file :file

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: 'text/csv'
  validate :validate_file_name

  TYPES = [:products, :suppliers]
  PARSING_STATUSES = [:uploaded, :parsing, :complete]

  private
    def set_file_type
      if self.file_file_name.include? 'sku'
        self.file_type = :products
      elsif self.file_file_name.include? 'suppliers'
        self.file_type = :suppliers
      end
      self.parsing_status = :uploaded
    end

    def parse_file
      self.update parsing_status: :parsing
      puts "start parsing file #{self.file_file_name}, type - #{self.file_type}"
    end

    def validate_file_name
      if ['sku.csv', 'suppliers.csv'].any? { |fn| self.file_file_name == fn }
        true
      else
        self.errors.add(:base, 'file name is wrong, please upload sku.csv or suppliers.csv file')
        false
      end
    end
end
