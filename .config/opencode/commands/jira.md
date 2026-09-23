---
description: Read a Jira ticket and produce an implementation plan
---

You are implementing a Jira ticket. Here is the workflow:

1. **Read the ticket** — Review the ticket data below (summary, description, acceptance criteria, components, labels, etc.) to understand what needs to be built or fixed.
2. **Identify codebase(s)** — Determine which project(s), services, or modules are affected. If the ticket doesn't specify, explore the workspace to find relevant code.
3. **Explore the codebase** — Use your tools (grep, glob, read, list) to examine the relevant files, understand the current structure, and identify where changes need to be made.
4. **Present an implementation plan** — Deliver a structured plan covering:
   - Summary of what needs to be done
   - Codebase analysis (which files/modules are affected)
   - Implementation steps in dependency order
   - Open questions or clarifications needed

Here is the Jira ticket data:

!\`curl -s --user "$JIRA_USERNAME:$JIRA_API_TOKEN" \
  --header 'Accept: application/json' \
  "https://${JIRA_DOMAIN:?JIRA_DOMAIN not set}.atlassian.net/rest/api/3/issue/$1"\`
