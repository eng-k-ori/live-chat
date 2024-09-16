<template>
  <div>
    これはコンポーネントから表示されています。
    <!-- ======= 👇 ここから追加する ======= -->
    <p>{{ message }}</p>
    <button @click="onClick">親メソッドを実行するボタン</button>
  </div>
</template>

<!-- ======= 👇 ここから追加する ======= -->
<script>
export default {
  props: ['message'],
  methods: {
    onClick() {
      // $emit:親コンポーネントのメソッドを実行
      this.$emit('toggle')
    }
  }
}
</script>
<!-- ====== 👆 ここまで追加する ======= -->
