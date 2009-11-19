= oembedder

* http://github.com/benaskins/oembedder

== DESCRIPTION:

A ruby library that will query an oembed provider and construct a response that contains an embeddable html string and a url to a thumbnail image.

== FEATURES/PROBLEMS:

* No exception handling
* Specs are very light on

== SYNOPSIS:

response = Oembed.request("http://www.youtube.com/watch?v=RF8lcGoS9Yc")

response.html           #=> "<embed src='http://www.youtube.com/v/RF8lcGoS9Yc?f=videos&app=youtube_gdata&fs=1' allowfullscreen='true' type='application/x-shockwave-flash' wmode='transparent' width='425' height='344'></embed>"
response.thumbnail_url  #=> "http://i.ytimg.com/vi/RF8lcGoS9Yc/1.jpg"

== REQUIREMENTS:

TBA

== INSTALL:

gem install oembedder

== LICENSE:

(The MIT License)

Copyright (c) 2009 Ben Askins

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Portions Copyright (c) 2009 Ben McRedmond

Licensed under the MIT license