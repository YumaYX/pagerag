#!/usr/bin/bash

mkdir -p _posts

ls -1 _output/* | while read line
do
	cat <<POSTEOF > _posts/$(basename ${line})
---
layout: post
---

$(cat "${line}")
POSTEOF
done

