require 'csv'
require 'json'
require 'pathname' # is this needed?

require_relative 'kyc-filename-cleanup'

# input
input_path = "/Users/matt/Dropbox/KnowYourCityMedia/interviewLogs"
input_filename = "kycInterviewLog130521.csv"

# output
output_path = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/seedData"
output_filename = 'kyc_story_from_log130521.json' 
 
# lookup table hashes:

theme_hash = {
  "African-American" => 1,
  "Chinese History" => 2,
  "Jewish History" => 4,
  "Skid Row" => 6,
  "Women's History" => 7,
  "Lesbian History" => 9,
  "Japanese-American History" => 3,
  "Native History" => 5
} 
 
guest_hash = {
  "African-American" => 1,
  "Chinese History" => 6,
  "Jewish History" => 3,
  "Skid Row" => 2,
  "Women's History" => 4,
  "Lesbian History" => 9,
  "Japanese-American History" => 5,
  "Native History" => 5
}

# load the latest csv download
raw_story_data = CSV.read("#{input_path}/#{input_filename}")

story_array = []

raw_story_data.each do |story_row|
  
  # skip the titles and spacer rows
  if story_row[0] == "Theme" || story_row[0].nil? || story_row[0].length < 1
    next
  else
    puts "Processing #{story_row[1]}"
  
    story_dict = {}
  
    story_dict['original_audio_filename'] = story_row[1]
    
    story_dict['audio_filename'] = clean_audio_filename(story_row[1])
    
    story_dict['title'] = story_row[2] ? story_row[2] : ""
    
    story_dict['summary'] = story_row[5] ? story_row[5] : ""
    
    story_dict['display_order'] = story_row[4].to_i
    
    story_dict['theme_id'] = theme_hash[story_row[0]]
    
    story_dict['guest_id'] = guest_hash[story_row[0]]
    
    story_dict['editing_priority'] = story_row[3] ? story_row[3].to_i*10 : 50
    
    story_dict['editorial_notes'] = "#{story_row[6]}\n\nPhotos, maps, other:\n#{story_row[7]}\n\nRelated Resources:#{story_row[8]}"
    
    story_array << story_dict
    
  end
  
end


# export as json

File.open("#{output_path}/#{output_filename}", "w") do |f|
	
	f.puts JSON.pretty_generate(story_array)
	
end
