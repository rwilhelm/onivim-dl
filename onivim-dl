#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const os = require("os");
const util = require("util");
const fetch = require("node-fetch");
const streamPipeline = util.promisify(require("stream").pipeline);

const name = path.basename(__filename);
const cacheDir = `${os.homedir()}/.cache/${name}`;
require("dotenv").config({
  path: `${os.homedir()}/.config/${name}/licenseKey`,
});

const baseUrl = "https://www.onivim.io";
const key = "AIzaSyDxflsfyd2gloxgWJ-GFtPM46tz-TtOXh8";

/*
 * Validate license key
 */
async function isLicenseKeyValid(licenseKey) {
  // {{{
  let response = await fetch(
    `${baseUrl}/api/isLicenseKeyValid?licenseKey=${licenseKey}`
  );
  return await response.json();
} // }}}

/*
 * Handle vendor authentication
 */
async function authLicenseKey(licenseKey) {
  // {{{
  if (isLicenseKeyValid()) {
    let response = await fetch(
      `${baseUrl}/auth/licenseKey?licenseKey=${licenseKey}`
    );
    return await response.json();
  }
} // }}}

/*
 * Handle Google Identity Toolkit authentication
 */
async function verifyCustomToken(token) {
  // {{{
  let response = await fetch(
    `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${key}`,
    {
      body: `{
        "token": "${token}",
        "returnSecureToken": true,
      }`,
      method: "POST",
    }
  );
  return await response.json();
} // }}}

/*
 * Get Google Identity Toolkit account information
 */
async function getAccountInfo(idToken) {
  // {{{
  let response = await fetch(
    `https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=${key}`,
    {
      body: `{
        "idToken": "${idToken}",
      }`,
      method: "POST",
    }
  );

  return response.json();
} // }}}

/*
 * Get current release notes or latest commit id (HEAD).
 */
async function getReleaseNotes() {
  // {{{
  const response = await fetch(`${baseUrl}/api/getReleaseNotes`);
  return response.json();
} // }}}

/*
 * Get information about currently available downloads.
 * Requires authentication.
 */
async function getDownloads(token, branch) {
  // {{{
  let response = await fetch(
    `${baseUrl}/api/getDownloads?channel=${branch}&token=${token}`
  );
  return response.json();
} // }}}

/*
 * Authenticate or fail.
 */
async function auth() {
  // {{{
  let licenseKey = process.env.LICENSE_KEY;

  if (!licenseKey) {
    console.error(
      `Err: ~/.config/${name}/licenseKey must have\n` +
        `LICENSE_KEY=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
    );
    process.exit(1);
  }

  let { token } = await authLicenseKey(licenseKey);
  let { idToken } = await verifyCustomToken(token);
  if (!idToken) {
    console.error("Authenticating failed", {
      licenseKey,
      token,
      idToken,
    });
  }
  return idToken;
} // }}}

/*
 * Download Onivim.
 */
async function download({ branch, platform, shortCommitId, token, version }) {
  // {{{

  /* Create cache dir */
  if (!fs.existsSync(cacheDir)) {
    fs.mkdirSync(cacheDir, { recursive: true });
  }

  if (!platform || !branch || !token) {
    console.error({
      platform,
      branch,
      token,
    });
    process.exit(1);
  }

  /* Get release info */
  let releaseInfo = await getDownloads(token, branch);
  console.log(releaseInfo);

  /* Handle suprisingly different server respones (Wtf) */
  let url = releaseInfo.hasOwnProperty("artifacts")
    ? // Download from Google Storage
      releaseInfo.artifacts[platform].tar
    : // Download from Outrun Labs
      `https://v2.onivim.io/downloads/Onivim2-${platform}.tar.gz?channel=${branch}&token=${token}`;

  /* Local download filename */
  let filename = `${cacheDir}/Onivim2-${platform}-${branch}-${version}-${shortCommitId}.tar.gz`;

  if (fs.existsSync(filename)) {
    console.error("Already downloaded:", filename);
    process.exit(0);
  }

  /* Download */
  console.log({ filename, url: url.split(token.slice(0, 8))[0] + "..." });
  const response = await fetch(url);

  if (response.ok) {
    /* Save to file */
    streamPipeline(response.body, fs.createWriteStream(filename));
  }

  /* Symlink latest version for convenience */
  fs.symlink(filename, `${path.dirname(filename)}/latest`, () => {});
} // }}}

/*
 * Parse args and do the things
 */
function main() {
  argv = require("yargs")
    .command(
      "license",
      "Validate license key",
      () => {},
      async () => {
        (await isLicenseKeyValid(process.env.LICENSE_KEY))
          ? process.exit(0)
          : process.exit(1);
      }
    )
    .command(
      "cur",
      "Get current version",
      () => {},
      async ({ branch }) => {
        let idToken = await auth();
        let response = await getDownloads(idToken, branch);
        console.log(response);
      }
    )
    .command(
      "account",
      "Get user account info",
      () => {},
      async ({ branch }) => {
        let idToken = await auth();
        let { users } = await getAccountInfo(idToken, branch);
        console.log(users[0]);
      }
    )
    .command(
      "head",
      "Get latest commit",
      () => {},
      async () => {
        let { commitId } = await getReleaseNotes();
        console.log(commitId);
      }
    )
    .command(
      "download",
      "Download Onivim",
      () => {},
      async ({ platform, branch }) => {
        let idToken = await auth();
        await download({
          ...(await getDownloads(idToken, branch)),
          token: idToken,
          platform,
          branch,
        });
      }
    )
    .option("branch", {
      alias: "b",
      type: "string",
      description: "Select branch",
      default: "stable",
    })
    .option("platform", {
      alias: "p",
      type: "string",
      description: "Select platform",
      default: os.platform(),
    })
    .option("verbose", {
      alias: "v",
      type: "boolean",
      description: "Verbose output",
    }).argv;
}

main();
