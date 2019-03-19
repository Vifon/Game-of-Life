<template>
  <div class="board">
    <div v-for="(_, y) in height"
         :key="`row-${y}`"
         class="row">
      <div v-for="(_, x) in width"
           :key="`col-${x}`"
           class="col"
           :class="{ alive: cells[idx(x,y)], dead: !cells[idx(x,y)] }"
           v-on:mousedown="$emit('mousedown', {index: idx(x,y)})"
           v-on:mouseup="$emit('mouseup', {index: idx(x,y)})"
      ></div>
    </div>
  </div>
</template>

<script>
 export default {
   name: 'GameBoard',
   props: {
     seed: Array,
     conditions: Object
   },
   data: function () {
     return {
       cells: this.seed.slice(),
       width: Math.sqrt(this.seed.length),
       height: Math.sqrt(this.seed.length)
     }
   },
   methods: {
     idx: function (x, y) {
       return y * this.width + x;
     },
     flip: function (selection) {
       var xParams = [
         selection.start % this.width,
         selection.end % this.width
       ];
       var yParams = [
         Math.floor(selection.start / this.width),
         Math.floor(selection.end / this.width)
       ];
       var start = {
         x: Math.min(...xParams),
         y: Math.min(...yParams)
       };
       var end = {
         x: Math.max(...xParams),
         y: Math.max(...yParams)
       };

       for (var y = start.y; y <= end.y; ++y) {
         for (var x = start.x; x <= end.x; ++x) {
           this.$set(this.cells, this.idx(x,y), selection.value);
         }
       }
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
     willLive: function (x, y) {
       var neighbors = this.countNeightbors(x,y);

       if (this.cells[this.idx(x,y)]) {
         return this.conditions.survival.includes(neighbors);
       } else {
         return this.conditions.birth.includes(neighbors);
       }
     },
     nextTurn: function () {
       var nextCells = new Array(this.cells.length);
       for (var y = 0; y < this.height; ++y) {
         for (var x = 0; x < this.width; ++x) {
           nextCells[this.idx(x,y)] = this.willLive(x,y);
         }
       }
       this.cells = nextCells;
     },
     reseed: function (seed, width, height) {
       this.cells = seed;
       this.width = width;
       this.height = height;
     },
     resize: function(newWidth, newHeight) {
       var difference;
       if (newWidth !== null) {
         for (var y of Array(this.height).keys()) {
           var row = (this.height - y);
           if (newWidth > this.width) {
             this.cells.splice(
               row * this.width,
               0,
               ... new Array(newWidth - this.width).fill(false)
             );
           } else {
             difference = this.width - newWidth;
             this.cells.splice(
               row * this.width - difference,
               this.width - newWidth
             );
           }
         }
         this.width = newWidth;
       }
       if (newHeight !== null) {
         if (newHeight > this.height) {
           difference = newHeight - this.height;
           this.cells.splice(
             this.width * this.height,
             0,
             ... new Array(
               this.width * difference).fill(false)
           );
         } else {
           difference = this.height - newHeight;
           var size = this.height * this.width;
           var discardRowStart = size - this.width * difference;
           this.cells.splice(discardRowStart);
         }
         this.height = newHeight;
       }
     },
     clear: function() {
       this.cells = new Array(this.cells.length).fill(false);
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
   user-select: none;
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
