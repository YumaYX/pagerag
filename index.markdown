---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

RAGを使って、Webページの要点をアーカイブする。

{% assign sorted_posts = site.posts | sort: "title" %}

{% for post in sorted_posts %}
<li><a href="/pagerag/{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}

