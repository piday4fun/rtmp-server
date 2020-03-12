const http = require("http");
const querystring = require('querystring');

http.createServer(function (request, response) {
    let url = new URL(request.url, `http://${request.headers.host}`);
    let path = url.pathname;
    let search = url.search;
    let params = querystring.decode(search.slice(1));
      
    console.log(path, JSON.stringify(params));

    switch(path) {

    }


    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end('');
}).listen(8080);