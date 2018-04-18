const dynamoDbLib = require("./dynamodb-lib.js");

async function list (userId) {
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
      ":userId": userId
    }
  };
  const result = await dynamoDbLib.call("query", params);
  return result.Items;
}

async function count (userId) {
  var params = {
      TableName: "notes",
      KeyConditionExpression: "userId = :userId",
      ExpressionAttributeValues: {
        ":userId": userId
      },
      Select: 'COUNT'
  };
  const nb = await dynamoDbLib.call("query", params);
//  console.log('Received count:', JSON.stringify(nb, null, 2));
  console.log('-->Notes.count returned: ', nb.Count);
  return nb.Count;
}

module.exports.list = list;
module.exports.count = count;
