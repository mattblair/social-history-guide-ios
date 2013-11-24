# PDX Social History App

![The app's story view](https://s3-us-west-2.amazonaws.com/pdxshg.media/promo/psha-promo-story-view-300.png "Story View")

The PDX Social History App is an iOS app featuring location-based stories reflecting the multicultural history of downtown Portland, OR, USA. The app brings these stories to the surface through interviews, mapping, art and photos. Each story features a summary, audio clip, and an image or map.

To see the project in action:
* [Website](http://pdxsocialhistoryguide.org "PDX Social History Guide")
* [On the App Store](https://itunes.apple.com/us/app/pdx-social-history-guide/id737566738?ls=1&mt=8 "PDX Social History App")

My goal is for this platform (the app and the site) to be reusable in whole, or at least in parts, in other communities and locations who want to gather and share their stories. 

To achieve this, a lot of the Portland-specific elements need to be factored out into JSON files, the database, etc. Admittedly, I took a few shortcuts just so we could get this project launched without over-optimizing for imagined contingencies. Generalizing the codebases will be a non-trivial amount of work, but I've made decisions along the way with that in mind. Suggestions are welcome.

## Related Project

This is the app version of the [PDX Social History Guide](http://pdxsocialhistoryguide.org "PDX Social History Guide") website. The source for that site is available [here](https://github.com/mattblair/social-history-guide-rails).

## Known Issues

* There may be some problems building a fresh clone of the repo. The main one relates to the private constants: If you change the name of KYCPrivateConstants-example.m to KYCPrivateConstants.m, you should be okay. If you run into other problems, contact me or create an issue and I'll work on it.
* The name of the project changed mid-way through (as the Dill Pickle Club took on the name Know Your City) and the new name of the project wasn't finalized until late in the development cycle. The name needs to be updated throughout the project files and directory structure. This is why some classes use the prefix KYC and later classes use SHG. This will be normalized over time.

## Credits

See the [full list of credits](http://pdxsocialhistory.org/credits "PDX Social History Credits") on the project's website.

## Software License

The MIT License (MIT)

Copyright (c) 2013 Elsewise LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Content License

I've included some of the media files in the repo for convenience, so the project will build with less hassle, but these media files are *not* available under the MIT License.

Specifically:

* Hand-drawn icons and illustrations are copyright [Kate Bingaman-Burt](http://katebingamanburt.com/)
* Audio files are copyright Know Your City, with permission of the interviewees
* Photos owned by third-parties which have been licensed for use by Know Your City

If you have questions, please contact us.