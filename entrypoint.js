const fs = require('fs');
const path = require('path');
const config = require('config');
const nunjucks = require('nunjucks');

// Setup nunjucks
nunjucks.configure({ autoescape: true });
// Define client directory and files
const dir = path.resolve(__dirname, 'client', 'dist');
const templateFile = 'config.template.js';
const configFile = 'config.js';
// Initialize default nunjucks params
const params = {
  domain: 'http://localhost:3001',
};
// Update the domain value if possible
if (process.env.API_URL) {
  params.domain = process.env.API_URL;
} else if (config.domain) {
  params.domain = config.domain;
} else if (config.host) {
  params.domain = `${config.protocol || 'http'}://${config.host}`;
}
// Write changes to config.js file
fs.writeFileSync(
  path.join(dir, configFile),
  nunjucks.render(path.join(dir, templateFile), params),
);
// Run the formio server
require('./main');
