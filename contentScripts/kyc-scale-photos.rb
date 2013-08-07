# Easiest on OSX 10.8: install imagemagick via homebrew, then the RMagick gem
# The steps:
# brew update
# brew install imagemagick --disable-openmp --build-from-source
# gem install rmagick

require 'rubygems'
require 'RMagick'
require 'FileUtils'

photo_source_directory = "#{ENV['HOME']}/Dropbox/kycInterviewsEdited/croppedPhotos"
ios_output_directory = "#{ENV['HOME']}/Documents/codeProjects/knowYourCity/knowYourCity/Resources/photos"
web_output_directory = "#{ENV['HOME']}/Dropbox/appWorkingNotes/knowYourCity/webPhotos"

# FUTURE: iterate through a list of required photos, and note missings ones

# read the slideshow json file, and look for those photos

# get a list of photos from the database

# for each, look for them in the source directory

# if found, generate all required sizes

# else display an error



# NOW: Until photo selections stabilize, just iterate the source folder:

Dir.chdir(photo_source_directory)

# for now, loop through all the files in the dir
# or match "*.{jpg,jpeg,png}" ? 
Dir.glob("*.jpg") do |filename|
  
  # RMagick docs:
  # http://www.imagemagick.org/RMagick/doc/comtasks.html
  
  #<image>-original.jpg [max possible 4:3 edit]
  # read the image
   image = Magick::Image.read(filename).first
   
   # remove -original?
   filename = image.filename.gsub(/(.jpg|.jpeg|.png)/,"") # match input formats?
   
   # scale the images
   puts "Resizing #{filename}"
   
   # temp: web max size of 600 x variable height?
   web_image = image.resize_to_fit(600) # height is optional?
   web_image.write("#{web_output_directory}/#{filename}.jpg")
   
   # or a smaller web version? depends on layout decisions, available photos
   #<image>.jpg [320 width, same as iOS non-retina]
   
   # throttle, if desired
   sleep(1)
  
  # iOS images
  
  #<image>@2x.png [640 width for iOS Retina]
  #<image>.png [320 width for iOS non-retina]
  
  
  #<image>-tn.jpg [120 width, web thumbnail] -- or 240 width?
  web_thumb = image.resize_to_fit(120) # height is optional?
  web_thumb.write("#{web_output_directory}/#{filename}-tn.jpg")
  
  # throttle, if desired
   sleep(1)
  
end


# rsync web photos to the static server?