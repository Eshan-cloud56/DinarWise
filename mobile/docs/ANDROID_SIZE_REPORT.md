# Android release size reduction

Measured 2026-09-11. Version remains `1.0.1+3`; application ID remains
`com.sl.dinarwise.expensemanager`. Nothing was published, committed or pushed.

## Measured results

MB below means decimal MB (1,000,000 bytes). These are actual artifact sizes,
not estimates of installed storage or Play download size.

| Artifact | Before bytes | After bytes | Reduction |
| --- | ---: | ---: | ---: |
| Release AAB | 144,239,096 | 101,574,977 | 29.58% |
| Release ARM64 APK | 74,042,642 | 51,373,219 | 30.62% |
| Release ARMv7 APK | 44,309,476 | 43,185,091 | 2.54% |
| Release x86_64 APK | 80,665,681 | 53,883,877 | 33.20% |

The original 310,076,438-byte APK was a universal **debug** APK. Its debug
Flutter engines, Dart kernel and multiple architectures make it an unsuitable
baseline for measuring release-code optimization. The table compares release
builds before and after the dependency removal.

Release size analysis was run before editing and again after removal using
`flutter build apk --release --target-platform android-arm64 --analyze-size`.
Those analysis APKs measured 134,996,343 and 86,669,505 bytes. This command
restricted Flutter AOT to ARM64 but still included other native dependency
architectures; use the actual split-APK table above for device comparisons.

Baseline artifacts and analysis JSON were initially preserved under
`mobile/build/size-comparison/before/`, with optimized copies under `after/`.
The subsequent user-requested junk cleanup removed these generated comparison
copies. The measurements and checksums below remain the historical record;
see `SAFE_CLEANUP_REPORT.md` for current rebuilt deliverables.

## Changes made for size

- Removed obsolete `litertlm-android:0.16.1` dependency and its native runtime.
- Removed the unused Gemma Dart service and native model import, verification,
  initialization, inference and progress-channel plumbing. Retained the native
  OCR method and its existing implementation.
- Removed unused `video_player` and its now-unused transitive dependencies;
  no remaining dependency versions were upgraded.
- Removed the duplicate `launcher-approved.png` Flutter asset-bundle entry.
  Kept its source image, the active Flutter logo and Android launcher resources.
- Updated the receipt pipeline test to prove production scanning uses OCR and
  the API without invoking native model operations.

There was **no bundled multi-GB Gemma model** in the baseline APK. The main
avoidable payload was the native LiteRT-LM runtime (21.53 MB ARM64 and 25.65 MB
x86_64), plus its AAB debug metadata and Java dependencies. ARMv7 did not contain
that runtime, explaining its smaller reduction.

No existing privately imported files on user devices were deleted. This change
reduces build payload, not any historical user-installed model's disk usage.

## Preserved

- ML Kit Latin OCR and Tesseract Arabic/mixed OCR; native OCR body unchanged.
- Exactly `ara` and `eng` traineddata plus their license. Their bytes are unchanged.
- Cloudflare Smart Receipt API, editable review and manual transaction saving.
- All fonts, active logo and current code-rendered opening animation. Asset
  comparisons confirmed OCR data, bundled font files and active logo unchanged.
- All three Android ABIs; each split APK contains only its designated ABI.
- SQLite, financial calculations, Firebase, UI and existing uncommitted work.
- Existing release R8/resource shrinking and useful AAB crash-symbol metadata.

Old unbundled media source files were not deleted: deleting them would not
reduce the production artifact. No required image or OCR quality was reduced.

## Largest remaining ARM64 APK entries

| Entry | Stored/compressed bytes |
| --- | ---: |
| Flutter engine | 11,581,856 |
| Compiled Dart app | 11,338,640 |
| ML Kit OCR native pipeline | 11,064,544 |
| Tesseract | 4,164,360 |
| Leptonica image processing | 2,878,240 |
| English OCR traineddata | 1,977,229 |
| SQLite | 1,731,848 |
| Main DEX | 1,716,201 |
| Arabic OCR traineddata | 723,470 |

The AAB includes all ABIs and approximately 39.79 MB of compressed bundle
metadata, including symbols and mapping data. These are not all downloaded to
one phone. The largest individual AAB entries are Flutter/app libraries and
their symbols. Removing required OCR, SQLite or crash symbols to cosmetically
reduce the upload size was intentionally avoided.

## Verification

- `flutter analyze --no-pub`: passed, no issues.
- `flutter test --no-pub`: 90 tests passed.
- Receipt test formatting: completed.
- `git diff --check`: passed.
- Before and after release size-analysis builds: passed.
- Before and after `flutter build appbundle --release`: passed.
- Before and after `flutter build apk --release --split-per-abi`: passed.
- ZIP inspection: no Gemma model or LiteRT-LM runtime in optimized artifacts.
- AAB retains Flutter, ML Kit, Tesseract, Leptonica and SQLite for all three ABIs.
- Release APK certificate verification passed; AAB certificate inspected.
- ADB returned no connected devices. Physical camera/gallery receipt scanning
  was not verified in this task; perform the Samsung smoke test before release.

An intermediate `--no-pub` release build failed because the generated plugin
registrant still referenced the development integration-test plugin. Running
the normal Flutter build with dependency/plugin regeneration resolved this;
no application workaround or hand-edited generated registrant was introduced.

Builds emit an existing future-compatibility warning about the Kotlin Gradle
plugin used by Firebase Analytics/Performance. Builds succeed today. Firebase
dependencies were deliberately not changed as part of this size-only task.

## Deliverables and signing

Normal output paths (relative to `mobile/`):

- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

Signing remains the existing release key, not Android Debug:

`CN=Dinar Wise, OU=Mobile, O=Silvester Studio, L=Riyadh, ST=Riyadh, C=SA`

Certificate SHA-256:
`dd13b7cb07d0057f0a5aeee0247e2e8e159738ef936910589cad3ee2eebbe05b`

AAB SHA-256:
`c34e215d213d3230a0a41f9d070b413aa65407e2f38cf4a07986ebbe52d6120a`

ARM64 APK SHA-256:
`b460ea6e757bb49c4b067494a8b194321b4b81d0eed078542bf18ba51df8b0fc`

The version was not incremented for this size task. Confirm a valid higher Play
version code before a future upload. A locally release-signed APK may not update
an app installed with a debug or different Play app-signing certificate. Do not
uninstall the existing app to bypass a signature mismatch without first safely
backing up its local financial data.
