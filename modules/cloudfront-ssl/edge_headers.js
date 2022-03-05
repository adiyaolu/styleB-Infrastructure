
exports.handler = (event, context, callback) => {
   
    const response = event.Records[0].cf.response;
	const request = event.Records[0].cf.request;
    const headers = response.headers;

  //  response.removeHeader('Server');


    headers['strict-transport-security'] = [{key: 'Strict-Transport-Security', value: 'max-age= 63072000; includeSubdomains; preload'}];
    headers['x-frame-options'] = [{key: 'X-Frame-Options', value: 'DENY'}];
    headers['x-xss-protection'] = [{key: 'X-XSS-Protection', value: '1; mode=block'}];
    headers['x-content-type-options'] = [{key: 'X-Content-Type-Options', value: 'nosniff'}]; 
	
    // More details on. Cache-Control can be found here
    // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control		

    headers['cache-control'] = [{key: 'Cache-Control', value:  'public, max-age=15552000' }]; 

    //  More details on. CSP can be found here 
    //   https://developers.google.com/web/fundamentals/security/csp

    //   headers['content-security-policy'] = [{key: 'Content-Security-Policy', value: "default-src 'none' style-src 'self' 'unsafe-inline';"}];


    callback(null, response);
};