require 'io/console'

# TODO build in that pictures can be used in the answer
# TODO handle whitespaces in picture path
# TODO mix questions when asked 

if ARGV.size != 1
  puts "usage: ruby ask_me.rb questions.conf"
  exit
end

questions_file = ARGV[0]
question_answer = {}
answer_block_start = "{{"
answer_block_end = "}}"
key_end = "q"
image_viewer = "/usr/bin/eog"

# check if questions_file is a file
if !FileTest.file?(questions_file)
  puts "!!! questions file is no file: #{questions_file}"
  exit
end

# check if image viewer is available
if !FileTest.file?(image_viewer)
  puts "!!! image viewer are no file: #{image_viewer}"
  exit
end

question = ""
block_found_start = false
block_found_end = false
answer = []
image_stored = false

File.open(questions_file, "r").each do |line|
  if line.match(/^q:(.*)/)
    question = $1
  end
  if line.match(/^a:(.*)/)
    temp_answer = $1
    if $1.match(/.*#{answer_block_start}(.*)/)
      block_found_start = true
      answer << $1
    end
    if (question.size > 0)
      if (!block_found_start)
        if image_stored
          answer << temp_answer
          question_answer.store(question, answer);
        else
          question_answer.store(question, temp_answer);
        end
        question = ""
        answer = []
      end
    end
  else
    if line.match(/^i:(.*)/)
      image_stored = true
      puts "image stored"
      answer << line
    end
    if line.match(/(.*)#{answer_block_end}/)
      block_found_end = true
      answer << $1
    end
    if block_found_start && !block_found_end
      answer << line
    end
    if (block_found_start && block_found_end)
      question_answer.store(question, answer);
      question = ""
      block_found_start = false
      block_found_end = false
      answer = []
    end
  end
end

question_answer.each do |key,value|
  puts "--- question ---"
  puts "#{key}"
  if value.kind_of?(Array)
    if (value.size > 0)
      if (value[0].match(/^i:(.*)/))
        puts "image found: #{$1}"
#        Thread.new do
          system("#{image_viewer} #{$1} &")
#        end
      end
    end
  end
  puts "----------------"
  key_pressed = STDIN.getch
  if (key_pressed == key_end)
    puts "closeing the application"
    exit
  end
  puts "--- answer ---"
  if value.kind_of?(Array)
    value.each do |line|
      if ! line.match(/^i:.*/)
        puts line
      end
    end
  else
    puts "#{value}"
  end
  puts "--------------"
  puts
  puts
  puts
end