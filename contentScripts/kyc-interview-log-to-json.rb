require 'csv'
require 'json'
require 'pathname' # is this needed?

require_relative 'kyc-filename-cleanup'

# input
input_path = "/Users/matt/Dropbox/KnowYourCityMedia/interviewLogs"
input_filename = "kycInterviewLog130617.csv"

# output
output_path = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/seedData"
output_filename = 'kyc_story_from_log130624.json' 
 
# lookup table hashes:

theme_hash = {
  "African-American" => 1,
  "Chinese History" => 2,
  "Jewish History" => 4,
  "Old Town" => 6,
  "Women's History" => 7,
  "Lesbian History" => 9,
  "Japanese-American History" => 3,
  "Native Stories" => 5,
  "Gay History" => 8
}

prefix_hash = {
  "African-American" => "bh",
  "Chinese History" => "rh",
  "Jewish History" => "po",
  "Old Town" => "dkc",
  "Women's History" => "jd",
  "Lesbian History" => "am",
  "Japanese-American History" => "hs",
  "Native Stories" => "ee",
  "Gay History" => "gn",
  "Workers' History" => "mm"
} 

guest_hash = {
  "African-American" => 1,
  "Chinese History" => 6,
  "Jewish History" => 3,
  "Old Town" => 2,
  "Women's History" => 4,
  "Lesbian History" => 10,
  "Japanese-American History" => 5,
  "Native Stories" => 7,
  "Gay History" => 8,
  "Workers' History" => 9
}

# load the latest csv download
raw_story_data = CSV.read("#{input_path}/#{input_filename}")

story_array = []

raw_story_data.each do |story_row|
  
  # skip the titles and spacer rows
  if story_row[0] == "Theme" || story_row[0].nil? || story_row[0].length < 1
    next
  else
    puts "Processing #{story_row[2]}"
  
    story_dict = {}
  
    story_dict['original_audio_filename'] = story_row[2]
    
    # inject guest prefix -- it's not in the spreadsheet
    story_dict['audio_filename'] = "#{prefix_hash[story_row[0]]}-#{clean_audio_filename(story_row[2])}"
    
    # to include a placeholder for each, even if it's not logged yet:
    story_dict['title'] = story_row[3] ? story_row[3].strip : story_dict['audio_filename']
    # to only include those with a title specified:
    #story_dict['title'] = story_row[3] ? story_row[3] : ""
    
    story_dict['subtitle'] = story_row[4] ? story_row[4].strip : ""
    
    story_dict['summary'] = story_row[7] ? story_row[7].strip : ""
    
    story_dict['display_order'] = story_row[6].to_i*10
    
    story_dict['theme_id'] = theme_hash[story_row[0]]
    
    story_dict['guest_id'] = guest_hash[story_row[0]]
    
    story_dict['editing_priority'] = story_row[5] ? story_row[5].to_i*10 : 50
    
    #story_dict['editorial_notes'] = "#{story_row[8]}\n\nPhotos, maps, other:\n#{story_row[9]}\n\nRelated Resources:#{story_row[10]}"
    story_dict['editorial_notes'] = "#{story_row[8]}"
    story_dict['photo_notes'] = "#{story_row[9].strip}"
    story_dict['more_info_notes'] = "#{story_row[10].strip}"
    
    story_array << story_dict
    
  end
  
end


# export as json

File.open("#{output_path}/#{output_filename}", "w") do |f|
	
	f.puts JSON.pretty_generate(story_array)
	
end
