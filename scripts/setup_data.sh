#!/usr/bin/env bash
# Download UrbanSound8K, verify it, and lay it out the way the course code expects.
#
# Usage: scripts/setup_data.sh [target_data_dir] [existing_archive]
#   target_data_dir   default: TF_PatternRecognition/data
#   existing_archive  skip the download and use this .tar.gz
#
# The URL is where the official download form's link resolves. The form was
# submitted on 2026-11-02, so the dataset terms (CC BY-NC) apply to this repo.
set -euo pipefail

URL="https://zenodo.org/records/1203745/files/UrbanSound8K.tar.gz"
MD5="9aa69802bbf37fb986f71ec1483a196e"
SIZE=6023741708
EXPECTED_WAVS=8732
MAX_ATTEMPTS=40

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATA="${1:-$ROOT/TF_PatternRecognition/data}"
ARCHIVE="${2:-$ROOT/downloads/UrbanSound8K.tar.gz}"

file_md5() {
  if command -v md5sum >/dev/null; then md5sum "$1" | cut -d' ' -f1; else md5 -q "$1"; fi
}
file_size() { wc -c < "$1" | tr -d ' '; }

download() {
  mkdir -p "$(dirname "$ARCHIVE")"
  local attempt
  for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
    # A stalled connection never fails on its own, so treat a slow minute as failure.
    curl -L -C - --fail --silent --show-error --connect-timeout 30 \
      --speed-limit 10240 --speed-time 60 -o "$ARCHIVE" "$URL" || true
    [ "$(file_size "$ARCHIVE")" -ge "$SIZE" ] && return 0
    echo "attempt $attempt: $(file_size "$ARCHIVE")/$SIZE bytes, resuming" >&2
  done
  echo "download incomplete after $MAX_ATTEMPTS attempts" >&2
  exit 1
}

if [ -d "$DATA/wav" ]; then
  echo "$DATA/wav already exists; remove it to reinstall" >&2
  exit 1
fi

[ -f "$ARCHIVE" ] && [ "$(file_size "$ARCHIVE")" -ge "$SIZE" ] || download

[ "$(file_md5 "$ARCHIVE")" = "$MD5" ] || { echo "checksum mismatch: $ARCHIVE" >&2; exit 1; }
echo "checksum ok"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/us8k.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
tar -xzf "$ARCHIVE" -C "$WORK"

mkdir -p "$DATA"
SRC="$WORK/UrbanSound8K"
chmod -R u+rwX "$SRC"
find "$SRC" -name .DS_Store -delete
mv "$SRC/audio" "$DATA/wav"
mv "$SRC/metadata/UrbanSound8K.csv" "$SRC/UrbanSound8K_README.txt" "$SRC/FREESOUNDCREDITS.txt" "$DATA/"

COUNT="$(find "$DATA/wav" -name '*.wav' | wc -l | tr -d ' ')"
[ "$COUNT" = "$EXPECTED_WAVS" ] || { echo "expected $EXPECTED_WAVS wavs, found $COUNT" >&2; exit 1; }
echo "installed $COUNT wav files in $DATA"
