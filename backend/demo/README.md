# Receipt scanning demo — read this first

This is a working demo of one feature: **you photograph a receipt, and the expense form
fills itself in.** No typing.

It runs entirely on your own computer. The receipt photo is never uploaded to OpenAI,
Google, or anyone else, and there is no API key and no monthly bill. That was the point of
choosing a self-hosted model, and it is also what lets DinarWise keep the promise already
made on the app's privacy screen: financial records stay on the user's device.

The demo does not save anything. It reads a receipt, shows you what it found, and forgets
it. Nothing touches the database.

## Running it

You need two things installed once: **Ollama** (the free program that runs the AI model on
your machine) and the model itself. The setup script does both, picks a model that fits
your computer's memory, and tests that it can actually see images.

```
cd backend
./scripts/setup_ai_demo.sh
```

Expect this to take a while the first time. The model is a few gigabytes, so the download
is the slow part. The script tells you what it's doing at each of its five steps, and if
something is missing it tells you the exact command to fix it.

When it finishes, start the app and open the page:

```
cd backend
pip install -e '.[dev]'
uvicorn app.main:app --reload
```

Then go to **http://localhost:8000/demo** in your browser.

Drag a photo of a receipt onto the page and press "Read this receipt". A photo taken with
your phone is fine — that's what this is for. Arabic receipts, English receipts, and the
usual bilingual Saudi receipts all work.

## What you should see

A green strip across the top means the AI is running and ready. If it's red, it says in
plain words what's wrong and what to type to fix it, so read it rather than guessing.

After you upload, the page shows a filled-in expense form: merchant, amount, date,
category, payment method, VAT, and the individual items it could read. That form is the
whole point — in the real app, that is the Add Expense screen, already filled in.

Three things are worth watching.

**The coloured banner at the top of the result.** Green means the AI is confident. Amber
means some fields are shaky. Red means treat everything as a guess. This is the honest
signal, and it matters more than the extracted numbers themselves.

**The amber "CHECK THIS" boxes.** Any field the system is unsure about is highlighted
rather than presented as fact. A receipt with no printed date, for example, gets today's
date and a highlight, instead of silently inventing one.

**The timer.** It counts the seconds. The first receipt is always slow because the model
has to load into memory; after that it speeds up a lot.

There's also a "Show the raw data the model returned" link at the bottom if you ever want
to see exactly what the AI said before we cleaned it up.

## How accurate is it, honestly

On a clear, flat, well-lit photo the total and the merchant come out right most of the
time. Dates and categories are less reliable. Crumpled thermal receipts, glare, and
shadows hurt accuracy a lot more than the choice of model does, so the single biggest
improvement is a better photo.

Speed depends entirely on the computer, and this is the part worth deciding before you
commit to anything:

| Your computer | Model it picks | Roughly per receipt |
| --- | --- | --- |
| Mac with Apple Silicon, 16 GB+ | qwen2.5vl:7b | 5–15 seconds |
| Mac or PC, 8–16 GB | qwen2.5vl:3b | 15–40 seconds |
| PC with a decent NVIDIA card | qwen2.5vl:7b | 2–6 seconds |
| Under 8 GB | small model | a minute or more, noticeably worse |

The model chosen by default, `qwen2.5vl`, reads Arabic considerably better than the
alternatives, which is why it's first in the list. If it's too slow on your machine, the
setup script's smaller option is a reasonable trade.

## The one design decision to understand

**The AI never saves anything by itself.** It produces a draft, the user glances at it, and
only the user's tap writes the expense. That isn't a limitation of the demo — it's
deliberate, it's enforced in the code, and it's how the feature was already designed in
`ARCHITECTURE.md`.

The reason is simple: an AI that reads 187.45 as 18.745 and saves it silently corrupts
someone's budget in a way they may not notice for months. A draft they confirm cannot do
that. So even at high confidence the confirmation step stays.

## What this demo does not include

The demo answers "is this possible?" — it is not the finished feature. Still missing:

The phone app is untouched. There's no "Scan receipt" button in the Flutter app yet; this
demo runs in a browser talking to the backend directly. Wiring it into the mobile capture
screen is the next piece of work.

Nothing is stored, and there is no user account, no rate limiting, and no audit trail on
the scanning endpoint.

Hijri dates are detected but not converted. If a receipt shows only a Hijri date, the
system refuses it and uses today's date with a highlight, rather than risk filing the
expense in the year 1448. Proper conversion needs a calendar library.

And for real use you'd have to decide where the model runs. On the user's phone it's
private but slow and large. On your own server it's fast, but receipt images then leave the
device — which contradicts what the privacy screen currently promises, so it would need to
be an explicit, opt-in choice with the trade-off spelled out to the user. That decision is
worth making deliberately, not by default.

## If something goes wrong

If the status strip says it can't reach the AI service, run `ollama serve` in a separate
terminal window and leave it running.

If it says the model isn't installed, run `./scripts/setup_ai_demo.sh` again — it's safe to
re-run and won't re-download anything it already has.

If a read times out, the model is too big for the machine. Open `backend/.env` and change
`DINARWISE_OLLAMA_VISION_MODEL` to a smaller model, or raise
`DINARWISE_OLLAMA_TIMEOUT_SECONDS`.

If the page itself won't load, check the terminal running `uvicorn` for errors.
