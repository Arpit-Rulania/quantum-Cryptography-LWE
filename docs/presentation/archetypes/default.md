---
title: "{{ replace .Name "-" " " | title }}"
layout: "bundle"
outputs: ["Reveal"]
date: {{ .Date }}
draft: true
---

{{< slide class="center" content="blocks.cover" >}}

> {{ replace .Name "-" " " | title }}

---


---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}