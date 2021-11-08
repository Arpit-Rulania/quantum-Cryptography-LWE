---
title: "Progress - Week 8"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-11-07T22:49:43+11:00
---

{{< slide class="center" content="blocks.cover" >}}

> Week 8 Progress Update

---

### Schedule

![](./gantt.jpg)

**Blocking -** Matrix Multiplication

---

### Development of the MCU

* Main Control Unit created to co-ordinate signals
* Two operating modes
  * Encryption
  * Decryption

---

### Dot Product

![](dotproduct.png)

> Next steps: Multiplier

---

<style>
iframe.viz {
  background-color: rgba(255,255,255,0.85);
  height: 100vh;
  width: 100%;
  overflow-y: hidden;
  transition: background-color 0.3s;
}
iframe.viz:hover {
  background-color: rgba(255,255,255,1);
}

.resp-container {
  max-height: 600px;  
  overflow-y: hidden;
}
</style>

### Approximate Multipliers

{{% section %}}

> Speed, Space, Accuracy, Security

<img width="40%" src="./8is7a1ixij201.jpg" />

---

* Error corrections are useful (better approx.) but...
  * 1-1 mapped LUT is costly
* Binned EC values?
* Single average EC value?

<div style="display: flex; flex-direction: row;">
    <div style="display: flex; flex-direction: column; align-items: center;">
        <img width="100%" src="./correction_visualisation/before.jpg" />
        Uncorrected
    </div>
    <div style="display: flex; flex-direction: column; align-items: center;">
        <img width="100%" src="./correction_visualisation/after.jpg" />
        Corrected
    </div>
</div>

---

> Future: Verification of acceptable error

* Consistency with error ratios for invalid keypairs
* Magnitude of importance

---

<div class="resp-container">
<small style="position:absolute; top: -20px; left: 0; right: 0;">e.g. Consistency with error ratios for invalid keypairs</small>
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/d_vals_badS.html"></iframe>
</div>

---

<div class="resp-container">
<small style="position:absolute; top: -20px; left: 0; right: 0;">e.g. Magnitude of importance</small>
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/log_m45,n65,qTO157.html"></iframe>
</div>

* [Cryptographic Integrity 1](https://featherbear.cc/unsw-comp3601-project/matlab-model/#/5)
* [Cryptographic Integrity 2](https://featherbear.cc/unsw-comp3601-project/matlab-model/#/9)

{{% /section %}}

---

### Optimising the Encryption Stage

{{% section %}}

> Issue: Current row selection is biased

i.e 10% selection chance / 90% not selected

* Next item has 10% x 90% = 9% chance of selection
* Next item has 10% x 81% = 8.1% chance of selection

* Non-uniform = higher chance of set reuse
* Not cryptographically secure!

---

###### <u>Proposal</u>

Select the sampled rows prior to calling the encryption module, and pass in only the required data

* Possible mitigation of side-channel timing attack?

{{% /section %}}

---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}
