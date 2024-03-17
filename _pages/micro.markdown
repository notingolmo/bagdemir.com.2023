---
layout: page
title: Microblog
permalink: /microblog/
---

<style>
    .mt-body {
        --mt-color-link: #ff4d4d;
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
        text-align: left;
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
    maxNbPostFetch: "5",
    defaultTheme: "dark"
    });
});
    
</script>