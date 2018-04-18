/*
 * Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with
 * the License. A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions
 * and limitations under the License.
 */

<template>
  <div :style="theme.container">
    <h1 :style="theme.h1">
      Hicham Vue Sample
    </h1>
    <p> When you click on a button, I make a call to a Lambda function through API Gateway.
    </p>
    <button v-on:click="getGreetings">Test Simple Hello Call</button>
    <button v-on:click="getCount">Test a request to dynamodb db.</button>
    <div :style="theme.section">
      <h2 :style="theme.h2">Sample Title</h2>
    </div>
  </div>
</template>

<script>
import { AmplifyTheme } from '../amplify'
import { Auth, API } from 'aws-amplify'


export default {
  name: 'Home',
  data () {
    return {
      theme: AmplifyTheme
    }
  },
  methods: {
      signOut: function(event) {
          Auth.signOut()
              .then(data => {
                  logger.debug('sign out success', data);
                  AmplifyStore.commit('setUser', null);
                  this.$router.push('/auth/signIn');
              })
              .catch(err => logger.error('sign out error', err))
      },

      getGreetings: function () {
        let apiName = 'my-api';
        let path = '/hello';
        let myInit = { // OPTIONAL
          queryStringParameters: {
              hello: "david"
          },
          headers: {}, // OPTIONAL
          response: false // OPTIONAL (return entire response object instead of response.data)
        }

        API.get(apiName, path, myInit).then(response => {
            alert('Hello, ' + response.hello);
        });
      },

      getCount: function () {
        let apiName = 'my-api';
        let path = '/notes/count';
        let myInit = { // OPTIONAL
            headers: {}, // OPTIONAL
            response: true // OPTIONAL (return entire response object instead of response.data)
        }
        API.get(apiName, path, myInit).then(response => {
            alert('You have ' + response.data.count + 'notes.');
        });
      }
    }
}
</script>
