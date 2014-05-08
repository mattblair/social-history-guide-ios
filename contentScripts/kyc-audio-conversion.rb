require 'FileUtils'
require 'csv'

require_relative 'kyc-filename-cleanup'

#media_source_directory = "/Users/matt/Dropbox/kycInterviewsEdited"
# updated for the ones edited by Emily Mercer:
media_source_directory = "/Users/matt/Dropbox/PSHG-Interviews"

ios_output_directory = "/Users/matt/Documents/codeProjects/knowYourCity/knowYourCity/Resources/audio"
web_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/mp4"
preview_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/mp3"
ogg_output_directory = "/Users/matt/Dropbox/appWorkingNotes/knowYourCity/ogg"

ios_suffix = "caf"
web_suffix = "mp4"

# generate this list from the database, save as CSV, using the current 'published' id:
# select audio_filename from stories where workflow_state_id = 2
audio_file_list = "/Users/matt/Documents/codeProjects/knowYourCity/contentScripts/included-audio-files.txt"

#audio_files_for_ios = CSV.read(audio_file_list)

# themes to process:

themes_to_process = [
=begin
  { "name" => "African-American History", "prefix" => "bh", "subdirectory" => "africanAmericanHistory" },
  { "name" => "Chinese History", "prefix" => "rh", "subdirectory" => "chineseHistory" },
  { "name" => "Jewish History", "prefix" => "po", "subdirectory" => "jewishHistory" },
  { "name" => "Gay History", "prefix" => "gn", "subdirectory" => "gayHistory" },
  
  # completed as of 130625:
  { "name" => "Worker History", "prefix" => "mm", "subdirectory" => "michaelMunk" },
  { "name" => "Native Stories", "prefix" => "ee", "subdirectory" => "edEdmo" },
  
  # first batch of Ann Mussey"
  { "name" => "Lesbian History", "prefix" => "am", "subdirectory" => "lesbianHistory" },
  
  # second batch of Ann Mussey, converted on 130713:
  { "name" => "Lesbian History", "prefix" => "am", "subdirectory" => "annMussey" },
  
  # need to get original wav or aif to process these...
  # mp3 versions are already prevised
  { "name" => "Old Town", "prefix" => "dkc", "subdirectory" => "oldTown-mp3" },
  { "name" => "Women's History", "prefix" => "jd", "subdirectory" => "janDilg-mp3" }

  # yet to be completed, probably deferred until after launch:
  { "name" => "Japanese-American History", "prefix" => "hs", "subdirectory" => "HenrySakamotoErinYankeEdited" }
  #{ "name" => "Public Art", "prefix" => "cb", "subdirectory" => "caryeBye" }
  #{ "name" => "Pearl District", "prefix" => "ml", "subdirectory" => "pearlDistrictArtists" }
=end  
  { "name" => "Museums and Public Art", "prefix" => "cb", "subdirectory" => "CaryeByeEdited" },
  { "name" => "Punks History", "prefix" => "ml", "subdirectory" => "MikeLastraEdited" },
  { "name" => "Union Station", "prefix" => "sd", "subdirectory" => "SteveDottererEdited" },
  { "name" => "Old Town Plaques", "prefix" => "sh", "subdirectory" => "SuennHoEdited" }
  
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
    # prevent duplicate prefixing, since those mp3's are already prefixed
    prefix = filename.start_with?(theme['prefix']) || filename.start_with?(theme['prefix'].upcase()) ? "" : "#{theme['prefix']}-"
    new_file_name = "#{prefix}#{clean_audio_filename(filename)}"
    
    # inject theme-specific prefix, because original filenames are inconsistent
    mp3_output_file = "#{preview_output_directory}/#{new_file_name}.mp3"
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
    
    # if it's already an mp3, just copy it to the mp3 folder, without changing the filename
    if filename.end_with?(".mp3")
      `cp \"#{filename}\" "#{preview_output_directory}/#{new_file_name}.mp3"`
    else
      # Get LAME encoder via homebrew: brew install lame
      # lame --help
      # http://lame.cvs.sourceforge.net/viewvc/lame/lame/USAGE
      `lame -h \"#{filename}\" #{mp3_output_file}`
    end
  
    # or, use mp4 for the web:
    #`afconvert -v -c 1 -f mp4f -d aac -s 3 -b 128000 \"#{filename}\" #{web_output_file}`

    # convert the file for the app:
=begin
    if audio_files_for_ios.include?(["#{new_file_name}"])
      `afconvert -v -c 1 -f caff -d aac -s 3 -b 128000 \"#{filename}\" #{ios_output_file}`
    else
      puts "Will not add #{new_file_name} to iOS project because it's not published."
    end
=end
    # switched to always including this:
    `afconvert -v -c 1 -f caff -d aac -s 3 -b 128000 \"#{filename}\" #{ios_output_file}`
    
    # ogg for Firefox and Opera -- switch to overwrite what's there?
    `ffmpeg -i \"#{filename}\" -acodec libvorbis -aq 5 #{ogg_output_file}`
    
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

