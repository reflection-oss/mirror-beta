#!/usr/bin/env bash
set -euo pipefail

# Keep the release, wheel names, and checksums in sync when publishing a beta.
main() (
  local release='v0.1.0'
  local wheel checksum tmp uv_bin actual

  case "$(uname -s)-$(uname -m)" in
    Darwin-arm64)
      if (( $(sw_vers -productVersion | cut -d. -f1) < 15 )); then
        echo 'Mirror requires macOS 15 or newer.' >&2
        return 1
      fi
      wheel='mirror-0.1.0-py3-none-macosx_15_0_arm64.whl'
      checksum='893e2d941b70939408fc080a5a3f43cf423f103eb4d1a9863b638d181b9fff38'
      ;;
    Linux-x86_64)
      wheel='mirror-0.1.0-py3-none-manylinux_2_28_x86_64.whl'
      checksum='8568d408a3aa0c60a469294021e8d6cbc1675b8bd9b68e4a88327f9652490254'
      ;;
    Linux-aarch64)
      wheel='mirror-0.1.0-py3-none-manylinux_2_28_aarch64.whl'
      checksum='bee426fbd3b2be2d1e0e9b2adc62001c1c896cb535590b1903d2e539aa5d8cc3'
      ;;
    *)
      echo 'Mirror supports macOS 15+ on Apple Silicon and Linux on x86-64 or ARM64.' >&2
      echo 'Check https://github.com/reflection-oss/mirror-beta/releases for other platforms.' >&2
      return 1
      ;;
  esac

  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  echo "Downloading Mirror ($release)..."
  curl --fail --silent --show-error --location \
    "https://github.com/reflection-oss/mirror-beta/releases/download/$release/$wheel" \
    --output "$tmp/$wheel"
  if command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$tmp/$wheel")
  else
    actual=$(shasum -a 256 "$tmp/$wheel")
  fi
  if [[ "${actual%% *}" != "$checksum" ]]; then
    echo 'Wheel checksum mismatch; refusing to install.' >&2
    return 1
  fi

  if command -v uv >/dev/null 2>&1; then
    uv_bin=$(command -v uv)
  else
    echo 'Installing uv...'
    curl --fail --silent --show-error --location \
      https://astral.sh/uv/install.sh --output "$tmp/uv-install.sh"
    UV_INSTALL_DIR="$HOME/.local/bin" UV_NO_MODIFY_PATH=1 sh "$tmp/uv-install.sh"
    uv_bin="$HOME/.local/bin/uv"
  fi

  "$uv_bin" tool install --python 3.12 --force "$tmp/$wheel"
  "$uv_bin" tool update-shell
  echo 'Mirror installed. Restart your shell if needed, then run mirror in your project.'
)

# Read the full script before starting installation when piped into bash.
main "$@"
