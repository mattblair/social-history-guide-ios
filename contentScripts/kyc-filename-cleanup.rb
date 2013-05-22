# needs to:
# * remove extension
# * remove redundant periods(?)
# * replace parentheses and spaces with hyphens
# * remove apostrophes
# * convert to lowercase

def clean_audio_filename (raw_filename)
  
  if raw_filename.nil?
    return ""
  else
    # strip extension -- could be mp3, aif or wav -- or ?
    name = raw_filename.gsub(/(.aif|.wav|.mp3)/,"")
    return name.gsub(/(\(|\)| )/, "-").gsub("'", "").downcase
  end
  
end