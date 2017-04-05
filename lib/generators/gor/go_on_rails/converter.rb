module GoOnRails
    class Convertor
        TYPE_MAP = {
            "string"     => "string",
            "text"       => "string",
            "boolean"    => "bool",
            "integer(1)" => "int8",
            "integer(2)" => "int16",
            "integer(3)" => "int32",
            "integer(4)" => "int64",
            "integer(8)" => "int64",
            "float"      => "float64",
            "datetime"   => "time.Time",
            "date"       => "time.Time"
        }

        def initialize(klass, models, option = {})
            @klass = klass
            @models = models
            @max_col_size = 0
            @max_type_size = 0
        end
        attr_accessor :klass, :models, :max_col_size, :max_type_size

        def convert
            get_schema_info
        end

        private

        def get_schema_info
            struct_info = {col_names: [], timestamp_cols: [], has_datetime_type: false, struct_body: ""}

            self.max_col_size = get_max_col_size
            self.max_type_size = get_max_type_size

            self.klass.columns.each_with_index do |col, index|
                tags = []

                # add struct tag
                tags << struct_tag(col)

                col_type = col.type.to_s
                struct_info[:has_datetime_type] = true if %w(datetime time).include? col_type
                if col_type == "datetime" and %w(created_at updated_at).include? col.name
                    struct_info[:timestamp_cols] << col.name
                end

                case col_type
                when "integer"
                    type = TYPE_MAP["integer(#{col.limit})"] || "int64"
                    type = "u#{type}" if col.sql_type.match("unsigned").present?
                else
                    type = TYPE_MAP[col_type] || "string"
                end

                format = (index == 0 ? "" : "\t") + "%-#{self.max_col_size}.#{self.max_col_size}s%-#{self.max_type_size}.#{self.max_type_size}s`%s`\n"
                struct_info[:col_names] << col.name unless col.name == "id"
                struct_info[:struct_body] << sprintf(format, col.name.camelize, type, tags.join(" "))
            end

            assoc = get_associations
            struct_info[:struct_body] << assoc[:struct_body]
            struct_info[:assoc_info] = assoc[:assoc_info]
            return struct_info
        end

        def get_max_col_size
            col_name_max_size = self.klass.column_names.collect{|name| name.size}.max || 0
            assoc_max_size = self.klass.reflect_on_all_associations.collect{|assoc| assoc.name.to_s.size}.max || 0
            type_max_size = TYPE_MAP.collect{|key, value| key.size}.max || 0
            [col_name_max_size + 1, assoc_max_size, type_max_size].max
        end

        def get_max_type_size
            assoc_max_size = self.klass.reflect_on_all_associations.collect{|assoc| assoc.name.to_s.size + 2}.max || 0
            type_max_size = TYPE_MAP.collect{|key, value| key.size}.max || 0
            [assoc_max_size, type_max_size].max
        end

        def get_struct_name
            self.klass.table_name.camelize
        end

        def get_associations
            builder = GoOnRails::Association.new(self.klass, self.models, self.max_col_size, self.max_type_size)
            builder.get_schema_info
        end

        def struct_tag(col)
            "json:\"#{col.name},omitempty\" db:\"#{col.name}\""
        end

    end
end

require_relative 'association'
