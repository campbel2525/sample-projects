# Overview

This is a sample program that launches a virtual browser with Playwright and lets an AI operate it.

# Setup

1.

Install and set up `node: 20.0.0`.

I used `nodenv`, but any method is fine.

2.

```
npm install
```

3.

Create `.env` from `.env.example`.

Set your OpenAI API key.

# About the Sample

## Caution

Running the sample uses the OpenAI API and will incur costs.

## What it does

It operates the HTML at `docs/sample.html` in a browser.

There are three buttons (blue, yellow, red) in `docs/sample.html`. Clicking a button changes the background color to that color.

This sample takes a screenshot, passes it to the AI, and the AI clicks the appropriate button to set the correct background color.

As described in the prompt in `src/app/sample_operator_browser.ts`, it performs the following operations:

```
- If the background is white, click the button with selector ".button-x"
- If the background is blue, click the button with selector ".button-y"
- If the background is yellow, click the button with selector ".button-z"
- If the background is red, click the button with selector ".button-x"
```

## How to Run

1.

```
npx ts-node -r tsconfig-paths/register src/app/sample_operator_browser.ts
```

2.

After running the command above, a browser will launch.

3.

Get the full path of `docs/sample.html`, enter it into the launched browser, and open the page.

Note: Use the full path, not a relative path.

4.

Press Enter in the terminal.

5.

If the background changes as follows, it is working correctly:

```
white -> blue -> yellow -> red -> blue -> ...
```

6.

To stop the process, press `Ctrl + C` in the terminal.

# Folder Structure

- `src/app`: Application programs
- `src/config`: Configuration code
- `src/definitions`: Interfaces and types
- `services`: Logic and related programs
- `data/prompts`: Prompt history
- `data/screenshots`: Screenshot history

# Others

1. repomix command

```
npx repomix
```

All project code will be output to `repomix-output.xml`.

Use it when sending the code to an AI, if needed.

2. Format & Lint

```
npm run fix
```

