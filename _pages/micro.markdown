---
layout: page
title: Micro Blog
permalink: /microblog/
---

<style>
    .mt-body {
        padding: 0px;
        background-color: #f6f5ed;
        --mt-color-link: rgb(195, 12, 12);
        --mt-color-bg: #f6f5ed;
        --mt-color-btn-bg: #000;
        margin-bottom: 0;
    }
    .mt-post-counter-bar {
        justify-content: right;
        min-width: 100%;
    }
    .mt-footer {
        display: none;
    }

    .mt-post {
        border-top: 0px;
        border-bottom: 0px;
    }
</style>

<div id="mt-container" class="mt-container">
  <div class="mt-body" role="feed">
    <div class="mt-loading-spinner"></div>
  </div>
</div>

<script>
window.addEventListener("load", () => {
    const myTimeline = new MastodonTimeline.Init({
    instanceUrl: "https://mastodon.social",
    timelineType: "profile",
    userId: "111609027378633433",
    profileName: "@reevik",
    maxNbPostShow: "5",
    });
});
    
</script>