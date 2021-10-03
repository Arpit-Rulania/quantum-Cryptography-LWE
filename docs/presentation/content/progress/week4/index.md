---
title: "Progress - Week 4"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-10-03T22:49:43+11:00
draft: true
---

{{< slide class="center" content="blocks.cover" >}}

> Week 4 Progress Update 

---

## Schedule

![](gantt/gantt_change.gif)

Didn't get up to testing the RNG and Multiplier units.  
Testing extended to Week 4

---

## How Big?

specs

catering

---

## Modulo

{{% section %}}

It works... but it's kinda slow...

![](modulo/modulo_simple.jpg)

> 128 % 2 takes 65 cycles  

---

Save some cycles!

![](modulo/module_subtract_multiples.jpg)

> 128 % 2 now takes 15 cycles

---
![](modulo/module_subtract_multiples_better.jpg)

9 cycles? How about 8?!

![](modulo/module_subtract_multiples_even_better.jpg)

{{% /section %}}

---

## VHDL Blocks

{{% section %}}
> BEFORE

<img src="Snipaste_2021-10-03_18-36-27.jpg" width="70%" >

---

> AFTER

![](Snipaste_2021-10-03_18-29-05.jpg)

{{% /section %}}

---

![](connection_diagram.drawio.png)

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}