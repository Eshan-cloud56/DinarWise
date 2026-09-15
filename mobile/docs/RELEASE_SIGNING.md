# Permanent Android release signing

Release APKs and AABs use the existing private DinarWise upload key. No new key
was generated. Application ID: `com.sl.dinarwise.expensemanager`.

Pinned public certificate SHA-256:
`dd13b7cb07d0057f0a5aeee0247e2e8e159738ef936910589cad3ee2eebbe05b`

Configure ignored `android/key.properties` with `storeFile`, `storePassword`,
`keyAlias` and `keyPassword`. Paths are resolved relative to `android/` unless
absolute. Preserve the existing key and securely back it up outside Git.
Never paste passwords into source, command-line arguments, build logs or docs.

CI can instead inject `DINARWISE_UPLOAD_STORE_FILE`,
`DINARWISE_UPLOAD_STORE_PASSWORD`, `DINARWISE_UPLOAD_KEY_ALIAS` and
`DINARWISE_UPLOAD_KEY_PASSWORD` from its secret store. Each environment value
overrides its corresponding local property. Supply the same private key through
secure CI file provisioning; do not commit it.

`validatePermanentReleaseSigning` runs before `preReleaseBuild` and
`validateSigningRelease`. It requires all four settings, opens the keystore,
checks the pinned certificate, and verifies access to the private key. Missing,
invalid, debug or replacement keys fail the release build. Errors do not expose
provider exceptions or secret values. Debug builds retain normal debug signing.

Build with:

```sh
flutter build apk --release
flutter build appbundle --release
```

For deliberate future key rotation, use the appropriate official Play process
and review this pin explicitly; never remove the validation as a workaround.

Upgrade compatibility

APKs built with this configuration retain the same application ID and signing
certificate. Future updates must also use a suitable increasing versionCode and
remain compatible with the device. This does not guarantee upgrades over older
debug-signed installations or installations signed with another certificate.

With Play App Signing, this key signs uploads. Google signs delivered APKs with
the Play app-signing key, which may differ from the upload key. Test updates to
Play-installed apps through Play testing tracks; a directly sideloaded upload-
key APK may not replace a Play-signed installation. Never uninstall merely to
bypass a certificate mismatch without first safely backing up local data.

Keep signing credentials and the key recoverable in a secure owner-controlled
backup. A future source-code change could alter configuration, so retain this
validation and verify release certificates as part of release review.

## Verification performed

- Release APK and AAB builds both succeeded.
- Both actual artifacts matched the pinned certificate above; APK signature
  verification passed. Package remains unchanged; version remains `1.0.1+3`.
- Guard task accepted the real local configuration and rejected temporary
  empty/invalid alias environment overrides. No local credentials were edited.
- Gradle dry runs confirmed both release entry points depend on the guard and
  `preDebugBuild` does not.
- `git diff --check` passed. No Dart files changed for this task; the Flutter
  unit/widget suite was not rerun for this Gradle-only change.
- Existing Firebase/Kotlin future-compatibility warnings remain unrelated.

APK SHA-256:
`59e426dd5b5f09c6ea381249942b28f814cd519ac1e826749a889a18121dc22e`

AAB SHA-256:
`d6bc41a8108c01ca967e3424424eb3c8494c516cdbe2c9427f522736e53bde38`
