#!/usr/bin/env node
// Cross-platform launcher for hdcd-telegram.
// Downloads the binary on first run, then spawns it with inherited stdio.

import { execFileSync, execSync, spawn } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, writeFileSync, copyFileSync, chmodSync, rmSync, readdirSync, statSync } from "node:fs";
import { join, dirname } from "node:path";
import { platform, arch, tmpdir, homedir } from "node:os";

const VERSION = "v0.1.3";
const REPO = "gohyperdev/hdcd-telegram";

const dataDir = process.env.CLAUDE_PLUGIN_DATA || join(homedir(), ".claude", "plugins", "data", "hdcd-telegram");
const isWin = platform() === "win32";
const binaryName = isWin ? "hdcd-telegram.exe" : "hdcd-telegram";
const binary = join(dataDir, binaryName);
const versionFile = join(dataDir, ".version");

function needsInstall() {
  if (!existsSync(binary)) return true;
  if (!existsSync(versionFile)) return true;
  return readFileSync(versionFile, "utf8").trim() !== VERSION;
}

function detectPlatform() {
  const os = platform();
  const cpu = arch();

  const plat = os === "darwin" ? "macos" : os === "linux" ? "linux" : os === "win32" ? "windows" : null;
  if (!plat) throw new Error(`Unsupported OS: ${os}`);

  const archLabel = (cpu === "x64" || cpu === "x86_64") ? "amd64" : (cpu === "arm64" || cpu === "aarch64") ? "arm64" : null;
  if (!archLabel) throw new Error(`Unsupported architecture: ${cpu}`);

  return { plat, archLabel };
}

function findFile(dir, name) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    try {
      const s = statSync(full);
      if (s.isFile() && entry === name) return full;
      if (s.isDirectory()) {
        const found = findFile(full, name);
        if (found) return found;
      }
    } catch { /* skip unreadable entries */ }
  }
  return null;
}

function install() {
  const { plat, archLabel } = detectPlatform();
  const ext = plat === "windows" ? "zip" : "tar.gz";
  const archiveName = `hdcd-telegram-${VERSION}-${plat}-${archLabel}.${ext}`;
  const url = `https://github.com/${REPO}/releases/download/${VERSION}/${archiveName}`;

  mkdirSync(dataDir, { recursive: true });

  const tmp = join(tmpdir(), `hdcd-setup-${Date.now()}`);
  mkdirSync(tmp, { recursive: true });

  try {
    process.stderr.write(`Downloading hdcd-telegram ${VERSION} for ${plat}-${archLabel}...\n`);

    const archivePath = join(tmp, `archive.${ext}`);

    if (isWin) {
      execSync(`powershell -Command "Invoke-WebRequest -Uri '${url}' -OutFile '${archivePath}' -UseBasicParsing"`, { stdio: "pipe" });
    } else {
      execFileSync("curl", ["-fsSL", "-o", archivePath, url], { stdio: "pipe" });
    }

    const extractDir = join(tmp, "extracted");
    mkdirSync(extractDir, { recursive: true });

    if (ext === "zip") {
      execSync(`powershell -Command "Expand-Archive -Path '${archivePath}' -DestinationPath '${extractDir}' -Force"`, { stdio: "pipe" });
    } else {
      execFileSync("tar", ["xzf", archivePath, "-C", extractDir], { stdio: "pipe" });
    }

    const found = findFile(extractDir, binaryName);
    if (!found) throw new Error("Binary not found in archive");

    copyFileSync(found, binary);
    if (!isWin) chmodSync(binary, 0o755);
    writeFileSync(versionFile, VERSION);

    process.stderr.write(`hdcd-telegram ${VERSION} installed to ${binary}\n`);
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
}

// Main
if (needsInstall()) install();

const child = spawn(binary, process.argv.slice(2), { stdio: "inherit" });
child.on("exit", (code) => process.exit(code ?? 1));
child.on("error", (err) => {
  process.stderr.write(`Failed to start hdcd-telegram: ${err.message}\n`);
  process.exit(1);
});
