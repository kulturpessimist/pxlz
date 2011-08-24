#!/usr/bin/env ruby

require 'rubygems'
require 'chunky_png'
require 'yaml'
require 'erb'

#if !ARGV[0]
#    puts "Usage: pxlz.rb path-to-image"
#    exit
#end

# constants
per_row = per_column = per_side = 16
dimensions = { :width => 1000, :height => 800 }
tmpl = ERB.new DATA.read
image = ChunkyPNG::Image.from_file 'the-great-war-1964.png'#('Son-of-Man.png')
# pixelate… should be optional
image_dimensions = {  :width => image.width, :height => image.height  }
image.resample_nearest_neighbor!(per_side, per_side)
image.resample_nearest_neighbor!(image_dimensions[:width], image_dimensions[:height])
# variables
pixel_size = {
	:width => image.width / per_row +1,
	:height => image.height / per_column +1
}

# create output folder
unless File.directory?("pixelz")
	Dir.mkdir("pixelz")
end

# make pictures…
i = 0
per_column.times do | y |
	per_row.times do | x |
		p "#{x*pixel_size[:width]} / #{y*pixel_size[:height]}"
		png = ChunkyPNG::Image.new( dimensions[:width], dimensions[:height], image[ x*pixel_size[:width], y*pixel_size[:height] ])
		png.save("pixelz/#{i}.png", :fast_rgba)
		i+=1
		
	end
end

File.open("pixelz/index.html", 'w') {|f| 
	f.write(tmpl.result) 
}

__END__

<html>
	<head>
		<title>pixelz overview…</title>
		<style type="text/css">
			html,body{ width:100%; height:100%; background-color: #fff;}
			img{ border: none; margin:0;padding:0; }
		</style>
	</head>
	<body>
		
		<% (per_row*per_column).times do | i | %>
			<img src="<%=i%>.png" width="<%=dimensions[:width]/25%>" height="<%=dimensions[:height]/25%>" />
			<% if i%per_side==per_side-1 %>
				<br/>
			<% end %>
		<% end %>

	</body>
</html>
