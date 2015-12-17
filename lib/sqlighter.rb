require "sqlighter/version"
require 'sqlite3'

class Sqlighter

  def initialize db_name
    @db_name = "#{@db_name}.db"
    @db = SQLite3::Database.new @db_name
    @logs = []
    @schema = {}   
  end

  def destroy
    if File.exist?(@db_name)
      File.delete(@db_name)
      return true
    end
    return false
  end

  def get_tables
    tables = @db.execute <<-SQL
      SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;
    SQL
    return tables
  end

  def get_table table
    fields_raw = @db.execute <<-SQL
      PRAGMA table_info(#{table})
    SQL

    fields = {}
    fields_raw.each do |field|
      fields[field[1].to_sym] = [ field[2] ]
    end
    @schema[table.to_sym] = fields  
    return fields
  end

  def create_table table_name
    unless @schema[table_name.to_sym]
      @db.execute <<-SQL
        CREATE TABLE #{table_name}(
          id INTEGER PRIMARY KEY AUTOINCREMENT
        );
      SQL
      @schema[table_name.to_sym] = {}
      @logs << "CREATE TABLE #{table_name}"
    end
  end

  def delete_table table_name
    @db.execute <<-SQL
      DROP TABLE #{table_name.to_s};
    SQL
    @schema.delete(table_name.to_sym)
    @logs << "DELETED TABLE #{table_name}"
  end

  def create_field table_name, field_name, field_info
    @db.execute <<-SQL
      ALTER TABLE '#{table_name}' ADD COLUMN #{field_name} #{field_info[0]};
    SQL
    @schema[table_name.to_sym][field_name.to_sym] = field_info
    @logs << "CREATE ROW #{field_name} WITH #{field_info} FOR TABLE #{table_name}"
  end

  def remove_field table_name, field_name
    @db.execute <<-SQL
      ALTER TABLE '#{table_name}' DROP COLUMN #{field_name};
    SQL
    @logs << "DELETED ROW #{field_name} FOR TABLE #{table_name}"
  end

  def sync_field table_name, field_name, field_info
    @logs << "CHANGED ROW #{field_name} FOR TABLE #{table_name}"
  end

  def sync_field table_name, field_name, field_info
    unless @schema[table_name.to_sym][field_name.to_sym]
      create_field table_name, field_name, field_info
    else
      unless @schema[table_name.to_sym][field_name.to_sym][0] == field_info[0]
        # change field
      end
    end
  end

  def get_schema
    get_tables.each do |table|
      # exclude system tables
      if table.first != "sqlite_sequence"
        get_table(table.first)
      end
    end
    return @schema
  end

  def schema new_schema = false
    get_schema if @schema.empty?
    
    return @schema unless new_schema

    # create new
    new_schema.each do |table_name, table_info|
      create_table table_name
      if table_info
        old_fields = @schema[table_name.to_sym].keys - new_schema[table_name.to_sym].keys
        
        old_fields.each do |field|
          if field != :id
            remove_field table_name, field.to_s
          end
        end

        table_info.each do |field_name, field_info|
          sync_field table_name, field_name, field_info
        end
      end
    end

    # delete old cols
    if new_schema.keys != @schema.keys
       old_tables = @schema.keys - new_schema.keys
       old_tables.each do |table|
         delete_table table
       end
    end

    return @schema
  end

  def get_logs
    @logs
  end

end