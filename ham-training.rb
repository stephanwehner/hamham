# Author: Stephan Wehner
#
# A very simple script to help with preparing for the Canadian Amateur radio operator certificate
#
# Steps:
#
# * Keep going through the questions either on the website, or with an app.
# * Note the code of any "difficult" question in a file
# * Use this script to train these difficult questions
# 
# Details:
#
# Download the questions from http://www.ic.gc.ca/eic/site/025.nsf/eng/h_00004.html, for example
# Amateur basic questions (delimited TXT format) or Amateur advanced questions (delimited TXT format)
#
# Save in file amat_basic_quest_delim.txt
#
# Compile question codes in a second file, the training file, for example
#
# Sample contents of difficult.txt
# B-003-001-005
# B-001-002-003
# B-007-014-005
# 
# Invoke: ruby ham-training.rb amat_basic_quest_delim.txt difficult.txt
#
# Then this script will display question by question, together with the answers in random order.
# It waits for the return key, then displays the correct answer.
#
# Optional argument "shuffle". Then the **training** sequence will be shuffled.
#
# Invoke: ruby ham-training.rb amat_basic_quest_delim.txt training.txt shuffle


file_path=ARGV[0]
question_codes_path=ARGV[1]
options=ARGV[2]

questions = {}
# They seem to be using ISO-8859-1, seems like a good guess
IO.readlines(file_path,  :encoding => 'ISO-8859-1').each do |line|
	question_id, english_q, correct_answer, ia1,ia2,ia3,rest = line.split(/;/)
	questions[question_id] = [english_q, correct_answer, ia1,ia2,ia3]
end

training_keys = IO.readlines(question_codes_path).collect { |l| l.scan(/(B\-\d+\-\d+\-\d+)/)}.flatten.collect { |s| s.strip}.uniq

training_keys = training_keys.shuffle if options == 'shuffle'

# More or less decoration
def print_out(s='')
  puts "    #{s}"
end

training_keys.each do |key|
  question = questions[key]
  if question.nil?
    print_out "----------------------"
    print_out "No question for #{key}"
    $stdin.gets
    next
  end
  english_q, correct_answer, ia1,ia2,ia3 = question
  print_out '------------------------------------------------------------------------------------------------------------------------'
  print_out key
  puts
  print_out english_q
  puts
  [correct_answer, ia1, ia2, ia3].shuffle.each { |l| print_out l}
  puts
  print_out '------------------------------------------------------------------------------------------------------------------------'
  a = $stdin.gets
  print_out correct_answer
  a = $stdin.gets
  7.times { print_out  }
end
