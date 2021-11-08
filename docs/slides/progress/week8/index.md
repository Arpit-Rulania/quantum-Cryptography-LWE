---
title: "Progress - Week 8"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-11-07T22:49:43+11:00
---

{{< slide class="center" content="blocks.cover" >}}

> Week 8 Progress Update

---

## Schedule

![](./gantt.jpg)

**Blocking -** Matrix Multiplication

---

## Development of the MCU

* Main Control Unit created to co-ordinate signals
* Two operating modes
  * Encryption
  * Decryption

---

## Dot Product

![](dotproduct.png)

> Next steps: Multiplier

---

## Optimising the Encryption Stage

{{% section %}}

> Issue: Current row selection is biased

i.e 10% selection chance / 90% not selected

* Next item has 10% x 90% = 9% chance of selection
* Next item has 10% x 81% = 8.1% chance of selection

* Non-uniform = higher chance of set reuse
* Not cryptographically secure!

---

##### <u>Proposal</u>

Select the sampled rows external to the encryption,  
and pass in only the required data

{{% /section %}}

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}
