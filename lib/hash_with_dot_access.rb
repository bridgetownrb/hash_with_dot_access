require "active_support/core_ext/hash/indifferent_access"

module HashWithDotAccess
  class Hash < ActiveSupport::HashWithIndifferentAccess
    def respond_to_missing?(key, *)
      return true if "#{key}".end_with?("=")

      key?(key)
    end

    def method_missing(key, *args)
      if "#{key}".end_with?("=")
        self["#{key}".chop] = args.first
      elsif self.key?(key)
        self[key]
      else
        default
      end
    end

    def update(other_hash)
      if other_hash.is_a? HashWithDotAccess::Hash
        super(other_hash)
      else
        other_hash.to_hash.each_pair do |key, value|
          if block_given? && key?(key)
            value = yield(convert_key(key), self[key], value)
          end
          regular_writer(convert_key(key), convert_value(value))
        end
        self
      end
    end

    private

    def convert_value(value, options = {}) # :doc:
      if value.is_a? ::Hash
        if options[:for] == :to_hash
          value.to_hash
        else
          value.with_dot_access
        end
      elsif value.is_a?(Array)
        if options[:for] != :assignment || value.frozen?
          value = value.dup
        end
        value.map! { |e| convert_value(e, options) }
      else
        value
      end
    end
  end
end

class Hash
  def with_dot_access
    HashWithDotAccess::Hash.new(self)
  end
end
