require 'FileUtils'

require_relative 'kyc-filename-cleanup'

media_source_directory = "/Users/matt/Dropbox/kycInterviewsEdited"

ios_output_directory = "/Users/matt/Documents/codeProjects/knowYourCity/knowYourCity/Resources/audio"
web_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/mp4"
preview_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/mp3"
ogg_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/ogg"

ios_suffix = "caf"
web_suffix = "mp4"

# themes to process:

themes_to_process = [

  { "name" => "African-American History", "prefix" => "bh", "subdirectory" => "africanAmericanHistory" },
  { "name" => "Chinese History", "prefix" => "rh", "subdirectory" => "chineseHistory" },
  { "name" => "Jewish History", "prefix" => "po", "subdirectory" => "jewishHistory" },
  { "name" => "Gay History", "prefix" => "gn", "subdirectory" => "gayHistory" },
  
  # completed as of 130625:
  { "name" => "Worker History", "prefix" => "mm", "subdirectory" => "michaelMunk" },
  { "name" => "Native Stories", "prefix" => "ee", "subdirectory" => "edEdmo" },
  
  # second batch of Ann Mussey, converted on 130713:
  { "name" => "Lesbian History", "prefix" => "am", "subdirectory" => "annMussey" },
  
  # need to get original wav or aif to process these...
  #{ "name" => "Old Town", "prefix" => "dkc", "subdirectory" => "skidRow" },
  #{ "name" => "Women's History", "prefix" => "jd", "subdirectory" => "womensHistory" },
  
  # yet to be completed, probably deferred until after launch:
  #{ "name" => "Japanese-American History", "prefix" => "hs", "subdirectory" => "japaneseAmericanHistory" },
  #{ "name" => "Public Art", "prefix" => "cb", "subdirectory" => "caryeBye" }
  #{ "name" => "Pearl District", "prefix" => "ml", "subdirectory" => "pearlDistrictArtists" }
  ]
  

# add generated name as key, original name as value
# used for matching database records when audio gets updated  
$soundfile_map = {}

$processed_files = []

themes_to_process.each do |theme|
  
  puts "Processing #{theme['name']}..."
  
  Dir.chdir("#{media_source_directory}/#{theme['subdirectory']}")
  
  # for now, loop through all the files in the dir
  Dir.glob("*.{wav,aif,mp3}") do |filename|
  
    # clean up the name, prepend the prefix -- and add an id number?
    new_file_name = "#{theme['prefix']}-#{clean_audio_filename(filename)}"
  
    # inject theme-specific prefix, because original filenames are inconsistent
    preview_output_file = "#{preview_output_directory}/#{new_file_name}.mp3"
    web_output_file = "#{web_output_directory}/#{new_file_name}.#{web_suffix}"
    ios_output_file = "#{ios_output_directory}/#{new_file_name}.#{ios_suffix}"
    ogg_output_file = "#{ogg_output_directory}/#{new_file_name}.ogg"
    
    #puts "Will write to #{output_file}..."
  
    # convert the file for web:
    # c = number of channels
    # d = data format
    # f = format: caff | MPG3 | mp4f
    # afconvert -hf for format details
  
    # mp3 conversion not supported without a 3rd party encoder
    # `afconvert -v -c 1 -f MPG3 -d mp3 -s 3 -b 128000 #{filename} #{output_file}`
    
    # Get LAME encoder via homebrew: brew install lame
    # lame --help
    # http://lame.cvs.sourceforge.net/viewvc/lame/lame/USAGE
    `lame -h \"#{filename}\" #{preview_output_file}`
  
    # mp4 for the web:
    #{}`afconvert -v -c 1 -f mp4f -d aac -s 3 -b 128000 \"#{filename}\" #{web_output_file}`
  
    # convert the file for the app:
    # `afconvert -v -c 1 -f caff -d aac -s 3 -b 128000 \"#{filename}\" #{ios_output_file}`
    
    # ogg for Firefox and Opera
    
    # add an object to the output list, with id, original name, new filenames?
    $processed_files << new_file_name
  
  end
  
end

$processed_files.each do |file|
  puts "Created #{file}"
end

# save soundfile_map

# updated database directly? Or output json for seeds.rb?

# save list of processed files to log

