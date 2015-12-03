class ProjectFile < ActiveRecord::Base
  # include Sidekiq::Worker

  before_create :set_file_type
  after_create :parse_file

  has_attached_file :file

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: 'text/csv'
  validate :validate_file_name

  TYPES = [:products, :suppliers]
  PARSING_STATUSES = [:uploaded, :parsing, :complete, :error]
  SUPPLIERS_FILE_COLUMNS = [:code, :name]
  PRODUCTS_FILE_COLUMNS = [:sku, :supplier_code, :field_1, :field_2, :field_3, :field_4, :field_5, :field_6, :price]

  def self.parse_products file
    error = false
    begin
      f = File.open(file.file.path)

      ## mark parsing as started
      file.update parsing_status: :parsing

      # TODO: add validation of .csv file header

      ## this is an all or nothing process, either all of the suppliers should be created, or none should
      ActiveRecord::Base.transaction do
        ## parse the CSV in chunks
        SmarterCSV.process(f, {chunk_size: 1000, strings_as_keys: true, convert_values_to_numeric: false, user_provided_headers: PRODUCTS_FILE_COLUMNS}) do |chunk|
          chunk.each do |prod_hash|
            raise Exception.new 'Error: there is product with empty sku in your file' if prod_hash[:sku].blank?
            raise Exception.new 'Error: there is supplier with empty code in your file' if prod_hash[:supplier_code].blank?

            Supplier.find_or_create_by code: prod_hash[:supplier_code]
            product = Product.find_or_initialize_by sku: prod_hash[:sku]
            product.attributes = prod_hash
            product.save
          end
        end
      end
    rescue Exception => e
      ## log the error and mark the file as errored
      puts e
      file.update parsing_status: e.message
      error = true
    end

    f.try(:close)
    file.update(parsing_status: :parsed) unless error
  end

  def self.parse_suppliers file
    error = false
    begin
      f = File.open(file.file.path)

      ## mark parsing as started
      file.update parsing_status: :parsing

      # TODO: add validation of .csv file header

      ## this is an all or nothing process, either all of the suppliers should be created, or none should
      ActiveRecord::Base.transaction do
        ## parse the CSV in chunks
        SmarterCSV.process(f, {chunk_size: 1000, strings_as_keys: true, convert_values_to_numeric: false, user_provided_headers: SUPPLIERS_FILE_COLUMNS}) do |chunk|
          chunk.each do |sup_hash|
            raise Exception.new 'Error: there is supplier with empty code in your file' if sup_hash[:code].blank?
            supplier = Supplier.find_or_initialize_by code: sup_hash[:code]
            supplier.name = sup_hash[:name]
            supplier.save if supplier.changed?
          end
        end
      end
    rescue Exception => e
      ## log the error and mark the file as errored
      puts e
      file.update parsing_status: e.message
      error = true
    end

    f.try(:close)
    file.update(parsing_status: :parsed) unless error
  end

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
      puts "start parsing file #{self.file_file_name}, type - #{self.file_type}"
      case self.file_type
        when :suppliers.to_s
          ProjectFile.delay.parse_suppliers self
        when :products.to_s
          ProjectFile.delay.parse_products self
        else
          self.update parsing_status: :error
      end
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
