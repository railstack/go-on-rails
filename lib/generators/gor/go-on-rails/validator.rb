module GoOnRails
  class Validator
    TAG_DELIM = ","

    def initialize(klass)
      @klass = klass
    end
    attr_reader :klass

    def build_validator_tag(col)
      # ignore checking for some automaticly created fields
      return "valid:\"-\"" if %w(id created_at updated_at).include?(col.name)
      tags = []

      validators = self.klass.validators_on col.name

      validators.each do |validator|
        tags.concat get_validation(validator, col)
      end

      tags << 'optional' if col.null && !tags.empty? && tags.exclude?('required')

      if tags.present?
        return "valid:\"#{tags.uniq.join(TAG_DELIM)}\""
      else
        return "valid:\"-\""
      end
    end

    def get_validation(validator, col)
        rules = []
        case validator.class.to_s
        when "ActiveRecord::Validations::PresenceValidator"
          rules << "required"
        when "ActiveModel::Validations::FormatValidator"
          if validator.options && validator.options[:with] && ['string', 'text'].include?(col.type.to_s)
            re = $1 || ".*" if validator.options[:with].inspect =~ /\/(.*)\//
            rules << "matches(#{re})"
          end
        when "ActiveModel::Validations::NumericalityValidator"
          if validator.options && validator.options[:only_integer]
            rules << "IsInt"
          else
            rules << "IsNumeric"
          end
        when "ActiveModel::Validations::InclusionValidator"
          [:in, :within].each do |i|
            if validator.options && validator.options[i]
              rules << "in(#{validator.options[i].join('|')})" if ['string', 'text'].include?(col.type.to_s)
            end
          end
        when "ActiveRecord::Validations::LengthValidator"
          if validator.options && ['string', 'text'].include?(col.type.to_s)
            if validator.options[:is]
              min = max = validator.options[:is]
            else
              min = validator.options[:minimum] ? validator.options[:minimum] : 0
              max = validator.options[:maximum] ? validator.options[:maximum] : 4_294_967_295
            end
            rules << sprintf("length(%d|%d)", min, max)
          end
        end
        rules
    end
  end
end
