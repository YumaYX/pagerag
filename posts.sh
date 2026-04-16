#!/usr/bin/bash

mkdir -p _posts

ls -1 _output/* | while read line
do
	cat <<POSTEOF > _posts/$(basename ${line})
---
layout: post
---

<p><small>This page is automatically generated using RAG (Retrieval-Augmented Generation).</small></p>


$(cat "${line}")
POSTEOF
done

