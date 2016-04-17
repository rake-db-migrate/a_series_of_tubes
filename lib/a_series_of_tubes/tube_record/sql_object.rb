require 'byebug'

module ASeriesOfTubes
  module TubeRecord
    class SQLObject
      def self.columns
        @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
          SELECT
            *
          FROM
            #{self.table_name}
        SQL
      end

      def self.finalize!
        self.columns.each do |column|
          define_method(column) { self.attributes[column] }
          define_method("#{column}=") { |value| self.attributes[column] = value }
        end
      end

      def self.table_name
        @table_name ||= self.to_s.tableize
      end

      def self.table_name=(table_name)
        @table_name = table_name
      end

      def attributes
        @attributes ||= {}
      end

      def attribute_values
        @attributes.keys.map { |k| @attributes[k] }
      end
    end
  end
end
