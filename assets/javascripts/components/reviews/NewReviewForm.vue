<template>
  <div class="hero is-fullheight is-dark">
      <section>
        <div class="hero-body">
          <div id="new-complaint-form" class="container">
            <div id="stand-up" class="columns is-centered">
              <h1 class="has-text-white title is-1">Add A Review</h1>
            </div>
            <div class="columns is-centered">
              <div class="column is-8">
                <form action="/reviews" method="POST">
                  <input type="hidden" name="authenticity_token" v-model="csrf" />

                  <div class="field">
                    <label for="product" class="label has-text-white">Product</label>
                    <div class="control has-icons-left">
                      <input type="text" name="product" @keyup="checkIfReviewed" v-model="product"
                        placeholder="Enter the name of whatever you'd like to review." class="input" required>
                    </div>
                  </div>

                  <div>
                    <label for="rating" class="label has-text-white">Rating</label>
                    <input class="input" name="rating" type="number" v-model="rating" min="0.0" max="10.0" step=".1">
                    <input class="slider is-fullwidth is-large is-primary is-circle" v-model="rating" step=".1"
                      min="0.0" max="10.0" value="5.0" type="range">
                  </div>

                  <div class="field">
                    <label for="body" class="label has-text-white">Review</label>
                    <div class="control has-icons-left">
                      <textarea rows="8" class="textarea" name="body"
                        placeholder="What did you think of this product?" required></textarea>
                    </div>
                  </div>

                  <div class="field">
                    <label for="img_body" class="label has-text-white">Upload an Image</label>
                    <div class="file is-info has-name">
                      <label class="file-label">
                        <image-uploader
                          :debug="1"
                          :maxWidth="500"
                          :quality="1.0"
                          :autoRotate=true
                          outputFormat="verbose"
                          :preview=false
                          :className="['file-input', { 'file-input' : hasImage }]"
                          :capture="false"
                          accept="image/*"
                          @input="setImage"
                        ></image-uploader>
                        <span class="file-cta">
                          <span class="file-icon">
                            <i class="fas fa-upload"></i>
                          </span>
                          <span class="file-label">
                            Choose a file…
                          </span>
                        </span>
                        <span class="file-name" v-if="fileName">
                          {{fileName}}
                        </span>
                      </label>
                    </div>
                    <img :src="fileBodyFull" class="mt-3"/>
                    <input type="hidden" name="img_name" v-model="fileName" />
                    <input type="hidden" name="img_body" v-model="fileBody" />
                  </div>
                  

                  <div class="field">
                    <button class="button is-primary">
                      Post Review!
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
</template>

<script>
  import ImageUploader from 'vue-image-upload-resize';

  export default {
    components: {
      ImageUploader,
    },
    data() {
      return {
        csrf: document.querySelector('meta[name=_csrf]').content,
        product: '',
        rating: 5.0,
        hasImage: false,
        fileBody: '',
        fileName: '',
      };
    },
    methods: {
      checkIfReviewed() {
        console.log(this.product)
      },

      setImage(file) {
        this.hasImage = true;
        this.fileBodyFull = file['dataUrl'];
        this.fileBody = this.fileBodyFull.split("base64,")[1]
        this.fileName = (file['info'] || {})['name'];
      },

      // updateRating(val) {
      //   this.rating = Number(val)
      // }
    }
  }
</script>