<template>
    <figure class="media-left">
      <p class="image" :class="small ? 'is-250x250' : 'is-500x500'">
        <img :src="imgSrc">
      </p>
    </figure>
</template>

<script>
  import axios from 'axios';
  export default {
    props: ['id', 'type', 'small'],
    data() {
      return {
        placeholder: "https://via.placeholder.com/500",
        imgSrc: '',
      };
    },

    created() {
      this.getS3Image(this.id, this.type);
    },

    methods: {
      getS3Image(id, type) {
        if (!id) { return this.setPlaceHolder() }
        axios.get(
          this.setUrl(id,type)
        ).then(response => {
          this.imgSrc = `data:image/png;base64, ${response.data.photo}`;
        }).catch(error => {
          this.setPlaceHolder();
        });
      },

      setPlaceHolder() {
        this.imgSrc = this.placeholder;
      },

      setUrl(id, type) {
        if (type) {
          return `/photos/by_type/${type}/${id}`
        } else {
          return `/photos/${id}`
        }
      }
    }
  }
</script>