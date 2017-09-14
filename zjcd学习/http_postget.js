// var  http = require('http');
// var querystring = require('querystring')
// var postData = querystring.stringify({
//   cmd: 10086
// });
//
// var options = {
//   hostname:'10.0.6.18',
//   port: 63333,
//   path: '/',
//   method: 'POST',
//   headers: {
//     'Content-Type': 'application/x-www-form-urlencoded',
//     'Content-Length': Buffer.byteLength(postData)
//   }
// };
//
// var req = http.request(options, (res) => {
//   // console.log(`STATUS: ${res.statusCode}`);
//   // console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
//   res.setEncoding('utf8');
//   res.on('data', (chunk) => {
//     // console.log(`BODY: ${chunk}`);
//     console.log(JSON.parse(chunk).repo);
//   });
//   res.on('end', () => {
//     // console.log('No more data in response.');
//   });
// });
//
// req.on('error', (e) => {
//   console.log(`problem with request: ${e.message}`);
// });
//
// // write data to request body
// req.write(postData);
// req.end();
var request = require('request');

request.post({
  url:'http://10.0.6.18:63333/',

form: {

cmd: 10086}

},
function(err,httpResponse,body){

console.log(body);
if(err){
  console.log(err);
}

})
\
var request = require('request');
request.get({url:'http://127.0.0.1:3999/hello', form: {key:'value'}}, 
function(err,httpResponse,body){ 

if(err){
  console.log(err);
 }
console.log(body);

})