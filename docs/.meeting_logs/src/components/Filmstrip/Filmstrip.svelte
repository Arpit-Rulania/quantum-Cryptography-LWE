<script>
  import Tile from "./Tile.svelte";
  import { fade } from "svelte/transition";

  import ContentLightbox from "../Lightbox";

  export let items = {
    title: "",
    content: []
  };
</script>

<style>
  .filmstrip {
    width: 200px;
    max-height: calc(100vh - var(--titleHeight) - 90px);

    background-color: var(--stripColour);
    
    padding: 15px;
    margin: 0 calc(var(--bMargin) / 2) var(--bMargin) calc(var(--bMargin) / 2);
    
    z-index: 0;
    border-radius: 5px;
    overflow-y: auto;
    cursor: pointer;

    -webkit-box-shadow: 1px 3px 22px 0px rgba(0, 0, 0, 0.3);
    -moz-box-shadow: 1px 3px 22px 0px rgba(0, 0, 0, 0.3);
    box-shadow: 1px 3px 22px 0px rgba(0, 0, 0, 0.3);
  }

  .spacer {
    transform: scale(0.98);
    transition: transform 0.2s;
    margin-bottom: 15px;
  }

  .spacer:hover {
    transform: scale(1);
  }

  .title {
    z-index: 1;
    text-align: center;
    position: sticky;
    background-color: var(--stripColour);
    top: -15px;
    margin-left: -15px;
    margin-right: -15px;
    margin-bottom: 30px;
  }
  
  .subtitle {
    font-style: italic;
    color: grey;
  }
</style>

<div class="filmstrip">
  <div class="title">
    <h2>{items.title}</h2>
  </div>
  {#if items.content}
    {#each items.content as item}
      <div class="spacer">
        <Tile on:click={() => ContentLightbox.createLightbox({...item, title: [items.title, item.title, item.date].filter(v=>v).join(" - ")})}>
          {#if item.title}
            {item.title}
          {/if}
          {#if item.date}
            <div class="subtitle">{item.date}</div>
          {/if}
        </Tile>
      </div>
    {/each}
  {/if}
</div>
