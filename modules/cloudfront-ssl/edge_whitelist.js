
exports.handler = (event, context, callback) => {
   
    const request = event.Records[0].cf.request;
    const headers = request.headers;
    const customHeaders = request.origin.custom.customHeaders;

    var whiteList = "none";
    if(customHeaders["allow-referer"] !== undefined)
    {
        whiteList = customHeaders["allow-referer"][0].value;
    }

    var referer ='undefined';
    if(headers["referer"] !== undefined)
    {
        referer= headers["referer"][0].value;
    }
        
    if (!whiteList.includes(referer)) {
        const response = {
            status: "200",
            statusDescription: "Content Blocked"
          };  
          callback(null, response); 
    } 
    else 
    {     
        //   Allow request to continue as intended
        callback(null, request);
    }
};