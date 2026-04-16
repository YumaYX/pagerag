---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<section>
RAGを使って、Webページの要点をアーカイブする。
</section>

{% for post in site.posts %}
<li><a href="/pagerag/{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}

