<script>
  import Content from './LightboxContent.svelte'

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  function close() {
    dispatch("destroy");
  }

  import { fade } from "svelte/transition";

  export let data;
</script>

<style>
  .lightbox {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;

    display: flex;
    align-items: center;
    justify-content: center;
  }

  .background {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.4);
    z-index: -1;
    cursor: pointer;
  }

  .content {
    background-color: white;
    width: 60%;
    height: 60%;

    border-radius: 3px;
    user-select: text;

    /* text-align: center; */
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
  }

  @media (orientation: portrait) {
   .content {
     width: 95%;
    }
  }

  :global(.content > *) {
    width: 80%;
    max-height: 100%;
  }
</style>

<div class="lightbox" transition:fade={{ duration: 300 }}>
  <div class="background" on:click={close} />
  <div class="content">
    <Content data={data}/>
  </div>
</div>
