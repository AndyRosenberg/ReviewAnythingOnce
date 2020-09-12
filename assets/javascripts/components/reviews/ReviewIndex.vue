<template>
  <div class="columns">
    <section class="section">
      <h1 class="is-size-1 mx-4 my-4 has-text-centered">Explore Reviews</h1>
      <div v-for="review of reviews" :key="review.id" class="mx-4 my-4">
        <article class="media is-vcentered">
          <Photo :id="review.id" type="review" small="true" />
          <div class="media-content">
            <div class="content column">
              <h4 class="has-text-white">{{review.product}}</h4>
              <p class="has-text-white is-size-4 mb-4"><strong class="has-text-white">{{review.rating}}</strong> <small>out of</small> 10</p>
              <p>
                {{review.body}}
              </p>
            </div>
          </div>
        </article>
      </div>
    </section>
  </div>
</template>

<script>
  import axios from 'axios';
  import Photo from '../photos/Photo.vue';
  export default {
    props: ['initial-reviews'],
    components: { Photo },
    data() {
      return {
        reviews: [],
        navigation: {},
        placeholder: "https://via.placeholder.com/150",
        imgSrc: '',
      };
    },

    created() {
      let pagination = JSON.parse(this.initialReviews);
      this.reviews = pagination.page;
      this.navigation = pagination.navigation;
    },

    methods: {
    }
  }
</script>