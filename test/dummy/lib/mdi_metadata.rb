class MdiMetadata
  def initialize(attributes={})
    attributes.each do |name|
      instance_variable_set "@#{name.underscore}", name
      define_accessor name.underscore
    end
  end

  def self.collection
    MdiMetadata.load if @fa.nil? || Rails.env.development?
    @fa
  end

  def self.load
    path = Rails.root.join("config", "mdiicons.yml")
    @fa = ActiveSupport::OrderedHash.new

    attributes = YAML.load_file(path)

    @fa = attributes
  end

  def self.all
    collection
  end
end