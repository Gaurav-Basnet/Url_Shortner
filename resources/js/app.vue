<template>
  <div class="p-4 max-w-md mx-auto">
    <h2 class="text-2xl font-bold mb-4">URL Shortener</h2>

    <!-- Input Field -->
    <input
      v-model="url"
      type="text"
      placeholder="Enter long URL"
      class="border p-2 w-full mb-2 rounded"
    />
    
    <!-- Shorten Button -->
    <button
      @click="shortenUrl"
      class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
    >
      Shorten
    </button>

    <!-- Display Success / Short URL -->
    <div v-if="shortUrl" class="mt-4 bg-green-100 p-3 rounded">
      <p>
        Short URL:
        <a :href="shortUrl" target="_blank" class="text-blue-600 underline">{{ shortUrl }}</a>
      </p>
      <button @click="copyUrl" class="mt-2 bg-gray-200 px-3 py-1 rounded hover:bg-gray-300">
        {{ copied ? 'Copied!' : 'Copy' }}
      </button>
    </div>

    <!-- Display Error -->
    <div v-if="error" class="mt-2 text-red-500">{{ error }}</div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      url: '',
      shortUrl: '',
      error: '',
      copied: false
    }
  },
  methods: {
    async shortenUrl() {
      this.error = '';
      this.shortUrl = '';
      this.copied = false;

      if (!this.url) {
        this.error = 'Please enter a URL.';
        return;
      }

      try {
        const response = await axios.post('/short', {
          original_url: this.url
        });

        this.shortUrl = response.data.short_url;
        this.url = ''; // clear input
      } catch (err) {
        // Laravel validation errors
        if (err.response?.data?.errors?.original_url) {
          this.error = err.response.data.errors.original_url[0];
        } else if (err.response?.data?.message) {
          this.error = err.response.data.message;
        } else {
          this.error = 'Something went wrong.';
        }
      }
    },

    copyUrl() {
      navigator.clipboard.writeText(this.shortUrl)
        .then(() => {
          this.copied = true;
        })
        .catch(() => {
          this.error = 'Failed to copy.';
        });
    }
  }
}
</script>

