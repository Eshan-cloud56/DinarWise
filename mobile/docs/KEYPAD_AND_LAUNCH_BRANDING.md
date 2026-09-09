# Expense keypad and launch branding

- Existing keypad moved immediately after amount, before category and merchant.
  Input parsing, decimal/backspace behavior, validation and saving are unchanged.
- Approved icon: `stitch_dinarwise_gcc_fintech_redesign (4).zip/screen.png`.
  Original is bundled as `assets/branding/launcher-approved.png`; legacy mipmaps
  are density-resized copies. Adaptive resources use the original transparent
  artwork, a green gradient background, and 21% safe foreground insets.
- Opening source: `stitch_dinarwise_gcc_fintech_redesign (3).zip/code.html`.
  This archive has CSS/SVG animation and a screenshot, not a video.
  Flutter CustomPainter reproduces its D paths, badge, gold star, orbit and
  progressive reveal without a webview or network. Duration is 2.6 seconds.
  The square emblem scales uniformly. The bilingual wordmark wraps responsively.
  Mock status bar, unverified certification/banking claims and fictitious vault
  synchronization text are deliberately not included.
- The old MP4/poster are no longer referenced by startup or bundled in pubspec.
  Original source files remain in the repository for history.
- Firebase initialization, the bootstrap completion callback, onboarding routing,
  financial repositories and SQLite schema are unchanged.

## Verification

Widget tests cover immediate keypad visibility on a 360×640 English/Arabic
viewport, every digit, decimal, backspace, income entry, existing transfer
fallback, unchanged transaction saving, and launch completion exactly once.
Existing 320px/200%-text tests remain. Device-level launcher masks, cold-start
handoff, system bars, animation frame pacing and installation compatibility
still need checking on Samsung hardware. No device was connected during this run.

Do not uninstall an existing app to resolve a debug-signature conflict:
uninstalling can remove local financial records.
