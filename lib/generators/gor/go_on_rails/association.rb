module GoOnRails
    class Association
        def initialize(klass, models, max_col_size, max_type_size)
            @klass = klass
            @models = models
            @max_col_size = max_col_size
            @max_type_size = max_type_size
        end
        attr_reader :klass, :models, :max_col_size, :max_type_size

        def get_schema_info
            info = {struct_body: "", assoc_info: {has_many: {}, has_one: {}, belongs_to: {}}}
            self.klass.reflect_on_all_associations.each do |assoc|
                tags = ["json:\"#{assoc.name.to_s}\" db:\"#{assoc.name.to_s}\""]
                case assoc.macro
                when :has_many
                    col_name = assoc.name.to_s.camelize
                    class_name = assoc.name.to_s.singularize.camelize
                    unless assoc.options.empty?
                        class_name = assoc.options[:class_name] if assoc.options.key? :class_name
                    end
                    type_name = "[]#{class_name}"
                    info[:assoc_info][:has_many][col_name] = {class_name: class_name}
                    info[:assoc_info][:has_many][col_name].merge!(assoc.options) unless assoc.options.empty?

                when :has_one, :belongs_to
                    col_name = class_name = assoc.name.to_s.camelize
                    class_name = assoc.options[:class_name] if assoc.options.key? :class_name unless assoc.options.empty?
                    type_name = class_name
                    info[:assoc_info][assoc.macro][col_name] = {class_name: class_name}
                    info[:assoc_info][assoc.macro][col_name].merge!(assoc.options) unless assoc.options.empty?
                end
                if col_name && type_name && (self.models.include? class_name)
                    format = "\t%-#{max_col_size}.#{max_col_size+2}s%-#{max_type_size}.#{max_type_size}s`%s`\n"
                    info[:struct_body] << sprintf(format, col_name, type_name, tags.join(" "))
                end
            end
            info
        end
    end
end
