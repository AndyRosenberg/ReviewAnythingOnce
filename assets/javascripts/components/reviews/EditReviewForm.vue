<template>
  <section class="section">
    <form :action="action" method="POST" ref="deleteForm">
      <input type="hidden" name="authenticity_token" v-model="csrf" />
      <input type="hidden" name="_method" value="DELETE" />
      <button @click.prevent.stop="confirmDelete" class="is-pulled-right button is-light">Delete Review</button>
    </form>
    <form :action="action" method="POST">
      <input type="hidden" name="authenticity_token" v-model="csrf" />
      <input type="hidden" name="_method" value="PUT" />
      <div class="columns is-centered">
        <div class="content column is-10">
          <h2 class="has-text-white has-text-centered">Editing: <b>{{this.review.product}}</b></h2>
          <RatingSlider :initialRating="review.rating" />
          <div class="field">
            <label for="body" class="label has-text-white">Review</label>
            <div class="control has-icons-left">
              <textarea rows="8" class="textarea" name="body"
                v-model="review.body"></textarea>
            </div>
          </div>
          <div class="field">
            <button class="button is-primary">
              Post Updated Review!
            </button>
          </div>
        </div>
      </div>
    </form>
  </section>
</template>

<script>
  import axios from 'axios';
  import Photo from '../photos/Photo.vue';
  import RatingSlider from './RatingSlider.vue';
  export default {
    props: ['edited-review'],
    components: { RatingSlider },
    data() {
      return {
        csrf: document.querySelector('meta[name=_csrf]').content,
        review: {},
        action: "",
      };
    },
    created() {
      this.review = JSON.parse(this.editedReview)
      this.action = `/reviews/${this.review.id}`
    },
    methods: {
      confirmDelete() {
        if (confirm("Are you sure you want to delete this review?")) {
          this.$refs.deleteForm.submit();
        }
      }
    }
  }
</script>