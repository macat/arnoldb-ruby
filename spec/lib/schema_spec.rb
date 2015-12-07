require './spec/spec_helper.rb'

describe Arnoldb::Schema do
  describe '.build' do

  end

  describe '.get_id' do

    context 'when looking for object types' do
      xit 'finds the correct id' do

      end

    end

    context 'when looking for fields' do
      xit 'finds the correct id' do

      end

    end
  end

  describe '.get_title' do
    before(:all) {
      Arnoldb::Schema.class_variable_set(:@@object_types, {})
      Arnoldb::Schema.class_variable_set(:@@object_type_ids, {})
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    after(:each) {
      Arnoldb::Schema.class_variable_set(:@@object_types, {})
      Arnoldb::Schema.class_variable_set(:@@object_type_ids, {})
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    it 'gets the title of a column' do
      Arnoldb::Schema.class_variable_set(
        :@@field_ids,
        {
          "555" => "SIGN.number",
        }
      )

      expect(Arnoldb::Schema.get_title("column", "555")).to eq("SIGN.number")
    end

    it 'gets the title of a table' do
      Arnoldb::Schema.class_variable_set(
        :@@object_type_ids,
        {
          "111" => "ADMINS",
        }
      )

      expect(Arnoldb::Schema.get_title("table", "111")).to eq("ADMINS")
    end
  end

  describe '.get_columns' do
    before(:all) {
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    after(:each) {
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    it 'finds all columns for a table' do
      Arnoldb::Schema.class_variable_set(
        :@@fields,
        {
          "GHOSTS.operation_id" => "007",
          "GHOSTS.weapon" => "008",
          "GHOSTS.kias" => "009",
          "GHOSTS.id" => "010",
        }
      )
      expected = {
        "operation_id" => "007",
        "weapon" => "008",
        "kias" => "009",
        "id" => "010",
      }

      expect(Arnoldb::Schema.get_columns("GHOSTS")).to match(expected)
    end

    it 'normalize title' do
      Arnoldb::Schema.class_variable_set(
        :@@fields,
        {
          "COUNTRY.operatives" => "080",
          "COUNTRY.lives" => "090",
          "COUNTRY.reach" => "100",
          "COUNTRY.id" => "110",
        }
      )
      expected = {
        "operatives" => "080",
        "lives" => "090",
        "reach" => "100",
        "id" => "110",
      }

      expect(Arnoldb::Schema.get_columns("CouNtry")).to match(expected)
    end
  end

  describe '.add_table' do
    before(:all) do
      Arnoldb::Schema.class_variable_set(:@@object_types, {})
      Arnoldb::Schema.class_variable_set(:@@object_type_ids, {})
    end

    after(:each) do
      Arnoldb::Schema.class_variable_set(:@@object_types, {})
      Arnoldb::Schema.class_variable_set(:@@object_type_ids, {})
    end

    it 'adds an object type' do
      Arnoldb::Schema.add_table("ARTICLES", "abc")

      expect(Arnoldb::Schema.class_variable_get(:@@object_types)).to include("ARTICLES" => "abc")
      expect(Arnoldb::Schema.class_variable_get(:@@object_type_ids)).to include("abc" => "ARTICLES")
    end

    it 'normalizes titles' do
      Arnoldb::Schema.add_table("people", "def")
      Arnoldb::Schema.add_table("OfFices_ArounD", "ghi")

      expect(Arnoldb::Schema.class_variable_get(:@@object_types)).to include("PEOPLE" => "def")
      expect(Arnoldb::Schema.class_variable_get(:@@object_type_ids)).to include("def" => "PEOPLE")
      expect(Arnoldb::Schema.class_variable_get(:@@object_types)).to include("OFFICES_AROUND" => "ghi")
      expect(Arnoldb::Schema.class_variable_get(:@@object_type_ids)).to include("ghi" => "OFFICES_AROUND")
    end
  end

  describe '.add_column' do
    before(:all) {
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    after(:each) {
      Arnoldb::Schema.class_variable_set(:@@fields, {})
      Arnoldb::Schema.class_variable_set(:@@field_ids, {})
    }

    it 'adds a field' do
      allow(Arnoldb::Schema).to receive(:get_title) { "PROFILES" }
      Arnoldb::Schema.add_column("first", "123","456")

      expect(Arnoldb::Schema.class_variable_get(:@@fields)).to include("PROFILES.first" => "123")
      expect(Arnoldb::Schema.class_variable_get(:@@field_ids)).to include("123" => "PROFILES.first")
    end

    it 'normalizes titles' do
      allow(Arnoldb::Schema).to receive(:get_title) { "PROFILES" }
      Arnoldb::Schema.add_column("laSt_namE", "789","456")
      Arnoldb::Schema.add_column("STYLE", "101112","456")
      Arnoldb::Schema.add_column("g FACTOR", "131415","456")

      expect(Arnoldb::Schema.class_variable_get(:@@fields)).to include("PROFILES.last_name" => "789")
      expect(Arnoldb::Schema.class_variable_get(:@@field_ids)).to include("789" => "PROFILES.last_name")
      expect(Arnoldb::Schema.class_variable_get(:@@fields)).to include("PROFILES.style" => "101112")
      expect(Arnoldb::Schema.class_variable_get(:@@field_ids)).to include("101112" => "PROFILES.style")
      expect(Arnoldb::Schema.class_variable_get(:@@fields)).to include("PROFILES.g factor" => "131415")
      expect(Arnoldb::Schema.class_variable_get(:@@field_ids)).to include("131415" => "PROFILES.g factor")
    end
  end
end