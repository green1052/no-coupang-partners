const fs = require("fs");
const {EOL} = require("os");

const REGEX = fs.readFileSync("./hosts.txt", "utf8").split(EOL).join("|");

fs.writeFileSync(`filters-share/search.txt`, `google.*#?#div[role="main"] div#search div[data-async-context] div[data-hveid]:-abp-contains(/${REGEX}/)
duckduckgo.com#?#div.result:-abp-contains(/${REGEX}/)`, "utf8");