---
title: "Progress - Week 3"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-10-03T19:13:50+11:00
---

{{< slide class="center" content="blocks.cover" >}}

> Week 2 Progress Update

---

{{% section %}}

## Progress This Week

![](image1.png)

---

## Changes to the Gantt Chart

* RNG implementation has been extended into week 3
* Multiplication pushed back as implementation was discussed in Thursday lecture
* Need for a modulo function
* Need to generate prime numbers
* More research needed to be conducted in week 2 than anticipated

<div style="display: flex; flex-direction: row">
<img src="ganttBefore.png" width="50%" /><img src="ganttAfter.png" width="50%"/>
</div>

{{% /section %}}


---

## Random Number Generator

{{% section %}}

> Current Implementation

Linear Feedback Shift Register

* Pseudo-random
* Uses a chain of D-Type flip-flops
* Output is XOR'd and used as input feedback

<img src="image3.png" width="50%" />

---

> Implementation Result

![](./image4.jpeg)

---

> Alternative (P)RNG Methods

TRNG from Ring Oscillator and PRNG 

<img src="image5.png" width="60%" />

{{% /section %}}

---

## Current Research

* Synthesisable modulo operation
* Mersenne Primes
  * Required for generation of A matrix
  * 2<sup>N</sup>-1 not valid for all N
    * Still requires a check if prime
* Sampling and errors

---

## Lessons Learned

> Learning Vivado

![](./image6.png)

> Learning VHDL

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}