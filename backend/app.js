const http = require("http");

http.createServer(function (request, response) {
    let url = new URL(request.url, `http://${request.headers.host}`);
    let path = url.pathname;
    let params = url.searchParams;
      
    console.log(path, JSON.stringify(params));

    switch(path) {

    }


    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end('');
}).listen(8080);