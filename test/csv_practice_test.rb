# csv_practice_test.rb

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/pride'
require "minitest/skip_dsl"
require 'pry'

require_relative '../lib/csv_practice'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

REQUIRED_OLYMPIAN_FIELDS = %w[ID Name Height Team Year City Sport Event Medal]
MEDAL_TOTALS_FILENAME = 'data/medal_totals.csv'
OLYMPIC_DATA_FILENAME = 'data/athlete_events.csv'

describe "CSV and Enumerables Exercise" do

  describe 'get_all_olympic_athletes' do
    it 'returns an array of Olympic athletes hashes with the correct information' do
      # Arrange: Nothing to arrange
      #   besides the OLYMPIC_DATA_FILENAME constant variable above

      # Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert:
      # Check that we get back an array
      expect(olympic_athletes).must_be_instance_of Array

      olympic_athletes.each do |athlete|
        # Check that each element in the array is a hash
        expect(athlete).must_be_instance_of Hash

        # Check that each Olympian hash has the necessary keys
        #   (defined in the constant REQUIRED_OLYMPIAN_FIELDS above)
        expect(athlete.keys.length).must_equal REQUIRED_OLYMPIAN_FIELDS.length
        REQUIRED_OLYMPIAN_FIELDS.each do |required_field|
          expect(athlete.keys).must_include required_field
        end
      end
    end

    it 'has the proper number of rows' do
      # Arrange & Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert
      expect(olympic_athletes.length).must_equal 49503
    end

    it 'has the right 1st and last row' do
      # Arrange & Act
      olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Assert
      expect(olympic_athletes.first['ID']).must_equal '21'
      expect(olympic_athletes.first['Name']).must_equal 'Ragnhild Margrethe Aamodt'
      expect(olympic_athletes.first['Team']).must_equal 'Norway'
      expect(olympic_athletes.last['ID']).must_equal '135568'
      expect(olympic_athletes.last['Name']).must_equal 'Olga Igorevna Zyuzkova'
      expect(olympic_athletes.last['Team']).must_equal 'Belarus'
    end
  end

  describe 'total_medals_per_team' do

    it 'should return a hash of accurate team and count' do
      # Arrange
      # Changed expected_totals to account for consolidated team names "China-1, China-2 becomes China, for ex.
      # Data verified with spreadsheet tool
      expected_totals = {
        'Norway' => 133,
        'United States' => 990,
        'Canada' => 335,
        'Russia' => 490,
        'China' => 453,
        'Bahrain' => 3,
        'Jamaica' => 69,
        'United Arab Emirates' => 1
      }
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      total_medals = total_medals_per_team(data)

      # Assert
      expect(total_medals).must_be_instance_of Hash
      expected_totals.each do |expected_team, expected_count|
        expect(total_medals[expected_team]).must_equal expected_count
      end
    end
  end

  describe 'get_all_gold_medalists' do
    
    it 'returns an array of gold medalists' do
      # Arrange
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      all_gold_medalists = get_all_gold_medalists(data)

      # Assert
      expect(all_gold_medalists).must_be_instance_of Array
      all_gold_medalists.each do |medalist|
        expect(medalist).must_be_instance_of Hash
        expect(medalist['Medal']).must_equal "Gold"
      end
    end

    it 'has the correct number of gold medalists' do
      # Arrange
      data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)

      # Act
      all_gold_medalists = get_all_gold_medalists(data)

      # Assert
      expect(all_gold_medalists.length).must_equal 2344
    end
  end

end
