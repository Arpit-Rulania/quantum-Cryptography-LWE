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

## VHDL Components

{{% section %}}
> BEFORE

<img src="Snipaste_2021-10-03_18-36-27.jpg" width="70%" >

{{% note %}} Fleshed out the specifications for the components {{% /note %}}

---

> AFTER

![](Snipaste_2021-10-03_18-29-05.jpg)

{{% note %}} In that process, we also identified a few possible issues and overheads that would make the logic area large {{% /note %}}

{{% /section %}}

---

## Connection Diagram

<img src="connection_diagram.drawio.png" width="70%" />

---

## How Big?

{{% section %}} 

As per the project spec, the design needs to validate the provided configurations.

![](required_configurations.png)

> Does the design stay the same for all three configurations?

---

Our current design only supports up to 8-bit values.  

> We need to support $q = 65535$  
which is a 16-bit value.

🟧 TODO

---

![](required_configurations-bigA.png)

Public key A gets quite big...

We probably don't want to transmit $32768 \times 16 \times 16 \times 16$ bits at once...  

Instead, transmit $16 \times 16 \times 16$ bits $32768$ times?

{{% /section %}}

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

9 cycles? How about 8!

![](modulo/module_subtract_multiples_even_better.jpg)

{{% /section %}}

---

## Multiplier

<div class='side-by-side'>

<part>

> Before

![](./multiplier/multiplier_simple.jpg)

$87 \times 250$ in $87$ cycles

</part>

<part>

> After

![](./multiplier/multiplier_bitwise.jpg)

$87 \times 250$ in $7$ cycles

</part>

</div>

🟧 TODO: Approximate Multipliers

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}