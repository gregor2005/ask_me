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

File.open(questions_file, "r").each do |line|
  if line.match(/^q:(.*)/)
    question = $1
  end
  if line.match(/^a:(.*)/)
    if (question.size > 0)
      question_answer.store(question, $1);
    end
    question = ""
  end
end

key_pressed = gets

question_answer.each do |key,value|
  puts "--- question ---"
  puts "#{key}"
  puts "----------------"
  puts "--- answer ---"
  puts "#{value}"
  puts "--------------"
end