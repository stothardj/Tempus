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
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <title>Tempus</title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <meta name=\"description\" content=\"Tempus is a space shooter written in coffeescript using an html5 canvas\">
    <meta name=\"author\" content=\"Jake Stothard\">
    <link href=\"bootstrap/css/bootstrap.min.css\" rel=\"stylesheet\">
    <style>
      body {
      padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <script src=\"js/jquery-1.7.2.min.js\"></script>
    <script src=\"js/initui.js\"></script>
  </head>
  <body>

    <div class=\"navbar navbar-inverse navbar-fixed-top\">
      <div class=\"navbar-inner\">
        <div class=\"container\">

	  <a class=\"brand\" href=\"index.html\">Tempus</a>
	  <div class=\"nav-collapse collapse\">
            <ul class=\"nav\"> 
	      <li class=\"active\"><a href=\"index.html\">Game</a></li>
	      <li><a href=\"instructions.html\">Instructions</a></li>
	      <li><a href=\"code.html\">Code</a></li>
	      <li><a href=\"thanks.html\">Thanks</a></li>
	      <li><a href=\"license.html\">License</a></li>
	    </ul>
	  </div>
	</div>
      </div>
    </div>

    <div class=\"container\">
#{htmlpart}
    </div>

    <script src=\"js/bootstrap.min.js\"></script>
  </body>
</html>
"""
    out_fname = "#{www_dir}/#{fname[0..-6]}"
    File.open(out_fname, 'w') {|f| f.write(output) }
  end
}

puts "Completed"
