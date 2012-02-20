# GFM-Service

My first Ruby project -- pull requests, general feedback, and 
"WHY DID YOU DO IT THAT WAY" welcome.  =)

## Description

GitHub Flavored Markdown Service is a webservice to interface the 
redcarpet and albino libraries written by GitHub.  Its primary
use case is for using GFM in applications that are written in
languages other than Ruby.

## Installing

You must install the following gems:

* rack
* albino
* redcarpet
* json

Additionally, you must install pygments if you wish to use the
syntax hilighting features.

## Usage

GFM-Service is JSON based and supports the following keys:

* document
* no_intra_emphasis 
* tables
* fenced_code_blocks
* autolink
* strikethrough
* lax_html_blocks
* space_after_headers
* superscript

Document is the only required key, and should point to the document
you want processed.  All the other keys will enable the given feature
for the document to be processed with.

## Example

Default markup

    curl -d'{ "document" : "# Hello World" }' http://myserver.com:5000/
    {
      "document" : "# Hello World"
      "status" : "1"
    }

With fenced_code_blocks

    curl -d'{"document":"```ruby\nputs \"Hello World\"\n```","fenced_code_blocks":1}' \
        http://myserver.com:5000/
    {
        "document" : "
            <div class=\"highlight\">
                <pre>
                    <span class=\"nb\">puts</span> 
                    <span class=\"s2\">&quot;Hello World&quot;</span>\n
                </pre>\n
            </div>\n",
        "status" : "1"
    }

### AUTHOR

SymKat <symkat@symkat.com> ([Blog](http://symkat.com/))

### CONTRIBUTORS

### LICENSE

This is free software and may be distributed under the same terms as perl itself.

### COPYRIGHT

Copyright (c) 2012 the DFM-Service "AUTHOR" and "CONTRIBUTORS" as listed above.

### AVAILABILITY

The most current version of DFM-Service can be found at https://github.com/symkat/GFM-Service
