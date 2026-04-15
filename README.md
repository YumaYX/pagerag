
<https://yumayx.github.io/pagerag/>

---

# install

```sh
bundle install
uv sync && source .venv/bin/activate
```

```sh
ollama pull gemma3n
ollama pull gemma4
ollama pull bge-m3
```

require: ollama, ruby , uv

# execution

```sh
bundle exec ruby app.rb "<url>"
```

## loop exec

```sh
cat urls.txt | while read line
do
bundle exec ruby app.rb "${line}"
done
```

# markdown to html

```
for f in $(ls -1 _output/*.md)
do
  echo $f
  pandoc -f markdown -t html "${f}" -o "${f}".html -s --toc
done
```

