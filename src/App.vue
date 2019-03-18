<template>
  <div>
    <game-board :cells="cells"
                :width="width"
                :height="height"
    >
    </game-board>

    <div class="controls"
         v-if="!edit">
      <input id="edit" name="edit" type="button" value="Edit"
             class="control"
             v-on:click="edit = true"
      />
    </div>
    <div v-else>
      <div class="controls">
        <input id="reseed" name="reseed" type="button" value="Reseed"
               class="control"
               v-on:click="reseed"
        />
        <condition-input ref="conditions" initial="23/3"
                         class="control"
        ></condition-input>
      </div>

      <game-board :cells="seed"
                  :width="width"
                  :height="height"
                  class="editable"
                  v-on:click="flip('seed', $event)"
      >
      </game-board>
    </div>
  </div>
</template>

<script>
 import ConditionInput from './components/ConditionInput.vue'
 import GameBoard from './components/GameBoard.vue'

 export default {
   name: 'app',
   components: {
     ConditionInput,
     GameBoard
   },
   data: function () {
     return {
       seed: undefined,
       height: undefined,
       width: undefined,
       edit: false,
       turnTime: 200,
       timer: undefined,
       cells: undefined
     }
   },
   methods: {
     idx: function (x, y) {
       return y * this.width + x;
     },
     flip: function (array, event) {
       this.$set(this[array], event.index, !this[array][event.index]);
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
         return this.survivalCondition.includes(neighbors);
       } else {
         return this.birthCondition.includes(neighbors);
       }
     },
     nextTurn: function () {
       var nextCells = new Array(this.cells.length);
       for (var y = 0; y < this.height; ++y) {
         for (var x = 0; x < this.width; ++x) {
           nextCells[this.idx(x,y)] = this.isAlive(x,y);
         }
       }
       this.cells = nextCells;
       this.timer = setTimeout(() => this.nextTurn(), this.turnTime);
     },
     reseed: function () {
       if (this.timer) {
         clearTimeout(this.timer);
       }

       if (!this.seed) {
         var textSeed = `
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ x _ _ _ x _ _ _ _ _ _
           _ _ _ _ _ _ x x x x x _ _ _ _ _ _
           _ _ _ _ _ _ _ x x x _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ x _ _ _ _ _ _ _ _
           _ _ _ _ _ _ x _ _ _ x _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
         `;
         this.seed = textSeed.split('')
                             .filter(cell =>
                               cell == '_' || cell == 'x')
                             .map(cell => cell == 'x');
         this.width = Math.sqrt(this.seed.length);
         this.height = this.width;
       }

       this.cells = this.seed;
       this.timer = setTimeout(() => this.nextTurn(), 1000);
     }
   },
   mounted: function () {
     this.reseed();
   },
   computed: {
     survivalCondition: function () {
       if (this.edit) {
         return this.$refs.conditions.value.survival;
       } else {
         return [2, 3];
       }
     },
     birthCondition: function () {
       if (this.edit) {
         return this.$refs.conditions.value.birth;
       } else {
         return [3];
       }
     }
   }
 }
</script>

<style>
 #app {
   font-family: 'Avenir', Helvetica, Arial, sans-serif;
   -webkit-font-smoothing: antialiased;
   -moz-osx-font-smoothing: grayscale;
   margin-top: 60px;
 }

 .controls {
   display: flex;
   justify-content: center;
 }
 .control {
   margin: 2px;
 }

 .editable {
   opacity: 0.7;
 }
</style>
