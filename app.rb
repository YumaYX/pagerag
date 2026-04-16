# frozen_string_literal: true

require 'readability'
require 'ferrum'
require 'fileutils'
require 'date'
require 'ys1'

DONE_FILE = 'done.txt'
OUTPUT_DIR = '_output'

def sanitize_filename(name)
  name.gsub(%r{[\\/:*?"<>|#]}, '_')
      .gsub('·', '-')
end

def reference(url, title)
  <<~REFEOL

    # Reference
    [#{title}](#{url})
  REFEOL
end

def done?(url, done_file = DONE_FILE)
  return false unless File.exist?(done_file)

  File.foreach(done_file).any? { |line| line.strip == url }
end

def add_done(url, done_file = DONE_FILE)
  File.open(done_file, 'a') { |f| f.puts url }
end

def readable(source)
  Readability::Document.new(source).content
end

def page_html(url)
  browser = Ferrum::Browser.new(headless: true)

  begin
    browser.goto(url)
    [browser.title, browser.body]
  ensure
    browser.quit
  end
end

def summary_page_content(prompt)
  YS1::Ollama.model = 'gemma3n'
  YS1::Ollama.stream(prompt)
end

def build_questions_prompt(title)
  <<~PROMPT
    titleの内容を質問文にして。具体的な3つの質問を作って。just answer.
    ---
    title:#{title}
  PROMPT
end

def jekyll_post_prefix(date = Date.today)
  date.strftime('%Y-%m-%d-')
end

def run_rag
  success = system('source .venv/bin/activate && uv run python3.12 rag.py')
  raise 'RAG処理に失敗しました' unless success
end

def summary(url)
  if done?(url)
    puts "SKIPPED: #{url}"
    return
  end

  puts "Processing: #{url}"

  title, html = page_html(url)
  ref = reference(url, title)

  clean_title = title.gsub(/\s\|\s*.*/, '').gsub(/\s-\s.*/, '')

  html = readable(html)

  puts "オリジナルタイトル:\n#{title}"

  prompt = build_questions_prompt(clean_title)
  q = summary_page_content(prompt)

  File.write('q.txt', q)
  File.write('temp', html)

  run_rag

  rag_result = File.read('output.md')
  final_output = rag_result + ref

  FileUtils.mkdir_p(OUTPUT_DIR)

  file_name = sanitize_filename(
    "#{jekyll_post_prefix}#{clean_title.gsub(/\s/, '_')}.md"
  )

  output_path = File.join(OUTPUT_DIR, file_name)
  File.write(output_path, final_output)

  add_done(url)

  puts "Saved: #{output_path}"
end

summary(ARGV.first) if __FILE__ == $PROGRAM_NAME
