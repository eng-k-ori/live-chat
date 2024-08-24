<template>
  <div>
    <h1>{{ title }}</h1>
    <!-- コンポーネント間で受け渡しするデータをprops（プロップス）と呼びます。 -->
    <!-- @toggle="toggle"の@toggleは子コンポーネントのthis.$emit('toggle')に紐づいています。 -->
    <TestComponent @toggle="toggle" message="コンポーネントにデータが渡されています" />
    <p v-if="isEnabled">こんにちは</p>
  </div>
</template>

<script>
import TestComponent from '../components/TestComponent.vue'

export default {
  components: {
    TestComponent
  },
  data () {
    return {
      title: '初めてのVue.jsアプリです！',
      // ======= 👇 ここから変更する =======
      subtitle: 'ようこそ',
      isEnabled: true
      // ====== 👆 ここまで変更する =======
    }
  },
  computed: {
    text(){
      if(this.isEnabled){
        return 'true:こんにちは'
      } else {
        return 'false:さようなら'
      }
    }
  },
  methods: {
    toggle(){
      this.isEnabled = !this.isEnabled
    }
  }
}
</script>
<style scoped>
  p {
    font-size: 20px;
    color: red;
  }
</style>
