<template>
  <div class="columns">
    <section class="section">
      <h1 class="is-size-1 mx-4 my-4 has-text-centered">{{user.name}}'s profile</h1>
      <ReviewCollection :initial-reviews="reviewsJson" :api-url="apiUrl" />
    </section>
  </div>
</template>

<script>
  import ReviewCollection from '../reviews/ReviewCollection.vue';
  export default {
    props: ['user-json', 'reviews-json'],
    components: { ReviewCollection },

    computed: {
      apiUrl() {
        return `/users/${this.user.id}/reviews`
      }
    },
    
    data() {
      return {
        user: JSON.parse(this.userJson)
      }
    }
  }
</script>