<template>
  <div class="columns">
    <section class="section">
      <h1 class="is-size-1 mx-4 my-4 has-text-centered">Explore Reviews</h1>
      <ReviewCollection :initial-reviews="initialReviews" api-url="/reviews/api" />
    </section>
  </div>
</template>

<script>
  import ReviewCollection from './ReviewCollection.vue';
  export default {
    props: ['initial-reviews'],
    components: { ReviewCollection }
  }
</script>