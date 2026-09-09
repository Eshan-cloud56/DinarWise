# Smart Receipt Scan: model distribution decision

## Production handoff (2026-09-08)

There is currently **no HTTP downloader**, model URL setting, CDN integration,
or download manifest parser in this repository. The existing native channel
supports status, local import, OCR and inference. `GEMMA_MODEL_SHA256` is its
only artifact configuration. Do not mistake the import progress stream for
network download progress.

Manual selection is now debug-only, guarded in the UI, Dart service and native
Android handler. Release builds with no installed model show the localized
unconfigured state; they cannot open the model file picker. Existing verified
private installations can still initialize. The public download flow is pending
the real hosting endpoint below, not implemented or verified yet.

### Required hosting contract for the forthcoming downloader

These are proposed implementation inputs, not environment variables that work
in the current app:

| Input | Required value |
| --- | --- |
| Artifact | `gemma-3n-E2B-it-int4.litertlm` (unchanged bytes) |
| Expected byte length | `3655827456` (local file measured) |
| SHA-256 | `2ed7bc3a0026c93d5b8a4544b352d9d00cd66ff0bac3ef6a20ac3d2cba4010d6` |
| Download URL | Owner must supply an actual immutable HTTPS object URL |
| Authentication | Anonymous read for the app; no HF login/token or embedded storage secret |
| Response | Raw model bytes, HTTP 200; not HTML, a login page or a ZIP |
| MIME type | `application/octet-stream` |
| Length | Correct `Content-Length`; no content transformation/compression |
| Resume | Byte Range requests return 206 and correct `Content-Range`; stable ETag and `If-Range` support |
| Transport | Valid public TLS certificate; no HTTP downgrade or unapproved redirect hosts |
| Availability | Accessible in intended distribution regions; supports multi-GB transfers |
| Companion documents | Full Gemma terms copy, `NOTICE.txt`, prohibited-use policy copy, owner-approved feature terms |

A private object-store origin behind an anonymously readable CDN endpoint is
sufficient. The app needs read access only; upload/admin credentials stay with
the owner. CORS is not required for the native Android downloader. If private
delivery is preferred, an owner-operated service must issue renewable short-lived
URLs without end-user accounts; that is a different transport contract requiring
an endpoint and expiration/renewal specification.

For this fixed model, pin the URL, size and SHA in a reviewed app release. A
remote manifest is unnecessary. If future model updates use a remote manifest,
authenticate that manifest with a pinned verification key; do not trust a new
digest merely because it arrived beside a download URL.

Before wiring a supplied endpoint, check HEAD/GET metadata, a small Range request,
resume/ETag behavior, and a full downloaded-file checksum. No endpoint has yet
been supplied or tested. Hosting charges/egress are the owner's responsibility.

### Redistribution documents and user terms

Source: [Gemma Terms of Use, section 3.1](https://ai.google.dev/gemma/terms),
accessed 2026-09-08. The page lists Gemma 3n in its appendix.

Prepare a distribution package with a full agreement copy (`GEMMA_TERMS.txt`),
a `NOTICE.txt` containing the exact notice required by section 3.1(4), and a copy
of the [Gemma Prohibited Use Policy](https://ai.google.dev/gemma/prohibited_use_policy).
Required `NOTICE.txt` content:

> Gemma is provided under and subject to the Gemma Terms of Use found at ai.google.dev/gemma/terms

The first filename is our packaging convention; the agreement copy and Notice
are obligations, not a requirement for a specifically named LICENSE file.
Bundle these small documents in the app and install copies alongside the model
so each recipient can read them offline. Keep the originals intact and retain
their version/date and upstream provenance. Do not label the model Apache/MIT
or assume the runtime's license covers its weights.

The agreement governing Smart Receipt must incorporate section 3.2 restrictions
as enforceable terms and notify recipients of them. Modified model files need
prominent modification notices; DinarWise will distribute the supplied bytes
unchanged. Owner/legal review must finalize the feature terms, acceptance
mechanism, and translations before public redistribution. This document is a
technical handoff, not an assertion that app terms already satisfy those duties.

Proposed first-use copy (owner/legal review pending):

English: Download the optional Smart Receipt model (3.66 GB). After setup,
receipt scanning works on this device without internet. Review extracted details
before saving. By tapping Download and continue, you agree to the linked Smart
Receipt terms, including the Gemma use restrictions.

Arabic: نزّل نموذج مسح الإيصالات الذكي الاختياري (3.66 غيغابايت). بعد الإعداد،
يعمل مسح الإيصالات على هذا الجهاز دون إنترنت. راجع التفاصيل المستخرجة قبل الحفظ.
بالنقر على «تنزيل ومتابعة»، فإنك توافق على شروط مسح الإيصالات الذكي المرتبطة،
بما فيها قيود استخدام Gemma.

Expose links to the full terms and model notices, plus Download and continue,
Wi-Fi-only preference, and Not now/manual expense entry. Persist the accepted
feature-terms version. Hugging Face accounts are not part of this flow.

### Planned download/install lifecycle

Tap Smart Scan → optional download/terms screen → resumable Android background
download with foreground progress/cancel/retry → verify byte length and SHA-256
→ atomic activation in private no-backup storage → LiteRT-LM initialization
→ OCR → Gemma → validated structured data → editable expense form.

Keep partial files private, check free storage with runtime headroom, enforce a
single download, handle process death, reject mismatches and preserve any working
model until replacement succeeds. Never report ready solely from a marker file
when the runtime failed. Keep receipt contents and model prompts out of network
requests and logs. The model must remain excluded from APK/AAB assets.

Native installation/inference on Samsung is still unverified. Device support
depends on architecture, RAM, storage and runtime compatibility; automatic
download cannot make Gemma usable on every Android phone. Manual expense entry
must remain available on unsupported devices.

## Implemented boundary

The app includes on-device Latin OCR (ML Kit), Arabic/English OCR
(Tesseract ara+eng), strict receipt validation, editable review and a
LiteRT-LM Gemma 3n E2B runtime. No cloud OCR/AI calls, model URL, API token,
Hugging Face credential or model weights are included.

The Samsung test artifact is pinned to SHA-256
`2ed7bc3a0026c93d5b8a4544b352d9d00cd66ff0bac3ef6a20ac3d2cba4010d6`.
Android lets the user choose this licensed `.litertlm` artifact,
streams it into private no-backup storage, shows progress, limits it to 6 GiB,
verifies SHA-256 and atomically activates it. LiteRT-LM must initialize the
verified model successfully before Smart Scan reports itself as ready. A wrong
artifact is deleted.

This does not grant or bypass access to Gemma. The tester must separately
obtain the exact artifact under Google Gemma terms.

## Safest production distribution

Before enabling a public in-app download, the product owner/legal reviewer
should:

1. Accept and retain a record of the Gemma terms and confirm redistribution of
   the chosen artifact is permitted for this app and intended territories.
2. Pin its filename, size, license/notice version and SHA-256; benchmark it on
   the supported Samsung device range.
3. Host the immutable artifact in an owner-controlled HTTPS object store/CDN.
   Never proxy or embed a personal Hugging Face token.
4. Supply the agreement/Notice and incorporate enforceable use restrictions as
   described above; have the owner/legal reviewer finalize the acknowledgement.
5. Add a foreground/WorkManager download with Wi-Fi preference, space check,
   resume, cancellation, progress, checksum and atomic promotion.
6. Pin the fixed artifact in the app; use a verified signed manifest only if
   remote artifact updates are introduced.

Play Asset Delivery is possible, but couples a multi-gigabyte model to Play
releases and may not suit licensing, regions, compatibility or rapid rollback.

## OCR routing and limitations

- Latin: ML Kit Text Recognition v2.
- Arabic: Tesseract 5 with official tessdata_fast Arabic and English data.
- Auto: starts with ML Kit; sparse/no-total/Arabic-signaled output is checked
  by Tesseract and selected if Arabic characters are present.
- ML Kit cannot see Arabic, so dense Latin text can hide an Arabic portion.
  The Arabic / mixed receipt action explicitly selects Tesseract.
- OCR language data is bundled (about 5.4 MB), so it works fully offline.

Bundled tessdata_fast source commit: 87416418657359cb625c412a48b6e1d6d41c29bd.
SHA-256: ara e3206d3dc87fd50c24a0fb9f01838615911d25168f4e64415244b67d2bb3e729;
eng 7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2.

Output is untrusted, length-bounded, strictly parsed and revalidated after
review. Invalid dates, currencies, card suffixes, amounts, inconsistent totals
and unsupported ledger precision are not applied. Foreign-currency amounts do
not change ledger currency. Payment stays unchanged because DinarWise has no
saved card-last-four/account identifiers.

No scan is automatically saved. Existing balance checks, persistence and
attachment logic remain authoritative.
