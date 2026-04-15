# frozen_string_literal: true

def reference(url, title)
  <<~EOL


  # Reference
  [#{title}](#{url})
  EOL
end

def skip_if_done(url, done_file = "done.txt")
  if File.exist?(done_file)
    File.foreach(done_file) do |line|
      if line.strip == url
        puts "SKIPPED " * 10
        exit
      end
    end
  end
end

def add_done(url, done_file = "done.txt")
  File.open(done_file, "a") do |f|
    f.puts url
  end
end

require 'readability'

def readable(source)
  Readability::Document.new(source).content
end

require 'net/http'

require 'ferrum'
def page_html(url)
  browser = Ferrum::Browser.new(headless: true)
  browser.goto(url)
  # JS実行後のHTMLを取得
  html = browser.body
  title = browser.title
  browser.quit
  return title, html
end

require 'ys1'
def summary_page_content(prompt)
  YS1::Ollama::model = 'gemma3n'
  YS1::Ollama.stream(prompt)
end


def build_questions_prompt(title)
  "titleの内容を質問文にして。具体的な3つの質問を作って。just answer.\n---\ntitle:#{title}"
end

require "date"
def jekyll_post_prefix(date = Date.today)
  date.strftime("%Y-%m-%d-")
end

require 'fileutils'
def summary(url)
  skip_if_done(url)

  title, html = page_html(url)
  ref = reference(url, title)

  html = readable(html)
  puts "オリジナルタイトル:\n#{title}"
  title = title.gsub(/\s\|\s*.*/,"").gsub(/\s\-\s*.*/,"")
  prompt = build_questions_prompt(title)
  q = summary_page_content(prompt)
  puts
  File.write('q.txt', q)
  File.write('temp', html)
  system('source .venv/bin/activate && uv run python3.12 rag.py')
  rag_result = File.read('output.md')
  File.write('output.md', rag_result + ref)
  FileUtils.mv('output.md', "_output/#{jekyll_post_prefix}#{title.gsub(/\s/, '')}.md")
  add_done(url)
end

summary(ARGV.first) if __FILE__ == $PROGRAM_NAME

