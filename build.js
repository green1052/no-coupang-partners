const fs = require("fs");
const {EOL} = require("os");

const REGEX = fs.readFileSync("./hosts.txt", "utf8")
    .split(EOL)
    .filter(host => host !== "" && !host.startsWith("#"))
    .join("|")
    .replaceAll(".", "\\.");

fs.writeFileSync(`filters-share/search.txt`, `google.*#?#:is(div#search, div#botstuff) div[data-async-context] div.g[data-ved]:-abp-contains(/${REGEX}/)
duckduckgo.com#?#div.results article:-abp-contains(/${REGEX}/)`, "utf8");
