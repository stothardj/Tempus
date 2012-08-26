#!/usr/bin/env ruby

# Since most of the code is shared between pages, generate it

script_location = File.dirname(__FILE__)

html_part_dir="#{script_location}/../htmlparts"
www_dir = "#{script_location}/../www"

Dir.foreach("#{html_part_dir}") {|fname|
  if fname != "." and fname != ".."
    puts "Using #{fname}"
    htmlpart = File.read("#{html_part_dir}/#{fname}")
    output = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"utf-8\">
    <title>Tempus</title>
    <link type=\"text/css\" rel=\"stylesheet\" href=\"reset.css\" />
    <link type=\"text/css\" rel=\"stylesheet\" href=\"main.css\" />
    <script src=\"js/jquery-1.7.2.min.js\"></script>
    <script src=\"js/initui.js\"></script>
  </head>
  <body>
    <div id=\"wrapper\">
      <div id=\"header\">
	<div id=\"banner\">
	  <h1>Tempus</h1>
	</div>
	<div id=\"toplinks\">
	  <span class=\"toplink\"><a href=\"index.html\">Game</a></span>
	  <span class=\"toplink\"><a href=\"instructions.html\">Instructions</a></span>
	  <span class=\"toplink\"><a href=\"code.html\">Code</a></span>
	  <span class=\"toplink\"><a href=\"thanks.html\">Thanks</a></span>
	  <span class=\"toplink\"><a href=\"license.html\">License</a></span>
	</div>
      </div>
      <div id=\"content\">
#{htmlpart}
      </div>
    </div>
  </body>
</html>
"""
    out_fname = "#{www_dir}/#{fname[0..-6]}"
    File.open(out_fname, 'w') {|f| f.write(output) }
  end
}

puts "Completed"
