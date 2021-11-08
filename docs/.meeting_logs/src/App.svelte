<script>
  import Filmstrip from "./components/Filmstrip/Filmstrip.svelte";
  import siteData from "./siteData.hjson";
  import FileIcon from './icons/file-alt-regular.svg'
  import ColumnsIcon from './icons/columns-solid.svg'

  import Content from './components/Lightbox/LightboxContent.svelte'

  let showFlatView = false;

  if (location.hash === '#flat') {
    showFlatView = true;
    location.hash = ""
  }
</script>

<style>
  @import url('https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400&display=swap');

  .container {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .flatViewContainer {
    padding: 0px 15px var(--bMargin) 15px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }


  .flatViewContainer:before {
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-color: rgba(255, 255, 255, 0.4);
    content: '';
    z-index: -1;
  }

  .flatView {
    max-width: 100%;
    display: flex;
    flex-direction: column;
    user-select: text;
    overflow-x: hidden;
  }

  .overflowContainer {
    flex: 1;
    position: relative;

    flex-basis: 200px;
    display: flex;
    flex-wrap: wrap;

    justify-content: center;
  }

  :global(.overflowContainer > *) {
    flex-shrink: 0;
  }

  .titleBlock {
    background-color: white;
    
    z-index: 99;
    
    position: sticky;
    top: 0;
    height: var(--titleHeight);

    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    
    padding: 10px 0;
    margin-bottom: var(--bMargin);

    font-family: 'Open Sans';
  }

  .titleBlock img {
    height: calc(var(--titleHeight) - 30px);
    pointer-events: none;
    filter: contrast(0) brightness(0.2);
  }

  .titleBlock p {
    margin: 4px;
  }

  .titleBlock .modeToggle {
    position: absolute;
    top: 10px;
    right: 10px;
    height: 20px;
    width: 20px;
    cursor: pointer;

    opacity: 0.6;
    transition: opacity 0.3s;
  }

  .titleBlock .modeToggle:hover {
    opacity: 1;
  }
</style>

<div class="container">
  <div class="titleBlock gradientAnim">
    <h1>Generic Cards List Page</h1>
    <div class="modeToggle" on:click={() => showFlatView = !showFlatView}>
      <svelte:component this={showFlatView ? FileIcon : ColumnsIcon} />
    </div>
  </div>
  {#if showFlatView}
    <div class="flatViewContainer">
      <div class="flatView">
        {#each siteData.filter(d=>d.content && d.content.length).map(d => d.content.map(c => ({
          ...c, title: [d.title, c.title, c.date].filter(v=>v).join(" - ")
        }))).flat() as content}
          <Content data={content} />
        {/each}
      </div>
    </div>
  {:else}  
    <div class="overflowContainer">
      {#each siteData.filter(d=>d.content && d.content.length) as data}
        <Filmstrip items={data} />
      {/each}
    </div>
  {/if}
</div>
