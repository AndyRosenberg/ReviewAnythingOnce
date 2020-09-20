<template>
  <section class="section">
    <article class="media is-10">
      <Photo :id="photo_id" />
      <div class="media-content">
        <div class="content column is-10">
          <a class="is-pulled-right button is-light" v-if="review.current" :href="editUrl">Edit Review</a>
          <h3 class="has-text-white">{{this.review.product}}</h3>
          <p class="has-text-white is-size-2 mb-3"><strong class="has-text-white">{{this.review.rating}}</strong> <small>out of</small> 10</p>
          <p>
            {{this.review.body}}
          </p>
        </div>
      </div>
    </article>
  </section>
</template>

<script>
  import axios from 'axios';
  import Photo from '../photos/Photo.vue';
  export default {
    props: ['shown-review'],
    components: { Photo },
    data() {
      return {
        review: {},
        photo_id: 0,
        editUrl: ""
      };
    },
    created() {
      this.review = JSON.parse(this.shownReview)
      this.photo_id = this.review["photo_ids"][0];
      if (this.review.current) {
        this.editUrl = `/reviews/${this.review.id}/edit`
      }
    }
  }
</script>