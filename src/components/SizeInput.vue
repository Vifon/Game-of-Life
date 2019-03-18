<template>
  <div class="size-input">
    <input type="number" step="1"
           v-bind:value="value"
           v-on:input="$emit('input', parseInt($event.target.value))">
  </div>
</template>

<script>
 export default {
   name: 'SizeInput',
   props: ['value']
 }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
 input[type=text] {
   text-align: center;
 }
</style>
