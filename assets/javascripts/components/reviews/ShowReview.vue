<template>
  <section class="section">
    <article class="media is-10">
      <figure class="media-left">
        <p class="image is-500x500">
          <img :src="imgSrc">
        </p>
      </figure>
      <div class="media-content">
        <div class="content column is-10">
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
  export default {
    props: ['shown-review'],
    data() {
      return {
        csrf: document.querySelector('meta[name=_csrf]').content,
        imgSrc: '',
        review: {},
        placeholder: "https://via.placeholder.com/500",
      };
    },
    created() {
      try {
        this.review = JSON.parse(this.shownReview);
        this.imgSrc = this.getS3Image(this.review["photo_ids"][0]);
      } catch(err) {
        this.imgSrc = this.placeholder;
      }
    },
    methods: {
      getS3Image(id) {
        if (!id) { return this.placeholder }
        axios.get(`/photos/${id}`).then(response => {
          this.imgSrc = `data:image/png;base64, ${response.data.photo}`;
        }).catch(error => {
          this.imgSrc = this.placeholder;
        });
      }
    }
  }
</script>