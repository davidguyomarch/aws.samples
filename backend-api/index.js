const resp = require("./libs/response-lib.js");
const uuid = require("uuid");
const dynamoDbLib = require("./libs/dynamodb-lib.js");
const Notes = require("./libs/Notes.js");

exports.hello = function(event, context, callback) {
//  console.log('Received event:', JSON.stringify(event, null, 2));
  //event.queryStringParameters.name;
  if ((event.queryStringParameters === undefined)||(event.queryStringParameters.hello === undefined)) {
    callback(null, resp.failure({"error": "invalid input"}));
    return;
  }
  var name = event.queryStringParameters.hello;
  const responseBody = {
    "hello": name
  };
  callback(null, resp.success(responseBody));
}

exports.list = async function (event, context, callback) {
  if ((event.queryStringParameters === undefined)||(event.queryStringParameters.userId === undefined)) {
    callback(null, resp.failure({"error": "invalid input"}));
    return;
  }
  const params = {
    TableName: "notes",
    // 'KeyConditionExpression' defines the condition for the query
    // - 'userId = :userId': only return items with matching 'userId'
    // partition key
    // 'ExpressionAttributeValues' defines the value in the condition
    // - ':userId': defines 'userId' to be Identity Pool identity id
    // of the authenticated user
    KeyConditionExpression: "userId = :userId",
    ExpressionAttributeValues: {
//      ":userId": event.requestContext.identity.cognitoIdentityId
      ":userId": event.queryStringParameters.userId
    }
  };
  try {
    const result = await dynamoDbLib.call("query", params);
    // Return the matching list of items in response body
    callback(null, resp.success(result.Items));
  } catch (e) {
    callback(null, resp.failure({
      status: false
    }));
  }
}

exports.create = async function (event, context, callback) {
  const data = JSON.parse(event.body);
  const params = {
    TableName: "notes",
    Item: {
      userId: event.requestContext.identity.cognitoIdentityId,
//      userId: event.queryStringParameters.userId,
      noteId: uuid.v1(),
      content: data.content,
      createdAt: new Date().getTime()
    }
  };
  try {
    await dynamoDbLib.call("put", params);
    callback(null, resp.success(params.Item));
  } catch (e) {
    console.log(e);
    callback(null, resp.failure({
      status: false
    }));
  }
}

exports.count = async function (event, context, callback) {
  console.log(" - Notes.count (" + JSON.stringify(event) + ")");
  if ((event.requestContext === undefined)||(event.requestContext.identity === undefined)||(event.requestContext.identity.cognitoIdentityId === undefined)) {
    callback(null, resp.failure({"error": "invalid input"}));
    return;
  }
  const userId = event.requestContext.identity.cognitoIdentityId; //event.queryStringParameters.userId;
  if (userId==null) {
    callback(null, resp.failure({"error": "you must provide a Cognito Id to access this resource"}));
    return;
  }
  console.log(" - userId is a ('" + (userId==null) + "')");

  try {
    console.log(" - Calling Notes.count('" + userId + "')");
    const result = await Notes.count(userId);
    console.log(" --> Getting " + JSON.stringify(result, null, 2));
    callback(null, resp.success({
      'count': result
    }));
  } catch (e) {
    console.log(e);
    callback(null, resp.failure({
      status: false
    }));
  }
}
