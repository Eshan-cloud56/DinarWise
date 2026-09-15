# Safe codebase cleanup

## Scope and safety

This pass removed generated output only. Existing uncommitted application work
was preserved. No Dart implementation, business logic, database schema/data,
navigation, Firebase configuration, Android build configuration, localization,
OCR implementation or packaged asset was changed in this cleanup.

References were inspected in `pubspec.yaml`, Dart imports, native resources,
OCR asset loading, documentation and Git's tracked/ignored file lists before
deletion. Uncertain files were kept. No commit, push or publication occurred.

## Removed

| Location | Reason safe |
| --- | --- |
| `mobile/build/` | Untracked/ignored generated outputs, intermediates, stale native/plugin outputs, test caches, previous APK/AAB copies and size-comparison copies. Rebuilt successfully from source. |
| `mobile/.dart_tool/` | Ignored generated package/build/native-hook caches. Recreated successfully for validation. |
| Old `mobile/dist/` contents | Four obsolete distribution files: `DinarWise-Samsung-WiFi.apk`, its `.cpgz` archive, `DinarWise-debug.apk`, and `DinarWise-offline-debug.apk`. No source references required them. Replaced with only four current release deliverables. |
| `mobile/android/.kotlin/` | Temporary Kotlin session directory; not an app resource or signing configuration. |

The build and Dart caches were removed again **after** successful validation,
with the new deliverables moved to `mobile/dist/`. The next Flutter command
will recreate required caches. Old binary copies were not backed up; build
outputs can be regenerated, but exact historical binaries may not be recoverable.

`flutter clean` initially started an unrelated iOS/Xcode dependency refresh.
It was stopped; the explicitly verified generated directories above were
cleaned directly instead. No tracked iOS configuration changes resulted.

## Kept intentionally

- All three fonts and licenses; active logo, Android launcher and animation.
- ML Kit OCR, Tesseract/Leptonica, `ara` and `eng` traineddata and their license.
- Cloudflare receipt parsing, review/edit UI and manual expense saving.
- Required generated Drift/localization source, tests and integration tests.
- Historical branding/design reference assets and documentation: not bundled,
  but retaining client originals/reference material is safer than deleting it.
- SQLite/native plugins, code-generation tools and other remaining packages.
  No additional dependency was proven safe to remove in this pass.
- Backend source/environment, Git history, signing keys and local settings.

The previous size-optimization task already removed unused Gemma/LiteRT-LM,
video-player dependencies and a duplicate packaged logo entry. Those removals
were not repeated or counted as new savings here. No model artifacts remain in
the mobile project or rebuilt release artifacts.

## Changes to source-controlled files

- Root `.gitignore`: exclude `*.aab` alongside existing APK/build rules.
- `mobile/android/.gitignore`: exclude `.kotlin/` session cache.
- `mobile/docs/ANDROID_SIZE_REPORT.md`: mark old comparison copies as removed.
- This report.

Other working-tree changes predate this cleanup and were preserved.

## Size results

Disk usage measured with `du -sk .`, including `.git`, backend environment and
deliverables. Numbers are allocated disk usage, not compressed repository size.

| Point | KiB | Approximate decimal GB |
| --- | ---: | ---: |
| Before cleanup | 8,512,088 | 8.72 |
| Clean source before rebuild | 552,320 | 0.57 |
| Final, with four current release files | 798,424 | 0.82 |

Approximately **7.90 GB / 90.6%** of local project disk usage was recovered.
Small documentation/filesystem metadata changes can slightly change `du`.

Release bytes compared against the already-optimized builds at task start:

| Artifact | Before | After |
| --- | ---: | ---: |
| AAB | 101,574,977 | 101,574,974 |
| ARM64 APK | 51,373,219 | 51,373,219 |
| ARMv7 APK | 43,185,091 | 43,185,091 |
| x86_64 APK | 53,883,877 | 53,883,877 |

There is **no meaningful additional app-size reduction**: deleted caches and
old releases were not packaged in the app. The three-byte AAB difference is
build-output variation, not a feature or resource removal.

Largest remaining project contributors: Git history (~395 MB), the four
current releases (~252 MB), backend virtual environment (~115 MB), and Android
tooling/source (~50 MB). None were removed merely to reduce the headline size.

Largest remaining ARM64 APK entries: Flutter engine 11.58 MB, compiled Dart
application 11.34 MB, ML Kit OCR 11.06 MB, Tesseract 4.16 MB, Leptonica 2.88 MB,
compressed English traineddata 1.98 MB and SQLite 1.73 MB. These are required.
The AAB also includes all ABIs and useful crash symbols/mapping metadata; it is
not the same as one phone's Play download size.

## Verification

- `flutter analyze`: passed, no issues (18.5 seconds).
- `flutter test`: all 90 current unit/widget tests passed.
- `flutter build appbundle --release`: passed (453.4 seconds).
- `flutter build apk --release --split-per-abi`: passed (155.1 seconds).
- `git diff --check`: passed.
- Artifact inspection: correct single ABI per split APK; required Flutter,
  ML Kit, Tesseract, Leptonica and SQLite libraries present; no LiteRT-LM/model.
- AAB fonts and both AAB/APK OCR packs match required source assets byte-for-byte.
- AAB certificate inspected and ARM64 APK signature verified: same existing
  release certificate, not Android Debug. No signing credentials changed.
- Existing Firebase plugin Kotlin future-compatibility warning remains;
  it does not fail the current build and was not changed for cleanup.

ADB detected no connected device. Camera/gallery OCR and physical-device
integration tests were not executed. The separate existing
`integration_test/onboarding_flow_test.dart` still expects obsolete checkbox
and transaction wording; it was retained rather than rewritten/deleted under
this cleanup-only scope. It is not part of the 90 passing unit/widget tests.

## Current deliverables

Only these four new files are retained in `mobile/dist/` (ignored by Git):

- `app-release.aab` — 101,574,974 bytes
- `app-arm64-v8a-release.apk` — 51,373,219 bytes
- `app-armeabi-v7a-release.apk` — 43,185,091 bytes
- `app-x86_64-release.apk` — 53,883,877 bytes

Version remains `1.0.1+3`; package remains `com.sl.dinarwise.expensemanager`.
No Play version update or upload was performed.

AAB SHA-256:
`4b061699f8385ecdfbc4013b3d4fb7c787007276eadb2a938a205e85561a290e`

ARM64 APK SHA-256:
`3347e6d73cb2c23aa3c99b5516f8d0485a44731e9a73d3ddac374ad5b3c8b928`

Signing certificate SHA-256:
`dd13b7cb07d0057f0a5aeee0247e2e8e159738ef936910589cad3ee2eebbe05b`

Do not uninstall an existing app to bypass a signing mismatch without first
safely backing up its local financial data.
