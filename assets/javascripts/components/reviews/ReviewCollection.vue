<template>
  <section>
    <div v-for="review of reviews" :key="review.id" class="mx-4 my-4">
      <article class="media is-vcentered">
        <Photo :id="review.id" type="review" small="true" />
        <div class="media-content">
          <div class="content column">
            <h4 class="has-text-white">{{review.product}}</h4>
            <p class="has-text-white is-size-4 mb-4">
              <strong class="has-text-white">{{review.rating}}</strong> <small>out of</small> 10
            </p>
            <p>
              {{review.body}}
            </p>
          </div>
        </div>
      </article>
    </div>
  </section>
</template>

<script>
  import axios from 'axios';
  import Photo from '../photos/Photo.vue';
  export default {
    props: ['initial-reviews', 'api-url'],
    components: { Photo },

    data() {
      return {
        reviews: [],
        after: '',
        loading: false,
      };
    },

    created() {
      this.setPage(
        JSON.parse(this.initialReviews)
      );
    },

    mounted() {
      this.scroll();
    },

    methods: {
      setPage(pagination) {
        let navigation = pagination.navigation;
        this.reviews = this.reviews.concat(pagination.page);
        this.after = navigation.next_cursor;
      },

      scroll() {
        window.onscroll = () => {
          let bottomOfWindow = document.documentElement.scrollTop +
            window.innerHeight === document.documentElement.offsetHeight;
          if (!this.loading && bottomOfWindow && this.after) {
            this.addReviews();
          }
        };
      },

      addReviews() {
        this.loading = true;

        axios.get(this.apiUrl, {
          params: { after: this.after }
        }, {
          headers: { 'Accept': 'application/json' }
        }).then(response => {
          this.setPage(response.data);
        }).catch(err => {
          console.log(err);
        }).finally(() => {
          this.loading = false;
        })
      }
    }
  }
</script>