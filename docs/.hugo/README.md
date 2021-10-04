> Hello friends.  
Markdown on _everything_.

This directory contains the source code for the presentations, built with [Hugo](https://gohugo.io/) and [Reveal.js](https://revealjs.com/).

They will automatically be built and published [here](https://featherbear.cc/unsw-comp3601-project) when pushed to this GitHub repository

---

Here's a quick TL;DR on how to create a presentation.

## I'm a terminal warrior, 🔥🔥🔥 _SHOW ME THE COMMANDS_ ⚡⚡⚡

1. Navigate to this directory (should contain `config.toml`, ...)  
2. Create a new post with `hugo new [PRESENTATION_NAME].md`  

> The created post will appear in `../slides/[PRESENTATION_NAME].md`, and will be created as a **draft** (Won't be published).  
_Note: The `slides` directory is one level back (not in this folder!)_

You can now run `hugo server -DEF` to start a preview server.  
_Note: The `-DEF` flags allows draft presentations to be visible, otherwise they won't appear._

3. Edit the file with markdown. Use `---` as slide separators.  
4. When the post is finalised, remove the `draft: true` property from the front matter

## copy-paste-find-replace

1. Create a copy of any of the existing presentations
2. Change the title and date
3. Edit the content
3. ???
4. Profit

# Media

You can reference images by URL (i.e `![](https://picsum.photos/200/300)`) or by relative path (i.e `![](./image.png)`).  
_For relative files you need to prepare your presentation's file directory structure_

## Separate Directories

To include graphics, create a folder inside the `../slides/` directory that matches the filename of your presentation.

For example, if your presentation file was called `presentationABC.md`, create a folder called `presentationABC` such that `../slides/presentationABC` exists.  

```
slides
+--presentationABC
|  \--image.png
\--presentationABC.md
```

## Bundled

Create a folder inside the `../slides/` directory that matches the filename of your presentation.  
Then move your presentation file into that new directory, and _rename the presentation file to `index.md`_.  

```
slides
+--presentationABC
   +--index.md
   \--image.png
```
