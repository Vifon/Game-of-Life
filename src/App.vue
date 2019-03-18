<template>
  <div>
    <game-board :seed="seed"
                :conditions="conditions"
                ref="game"
    >
    </game-board>

    <div class="controls"
         v-show="!edit">
      <input id="edit" name="edit" type="button" value="Edit"
             class="control"
             v-on:click="edit = true"
      />
    </div>
    <div v-show="edit">
      <div class="controls">
        <input id="reseed" name="reseed" type="button" value="Reseed"
               class="control"
               v-on:click="reseed"
        />
        <condition-input ref="conditions"
                         v-model="conditions"
                         class="control"
        ></condition-input>
      </div>

      <game-board :seed="seed"
                  ref="seed"
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
       conditions: {
         birth: [3],
         survival: [2, 3]
       },
       edit: false,
       turnTime: 200,
       timer: null
     }
   },
   methods: {
     flip: function (array, event) {
       this.$refs.seed.flip(event.index);
     },
     nextTurn: function () {
       this.$refs.game.nextTurn();
       this.timer = setTimeout(() => this.nextTurn(), this.turnTime);
     },
     reseed: function () {
       if (this.timer) {
         clearTimeout(this.timer);
       }

       this.$refs.game.reseed(
         this.$refs.seed.cells,
         this.$refs.seed.width,
         this.$refs.seed.height
       );

       this.timer = setTimeout(() => this.nextTurn(), 1000);
     }
   },
   created: function () {
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
   },
   mounted: function () {
     this.reseed();
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
