artist = ARGV[0]
file = ARGV[1]
lines = File.read(file).split("\n")
i = 1
lines.each do |line|
  name = File.basename line
  ext = File.extname line
  puts "getting #{line} as #{name}..."
  `wget #{line} 2>&1`
  puts "  => mv #{name} to #{artist}#{i}#{ext}"
  `mv #{name} images/#{artist}#{i}#{ext} 2>&1`
  i += 1
end

