---
title: "{{ replace .Name "-" " " | title }}"
layout: "bundle"
outputs: ["Reveal"]
date: {{ .Date }}
draft: true
---

> {{ replace .Name "-" " " | title }}
