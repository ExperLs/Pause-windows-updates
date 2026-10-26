# Pause-windows-updates
Pause Windows Updates until 2040. More info in README
# Pause Windows Update until 2040 (experimental)

A small Windows batch script that attempts to set Windows Update pause-related registry values so that the displayed pause expiry is **1 January 2040**.

> **Important:** This uses internal/undocumented Windows Update settings. It is not an officially supported way to pause updates until 2040, and it may be ignored or reset by Windows. The displayed date, if shown, does not prove that every update mechanism is paused. Use at your own risk.

## What the script does

- Requests administrator privileges through UAC.
- Attempts to export `HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings` to `WindowsUpdate-backup.reg` on the current user's Desktop.
- Writes pause-related values for general, feature, and quality updates, plus `FlightSettingsMaxPauseDays`.
- Tells you to restart Windows and check Settings → Windows Update.

## What it does not do

- It does not delete system files.
- It does not disable the Windows Update service.
- It does not guarantee that updates remain paused until 2040.
- It does not automatically restore the original registry settings if a write fails.

## Usage

1. Download `PauseUpdatesUntil2040.bat`.
2. Run it and approve the administrator prompt.
3. Restart the PC and check **Settings → Windows Update**.
4. If the pause date is not shown as expected, assume the method is not supported by your Windows build; do not rely on it for long-term update blocking.

## Backup and recovery

The script attempts to create `WindowsUpdate-backup.reg` on the Desktop. If that file was created, it can be imported by double-clicking it or running `reg import "path\to\WindowsUpdate-backup.reg"` from an elevated terminal. This restores values present in the exported file, but it may **not remove new values** that were added by the script and were absent from the backup. Inspect the registry changes before attempting manual cleanup.

## Compatibility

Not guaranteed across Windows 11 versions or future updates. No comprehensive compatibility testing is claimed.
