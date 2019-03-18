<template>
  <div class="condition-input">
    <input type="text" size=20
           :value="asString"
           v-on:input="$emit('input', asObject($event.target.value))"
    >
  </div>
</template>

<script>
 export default {
   name: 'ConditionInput',
   props: {
     value: Object
   },
   data: function () {
     return {
       asString: (this.value.survival.join("")
                + "/"
                + this.value.birth.join(""))
     };
   },
   methods: {
     asObject: function (str) {
       var stringToInts = s => s.split('').map(x => parseInt(x));

       var pos = str.indexOf('/');

       var [survival, birth] =
         [str.slice(0, pos), str.slice(pos+1)].map(stringToInts);
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
 input[type=text] {
   text-align: center;
 }
</style>
