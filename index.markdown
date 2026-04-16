---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

RAGを使って、Webページの要点をアーカイブする。

<ul>
{% for post in site.posts %}
<li><a href="{{ post.url }}">/pagerag/{{ post.title }}</a></li>
{% endfor %}
</ul>

