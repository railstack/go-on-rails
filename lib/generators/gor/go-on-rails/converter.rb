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

    def initialize(klass, models)
      @klass = klass
      @models = models
    end
    attr_accessor :klass, :models

    def convert
      get_schema_info
    end

    private

    def get_schema_info
      struct_info = {col_names: [], timestamp_cols: [], has_datetime_type: false, struct_body: ""}

      validation = GoOnRails::Validator.new(self.klass)

      self.klass.columns.each_with_index do |col, index|
        tags = []

        # add struct tag
        tags << struct_tag(col, validation)

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

        struct_info[:col_names] << col.name unless col.name == "id"
        struct_info[:struct_body] << sprintf("%s %s `%s`\n", col.name.camelize, type, tags.join(" "))
      end

      assoc = get_associations
      struct_info[:struct_body] << assoc[:struct_body]
      struct_info[:assoc_info] = assoc[:assoc_info]
      struct_info[:has_assoc_dependent] = assoc[:has_assoc_dependent]
      return struct_info
    end

    def get_struct_name
      self.klass.table_name.camelize
    end

    def get_associations
      builder = GoOnRails::Association.new(self.klass, self.models)
      builder.get_schema_info
    end

    def struct_tag(col, validation)
      valid_tags = validation.build_validator_tag(col)
      "json:\"#{col.name},omitempty\" db:\"#{col.name}\" #{valid_tags}"
    end
  end
end

require_relative 'association'
require_relative 'validator'
