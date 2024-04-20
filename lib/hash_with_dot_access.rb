module HashWithDotAccess
  module Utils
    def self.normalized_value(obj, value)
      return value if value.instance_of?(obj.class)

      case value
      when ::Hash
        obj.class.new(value)
      when Array
        value = value.dup if value.frozen?
        value.map! { normalized_value(obj, _1) }
      else
        value
      end
    end
  end

  class Hash < ::Hash
    class << self
      undef_method :[]
    end

    def initialize(hsh = nil)
      super
      return unless hsh

      update(hsh)
      self.default_proc = hsh.default_proc
      self.default = hsh.default
    end

    def respond_to_missing?(key, *args)
      return false unless args.empty?

      return true if "#{key}".end_with?("=")

      key?(key)
    end

    def key?(key) = super(key.to_s)

    alias_method :has_key?, :key?
    alias_method :include?, :key?
    alias_method :member?, :key?

    # save previous method
    alias_method :_assign, :[]=

    def [](key) = super(key.to_s)

    def []=(key, value)
      _assign(key.to_s, Utils.normalized_value(self, value))
    end

    alias_method :store, :[]=

    def fetch(key, *args) = super(key.to_s, *args)

    def assoc(key, *args) = super(key.to_s)

    def values_at(*keys) = super(*keys.map!(&:to_s))

    def fetch_values(*keys) = super(*keys.map!(&:to_s))

    def method_missing(method_name, *args)
      key = method_name.to_s
      if key.end_with?("=")
        key_chop = key.chop
        self.class.define_method(key) { |value| self[key_chop] = value }
        self[key.chop] = args.first
      elsif self.key?(key)
        self.class.define_method(key) { self[key] }
        self[key]
      elsif default_proc
        super unless args.empty?
        default_proc.call(self, key)
      else
        super unless args.empty?
        default
      end
    end

    def update(*other_hashes)
      other_hashes.each do |other_hash|
        if other_hash.is_a? HashWithDotAccess::Hash
          super(other_hash)
        else
          other_hash.to_hash.each do |key, value|
            key = key.to_s
            if block_given? && key?(key)
              value = yield(key, self[key], value)
            end
            _assign(key, Utils.normalized_value(self, value))
          end
        end
      end

      self
    end

    alias_method :merge!, :update

    def merge(...) = dup.update(...)

    def replace(...)
      clear
      update(...)
    end

    def dig(*args)
      super(args[0].to_s, *args[1..])
    end

    def delete(key) = super(key.to_s)

    def except(*keys) = super(*keys.map!(&:to_s))

    def slice(*keys) = self.class.new(super(*keys.map!(&:to_s)))

    def select(...)
      return to_enum(:select) unless block_given?

      dup.tap { _1.select!(...) }
    end

    def reject(...)
      return to_enum(:reject) unless block_given?

      dup.tap { _1.reject!(...) }
    end

    def transform_values(...)
      return to_enum(:transform_values) unless block_given?

      dup.tap { _1.transform_values!(...) }
    end

    def compact
      dup.tap { _1.compact! }
    end
  end

  module Refinements
    refine ::Hash do
      def as_dots
        HashWithDotAccess::Hash.new(self)
      end
    end
  end
end
