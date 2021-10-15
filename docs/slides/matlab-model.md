---
title: "MATLAB Model"
layout: "bundle"
outputs: ["Reveal"]
date: 2021-09-03T22:49:43+11:00
tilecolour: "#0f9d58"
---

<!-- <script src="https://d3js.org/d3.v4.js"></script> -->
<!-- <script src="//featherbear.github.io/UNSW-COMP3601/project/matlab/charter.js"></script> -->

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

{{< slide class="center" content="blocks.cover" >}}

> A look at our MATLAB model...

{{% note %}} Brought to you by featherbear and his hatred towards MATLAB {{% /note %}}

---

## MATLAB Model

```matlab
function S = generatePrivateKey(m)
    global q;
    S = randi(q, [m, 1]);
end

function [A, B] = generatePublicKey(S, m, n)
  global q;
  A = randi(q, [n, m]);
  e = round(randn(n, 1));
  B = mod(A*S, q) + e;
end

function [u, v] = encryptBit(M, A, B)
  global q;
  sampleSize = fix(numel(B) / 4);
  samplesChoices = randsample(1:length(B), sampleSize);
  u = mod(sum(A(samplesChoices,:)), q);
  v = mod(sum(B(samplesChoices,:)) - M * fix(q/2), q);
end

function M = decryptBit(u, v, S)
  global q;
  D = mod(v - dot(S, u), q)
  M = D > q/4 & D < 3*q/4;
end
```

Source: [lwe.m](https://github.com/featherbear/UNSW-COMP3601/blob/master/project/matlab/lwe.m)

---

{{% note %}} Oh my goodness guys are you ready for some INTERACTIVITY {{% /note %}}

{{< slide class="center" >}}

# Performance

---

{{< slide class="center" >}}

```
Elapsed time is 38.385325 seconds.
Statistics (10000 tests) 82.95%
```

Not bad...!

---

#### Decryption Statistics

<div class="resp-container">
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/d_vals.html"></iframe>
</div>

---

#### Decryption Statistics - Bad Private Key

<div class="resp-container">
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/d_vals_badS.html"></iframe>
</div>

---

{{< slide class="center" >}}

# Observations

---

#### `m` is sort of useless...

<div class="resp-container">
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/log_mTO500,n12,q23.html"></iframe>
</div>

---

#### `n` has a negative effect

{{% section %}}

<div class="resp-container">
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/log_m4,nTO1000,q23.html"></iframe>
</div>

---

Increasing `n` also slows down the time it takes to encrypt and decrypt the messages...

> Don't make `n` large!



{{% /section %}}

---

#### Large values of `q` are good

<div class="resp-container">
<iframe class="viz" src="//featherbear.github.io/UNSW-COMP3601/project/matlab/log_m45,n65,qTO157.html"></iframe>
</div>

---

### What Does This Mean?


* `m` - ... whatever
* `n` - Keep this small!
* `q` - Make this large!


---

{{< slide content="blocks.cover" >}}
{{< slide content="blocks.end" >}}

<script>
  for (let elem of document.getElementsByTagName('iframe')) {
    try {
    elem.contentWindow.addEventListener('keydown', function() {
      console.log('hm')
    }, true);
    } catch {}
  }
/*
{
  const baseDataURL = "https://featherbear.cc/UNSW-COMP3601/project/matlab/"
  // const baseDataURL = "//featherbear.github.io/UNSW-COMP3601/project/matlab/"
  for (let elem of [...document.querySelectorAll('.dataviz')]) {
    let {file, variable, keys, title} = elem.dataset;
    keys = keys.split(",")
    charter(elem, baseDataURL + file, {
      variable,
      keys,
      title
    })
  }
}
*/
</script>
