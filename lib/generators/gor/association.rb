module GoOnRails
  class Association
    def initialize(klass, models)
      @klass = klass
      @models = models
    end
    attr_reader :klass, :models

    def get_schema_info
      info = {struct_body: "", has_assoc_dependent: false, assoc_info: {has_many: {}, has_one: {}, belongs_to: {}}}
      self.klass.reflect_on_all_associations.each do |assoc|
        tags = ["json:\"#{assoc.name.to_s},omitempty\" db:\"#{assoc.name.to_s}\" valid:\"-\""]
        case assoc.macro
        when :has_many
          col_name = assoc.name.to_s.camelize
          class_name = assoc.name.to_s.singularize.camelize
          unless assoc.options.empty?
            if assoc.options.key? :class_name
              class_name = assoc.options[:class_name]
            elsif assoc.options.key? :source
              class_name = assoc.options[:source].to_s.camelize
            end
          end
          type_name = "[]#{class_name}"
          if col_name && type_name && (self.models.include? class_name)
            info[:struct_body] << sprintf("%s %s `%s`\n", col_name, type_name, tags.join(" "))
            info[:assoc_info][:has_many][col_name] = {class_name: class_name}
            info[:assoc_info][:has_many][col_name].merge!(assoc.options) unless assoc.options.empty?
          end

        when :has_one, :belongs_to
          col_name = class_name = assoc.name.to_s.camelize
          unless assoc.options.empty?
            if assoc.options.key? :class_name
              class_name = assoc.options[:class_name]
            elsif assoc.options.key? :source
              class_name = assoc.options[:source].to_s.camelize
            end
          end
          type_name = class_name
          if col_name && type_name && (self.models.include? class_name)
            info[:struct_body] << sprintf("%s %s `%s`\n", col_name, type_name, tags.join(" "))
            info[:assoc_info][assoc.macro][col_name] = {class_name: class_name}
            info[:assoc_info][assoc.macro][col_name].merge!(assoc.options) unless assoc.options.empty?
          end
        end
        info[:has_assoc_dependent] = true if assoc.options.key? :dependent
      end
      info
    end
  end
end
