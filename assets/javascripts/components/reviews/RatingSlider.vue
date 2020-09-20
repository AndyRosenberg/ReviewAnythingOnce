<template>
  <div>
    <label for="rating" class="label has-text-white">Rating</label>
    <input class="input" name="rating" type="number" v-model="rating" min="0.0" max="10.0" step=".1" @change="ensureFloat">
    <input class="slider is-fullwidth is-large is-primary is-circle" v-model="rating" step=".1"
      min="0.0" max="10.0" value="5.0" type="range" @change="ensureFloat">
  </div>
</template>

<script>
  export default {
    props: ['initialRating'],
    data() {
      return {
        rating: this.initialRating
      }
    },
    methods: {
      ensureFloat() {
        let newRating = parseFloat(this.rating).toFixed(1);
        
        if (newRating === "NaN" || newRating <= 0) {
          this.rating = "0.0"
        } else if (newRating > 10) {
          this.rating = "10.0"
        } else {
          this.rating = newRating.toString();
        }
      },
    }
  }
</script>