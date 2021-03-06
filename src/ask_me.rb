require 'io/console'

# TODO handle whitespaces in picture path
# TODO add a way to print out the question and answers so you can learn it in the train on the way to the exam

if ARGV.size != 1
  puts "usage: ruby ask_me.rb questions.conf"
  exit
end

questions_file = ARGV[0]
question_answer = {}
answer_block_start = "{{"
answer_block_end = "}}"
key_end = "q"
@image_viewer = "/usr/bin/eog"

# check if questions_file is a file
if !FileTest.file?(questions_file)
  puts "!!! questions file is no file: #{questions_file}"
  exit
end

# check if image viewer is available
if !FileTest.file?(@image_viewer)
  puts "!!! image viewer are no file: #{@image_viewer}"
  exit
end

def open_image image
  system("#{@image_viewer} #{image} &")
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
    if line.match(/^i:(.*)/) && !block_found_start
      image_stored = true
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

# shuffle questions
question_answer = Hash[question_answer.to_a.sample(question_answer.length)]

question_answer.each do |key,value|
  puts "--- question ---"
  puts "#{key}"
  if value.kind_of?(Array)
    if (value.size > 0)
      if (value[0].match(/^i:(.*)/))
        open_image $1
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
      if line.match(/^\s*i:(.*)/)
        puts "image will be pop up: #{$1}"
        open_image $1
      else
        puts line
      end
    end
  else
    puts "found only one line"
    if value.match(/^\s*i:(.*)/)
      puts "image will be pop up: #{$1}"
      open_image $1
    else
      puts "#{value}"
    end
  end
  puts "--------------"
  puts
  puts
  puts
end