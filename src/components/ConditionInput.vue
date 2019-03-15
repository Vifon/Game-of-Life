<template>
  <div class="condition-input">
    <input type="text" v-model="raw_value" size=20>
  </div>
</template>

<script>
 export default {
   name: 'ConditionInput',
   props: {
     initial: String
   },
   data: function () {
     return {
       raw_value: this.initial
     };
   },
   computed: {
     value: function () {
       var stringToInts = s => s.split('').map(x => parseInt(x));

       var s = this.raw_value;
       var pos = s.indexOf('/');

       var [survival, birth] =
         [s.slice(0, pos), s.slice(pos+1)].map(stringToInts);
       return {
         survival: survival,
         birth: birth
       };
     }
   }
 }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
