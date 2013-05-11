if ARGV.size != 1
  puts "usage: ruby ask_me.rb questions.conf"
  exit
end

questions_file = ARGV[0]
question_answer = {}
answer_block_start = "{{"
answer_block_end = "}}"

# check if questions_file is a file
if !FileTest.file?(questions_file)
  puts "!!! questions file is no file: #{questions_file}"
  exit
end

question = ""
block_found_start = false
block_found_end = false
answer = []

File.open(questions_file, "r").each do |line|
  puts line
  if line.match(/^q:(.*)/)
    question = $1
    puts "question found"
  end
  if line.match(/^a:(.*)/)
    temp_answer = $1
    if $1.match(/.*#{answer_block_start}(.*)/)
      puts "start found"
      block_found_start = true
      answer << $1
    end
    if (question.size > 0)
      if (!block_found_start)
        puts "store single answer"
        question_answer.store(question, temp_answer);
        question = ""
      end
    end
  else
    if line.match(/(.*)#{answer_block_end}/)
      puts "end found"
      block_found_end = true
      answer << $1
    end
    if block_found_start && !block_found_end
      puts "store block line"
      answer << line
    end
    if (block_found_start && block_found_end)
      puts "store block"
      question_answer.store(question, answer);
      question = ""
      block_found_start = false
      block_found_end = false
      answer = []
    end
  end
end

key_pressed = gets

question_answer.each do |key,value|
  puts "--- question ---"
  puts "#{key}"
  puts "----------------"
  puts "--- answer ---"
  if value.kind_of?(Array)
    value.each do |line|
      puts line
    end
  else
    puts "#{value}"
  end
  puts "--------------"
end