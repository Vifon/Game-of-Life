<template>
  <div class="board">
    <div v-for="(_, y) in height"
         :key="`row-${y}`"
         class="row">
      <div v-for="(_, x) in width"
           :key="`col-${x}`"
           class="col"
           :class="{ alive: cells[idx(x,y)], dead: !cells[idx(x,y)] }"
           v-on:click="$emit('click', {index: idx(x,y)})"
      ></div>
    </div>
  </div>
</template>

<script>
 export default {
   name: 'GameBoard',
   props: ['cells', 'width', 'height'],
   methods: {
     idx: function (x, y) {
       return y * this.width + x;
     },
     flip: function (array, x, y) {
       var idx = this.idx(x,y);
       this[array][idx] = !this[array][idx];
     },
     countNeightbors: function (x, y) {
       var neighbors = 0;
       for (var dy = -1; dy <= 1; ++dy) {
         for (var dx = -1; dx <= 1; ++dx) {
           var nx = x + dx;
           var ny = y + dy;
           if (nx >= 0 && nx < this.width &&
               ny >= 0 && ny < this.height &&
               (dx != 0 || dy != 0)) {
             if (this.cells[this.idx(nx,ny)]) {
               ++neighbors;
             }
           }
         }
       }
       return neighbors;
     },
     isAlive: function (x, y) {
       var neighbors = this.countNeightbors(x,y);
       if (this.cells[this.idx(x,y)]) {
         return this.$root.survivalCondition.includes(neighbors);
       } else {
         return this.$root.birthCondition.includes(neighbors);
       }
     }
   }
 }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
 .alive {
   background-color: black;
 }
 .dead {
   background-color: white;
 }

 .board {
   display: flex;
   flex-direction: column;
   align-items: center;
 }
 .row {
   display: flex;
   flex-direction: row;
 }
 .col {
   min-width: 20px;
   width: 20px;
   height: 20px;
   border: 1px #eee solid;
 }
</style>
