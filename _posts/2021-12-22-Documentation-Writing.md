---
layout: post
title: "Writing documentation, we struggle with"
description: "Writing documentation is not an easy task. It is sometimes more challenging - and not that spectacular, than writing source code since we as developers are trained how to deal with computers, but we may not know how people work."
date: 2021-12-22 08:41:50
author: Erhan Bagdemir
comments: true
keywords: "Random"
category: Misc
image:  '/images/18.jpg'
tags:
- Documentation
- Writing
- Software Engineering
---

Writing documentation is not an easy task. It is sometimes more challenging - and not that spectacular, than writing source code since we as developers are trained how to deal with computers, but we may not know how people work. Therefore, when it comes to writing documentation, we are usually reluctant. However, it is not that we as engineers underestimate this perpetual activity; in contrast, we may potentially be scared of it. With this article, I will briefly highlight a few essential points about making this process easier before writing activity leads to a dead end and we give up, finally. The checkpoints I noticed helped me a lot to create consistent documentation. First, let's start with the purpose.

### Don't mix the purpose

Having a clear purpose for writing would keep your composition lean and cohesive. For instance, reference documentation is a guide to the code of which goal is to explain its usage of it, and it should remain as a reference document without attempting to convey more information than its intent at the same time. Mostly, readers have clear goals as they're seeking through documentation, such as knowing how to use an API, how to integrate a library, how authentication works, and so on. So, we should give them what they need. State the purpose of the documentation at the beginning of the text clearly to align expectations with your audience. 

Before you start writing, you can ask questions yourselves like, "why am I writing this?", "What is the purpose of it?" to nail the right documentation type. Do you want to explain the usage of the source code? Then what you need is reference documentation. A step-by-step guide to accomplish a task? It sounds like a tutorial. Is it about architecture, the interaction of sub-systems, etc.? It sounds like a design document. The important thing is not to meld them in a single pot. 

### Know your Audience

I noticed engineers' tendency to easily take it for granted that the audience must be at the same knowledge and experience level. As a result, they automatically take shortcuts while explaining complex topics. This impatience attitude may cause readers to lose focus as they can't follow the subject due to a potential level mismatch. The other way around is also problematic. The text becomes quickly boring for advanced readers if written at the novice level. So, it is always a good idea to scope the level of readers in the introduction section and give a hint about the level of the content at the beginning of the document as prerequisites. 

### Maintaining Documentation

Unmaintained, abandoned-look documentation will be quickly discarded by people faster than unmaintained source code. There are a few reasons why engineers have absolutely no understanding of outdated or broken documentations. First, we are eager to see the source code. Reading source code is more intuitive to us, and the code constitutes a source of truth. Second, we have strong prejudices about the currency of documentations. Documentations will be skimmed through briefly, and the first impression is vital for the fate of the text. Any broken link, imprecision in text, and overcomplicated diagrams may lead to them being abandoned faster than you think. Thus, it is always a good idea to keep your documentation up to date and let your readers know that your documentation is regularly updated by adding freshness date, revision, etc., marker.

### Location 

It is also wise to put your documentation under version control and treat them as source code. Creating pull requests for changes and following the already entrenched software review process, etc., would certainly help improve the quality assurance in the first place. If you need to add diagrams to your documentation, you can consider using "diagram as code" tools like Plant UML to bring them under version control. However, some documentation types are not necessarily that technical as they don't relate to implementation directly but to some design discussions or high-level project discussions. I would recommend separating such documentation from the project's base and hiding it from our audience for clarity. 

### When not write Documentation

Before actual implementation begins, there are activities like high-level project meetings and commitment planning where the capacity requirements and business priorities will be explored. Sometimes, we must deliver rough estimates at this level that will be considered in the decision-making process, e.g., while sequencing the milestones and defining roadmaps. Therefore, it might be wise to take quick notes from our discussions with technical leads to track the path down to our decisions and not invest so much time into a writing activity because it might not be apparent at this stage if the project is officially planned for the next quarter, year, etc. So, I tend to put my notes into informal wiki pages to make the outcome from high-level project meetings accountable of which pieces I re-use in requirements analysis later. 

### Conclusion

Writing documentation is an essential part of our job and engineering activity. We create documentation for different purposes, including sharing knowledge, creating historical records for our decisions, helping our clients use our products, and so on. Writing documentation is a long-term investment but certainly not a one-time. Documentations need to be maintained as software evolves. To keep them consistent and cohesive, they should serve a single purpose and be aligned with our target audience's experience and knowledge level. Follow the same review process in software development and put the documentations right next to source code under version control. So, by leveraging entrenched techniques, we can also ensure quality assurance for them. 

<div style="font-size:9px; font-color:#EFEFEF; ">Rev 1.0 2021, 22nd Dec</div>