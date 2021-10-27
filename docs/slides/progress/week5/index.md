---
title: "Progress - Week 5"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-10-10T22:49:43+11:00
---

{{< slide class="center" content="blocks.cover" >}}

> Week 5 Progress Update

---

## Schedule

![](./gantt.jpg)

---

## Matlab

> [[MATLAB Analysis]](https://featherbear.cc/unsw-comp3601-project/matlab-model/#/1)

{{% note %}} PSA: MATLAB isn't a coding language - Andrew Wong {{% /note %}}

---

## Decryption Module

* Designed like a state machine
* Optimisation: Subtract q/4 from all sides of the inequality
  * Allows a simpler (faster!) comparison of `D < q/2`

---

## Updated Components

Updated port definitions to limit `n`

{{% section %}}

OLD  
![](./component_diagram/OLD-Snipaste_2021-10-03_18-29-05.jpg)

---

NEW  
![](./component_diagram/component_diagram.drawio_dark.png)

{{% /section %}}

---

## Report

Worked on the report

---

## Matrix Generation

![](./matrix_gen.jpg)


---

## Moving Forwards

* Complete the encryption module
* Test different matrix generation modules
  * Check storage requirements and performance
* Read more about approximate multipliers

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}