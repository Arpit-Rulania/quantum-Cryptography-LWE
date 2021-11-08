<script>
  import IFrame from "../PreviewIFrame.svelte"


  export let data;
  let commitID = ""
  let link = "";
  $: {
    link = (data.link || "").replace(/^https?:\/\//i, '')
    let regex = /^github.com\/.+?\/blob\/(.+?)\//i.exec(link)
    if (regex) {
      commitID = regex[1].slice(0, 8)
    }
  }
</script>

{#if data.title}
  <h1>{data.title}</h1>
{/if}
{#if data.content}
  {#if Array.isArray(data.content)}
    <ul>
        {#each data.content as entry}
          <li>{@html entry}</li>
        {/each}
    </ul>
  {:else}
    <p>{@html data.content}</p>
  {/if}
{/if}
{#if data.link}
  {#if commitID}
    <p>Commit: <a href={data.link}>{commitID}</a></p>
  {:else}
    <p>Link: <a href={data.link}>{link}</a></p>
  {/if}
{/if}
{#if data.frame}
  <IFrame url={data.frame.url} title={data.frame.title} />
{/if}