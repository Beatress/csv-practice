require 'csv'
require 'awesome_print'

def get_all_olympic_athletes(filename)
  athletes = []

  athlete_csv = CSV.read(filename, headers:true).map { |row| row.to_h}
  athlete_csv.each do |athlete|
    athlete.select! { | field, value | REQUIRED_OLYMPIAN_FIELDS.include?(field) }
    athletes << athlete
  end

  return athletes
end

def total_medals_per_team(olympic_data)
  medal_count = Hash.new
  country_list = []
  medalists = olympic_data.filter { |athlete|
    if athlete["Medal"] != "NA" && athlete["Medal"].strip != ""
      country_list << athlete["Team"] unless country_list.include?(athlete["Team"])
      true
    else
      false
    end
  }

  country_list.each do |country|
    country.slice!(/[^a-zA-Z\s]+/)

    count = medalists.count { |medalist| medalist["Team"].include?(country)}
    medal_count[country] = count
  end

  return medal_count
end

def get_all_gold_medalists(olympic_data)
  return olympic_data.filter { |athlete| athlete["Medal"].include?("Gold")}
end