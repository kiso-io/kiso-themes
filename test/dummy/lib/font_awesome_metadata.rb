class FontAwesomeMetadata
  def initialize(attributes={})
    attributes.each_pair do |name, val|
      instance_variable_set "@#{name}", val
      define_accessor name
    end
  end

  def to_param
    id
  end

  def self.collection
    FontAwesomeMetadata.load if @fa.nil? || Rails.env.development?
    @fa
  end

  def self.load
    path = Rails.root.join("config", "fontawesome.yml")
    @fa = ActiveSupport::OrderedHash.new

    YAML.load_file(path)['icons'].each do |attributes|
      theme = new(attributes)
      @fa[theme.to_param] = theme
    end
  end

  def self.all
    collection.values
  end

  def self.find(id)
    collection[id.to_s] || raise(ActiveRecord::RecordNotFound, "Couldn't find Theme #{id}")
  end

  private
    def define_accessor(name)
      class_eval "def #{name}; @#{name}; end" unless self.class.method_defined?(name)
    end

end