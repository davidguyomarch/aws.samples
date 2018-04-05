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

    <div :style="theme.section">
      <h2 :style="theme.h2">Sample Title</h2>
    </div>
  </div>
</template>

<script>
import { AmplifyTheme } from '../amplify'

export default {
  name: 'Home',
  data () {
    return {
      theme: AmplifyTheme
    }
  }
}
</script>
