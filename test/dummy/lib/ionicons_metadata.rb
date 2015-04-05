class IoniconsMetadata
  def initialize(attributes={})
    attributes.each_pair do |name, val|
      instance_variable_set "@#{name}", val
      define_accessor name
    end
  end

  def id
    name
  end

  def to_param
    name
  end

  def self.collection
    IoniconsMetadata.load if @fa.nil? || Rails.env.development?
    @fa
  end

  def self.load
    path = Rails.root.join("config", "ionicons.yml")
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