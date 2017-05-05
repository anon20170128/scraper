var system = require('system');
var args = system.args;
var url = https://www.lancastercountyreportingcenters.com/drug-testing/;

if(args.length > 1) {
	url = url.concat('page/', args[1]);
}

console.log('url: ', url);

var page = require('webpage').create();
page.open(url, function(status) {
  if(status === "success") {
    var content=page.content;
    console.log(content);
  } else {
    console.log('Page failed to load');
  }
  phantom.exit();
});
