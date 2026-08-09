---
name: grilling
description: |
  Interview the user one question at a time, walking the decision tree branch by branch, until both sides share the same understanding of what to build.
  Use when a request is underspecified and the open points are decisions the user must make rather than facts that can be looked up.
  Unlike grill-me, this waits for an answer to each question before asking the next, and blocks all action until the user confirms shared understanding.
---

Interview me relentlessly about every aspect of this until we reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing. Asking multiple questions at once is bewildering.

If a fact can be found by exploring the environment (filesystem, tools, etc.), look it up rather than asking me. The decisions, though, are mine — put each one to me and wait for my answer.

Do not act on it until I confirm we have reached a shared understanding.
