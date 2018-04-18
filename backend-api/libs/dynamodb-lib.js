const AWS = require("aws-sdk");

// AWS.config.update({ region: "eu-central-1" });

function call(action, params) {
  const dynamoDb = new AWS.DynamoDB.DocumentClient();
  return dynamoDb[action](params).promise();
}
module.exports.call = call;
