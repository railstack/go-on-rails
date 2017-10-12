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
      "date"       => "time.Time",
      "inet"       => "string"
    }.freeze

    # COALESCE datetime typed field for different databases
    DATETIME_COALESCE_MAP = {
      "mysql" => "COALESCE(%s, CONVERT_TZ('0001-01-01 00:00:00','+00:00','UTC')) AS %s",
      "postgres" => "COALESCE(%s, (TIMESTAMP WITH TIME ZONE '0001-01-01 00:00:00+00') AT TIME ZONE 'UTC') AS %s"
    }.freeze

    # types need special treatment in the nullable_map() method
    SPECIAL_COALESCE_TYPES = %w[inet].freeze

    def initialize(klass, models, database)
      @klass = klass
      @models = models
      @database = database
    end
    attr_accessor :klass, :models, :database

    def convert
      get_schema_info
    end

    private

    def get_schema_info
      struct_info = {
        col_names: [],
        timestamp_cols: [],
        has_datetime_type: false,
        struct_body: "",
      }

      validation = GoOnRails::Validator.new(self.klass)
      # store fields by if nullable
      fields = { yes: [], no: [] }

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

        # check the fields if nullable
        if col.null == true
          if SPECIAL_COALESCE_TYPES.include?(col_type)
            fields[:yes] << [col.name, col_type]
          else
            fields[:yes] << [col.name, type]
          end
        else
          fields[:no] << col.name
        end

        struct_info[:col_names] << col.name unless col.name == "id"
        struct_info[:struct_body] << sprintf("%s %s `%s`\n", col.name.camelize, type, tags.join(" "))
      end

      assoc = get_associations
      struct_info[:struct_body] << assoc[:struct_body]
      struct_info[:assoc_info] = assoc[:assoc_info]
      struct_info[:has_assoc_dependent] = assoc[:has_assoc_dependent]
      struct_info[:select_fields] = nullable_select_str(fields)

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

    def nullable_select_str(fields)
      fields[:yes].map do |f|
        sprintf(nullable_map(f[1]), "#{self.klass.table_name}.#{f[0]}", f[0])
      end.concat(
        fields[:no].map do |f|
          sprintf("%s.%s", self.klass.table_name, f)
        end
      ).join(", ")
    end

    def nullable_map(type)
      case type
      when "string"
        "COALESCE(%s, '') AS %s"
      when "int8", "int16", "int32", "int64"
        "COALESCE(%s, 0) AS %s"
      when "float64"
        "COALESCE(%s, 0.0) AS %s"
      when "bool"
        "COALESCE(%s, FALSE) AS %s"
      when "time.Time"
        DATETIME_COALESCE_MAP[self.database]
      when "inet"
        "COALESCE(%s, '0.0.0.0') AS %s"
      else
        # here just return the column name, may skip some nullable field and cause an error in a query
        "%s"
      end
    end
  end
end

require_relative 'association'
require_relative 'validator'
