const fs = require("fs");
const {EOL} = require("os");

const REGEX = fs.readFileSync("./hosts.txt", "utf8")
    .split(EOL)
    .filter(host => host !== "" && !host.startsWith("#"))
    .join("|")
    .replaceAll(".", "\\.");

fs.writeFileSync(`filters-share/search.txt`, `google.*#?#div[role="main"] div#search div[data-async-context] div.g[data-hveid]:-abp-contains(/${REGEX}/)
duckduckgo.com#?#div.results article:-abp-contains(/${REGEX}/)`, "utf8");
