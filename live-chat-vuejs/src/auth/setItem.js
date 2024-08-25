const setItem = (headers, name) => {
  // 1 window.localStorage.setItem(キーの名前、情報)
  window.localStorage.setItem('access-token', headers['access-token'])
  window.localStorage.setItem('client', headers.client)
  window.localStorage.setItem('uid', headers.uid)
  window.localStorage.setItem('name', name)
}

export default setItem

/*
@          @@          @@          @@          @@          @@          @@          @@          @
1
window.localStorage.setItem('access-token', res.headers['access-token'])
**access-token**というプロパティ名が含まれている場合:
access-tokenは名前にハイフン（-）が含まれているので、ドット記法ではアクセスできない。
res.headers.access-tokenと書くとエラーが発生する。
代わりに、ブラケット記法を使ってres.headers['access-token']と書く必要がある。
------------------------------------------------------------------------------------------------
ドット記法 (.):
通常のプロパティにアクセスする方法。
例: res.headers.client で client という名前のプロパティにアクセスする。
------------------------------------------------------------------------------------------------
ブラケット記法 ([]):
プロパティ名に特定の文字（スペースやハイフン）が含まれている場合や、プロパティ名が動的に決まる場合に使う方法。
例: res.headers['access-token'] で access-token という名前のプロパティにアクセスする。
------------------------------------------------------------------------------------------------
ドット記法 (.) は簡単に使えるが、プロパティ名にハイフンなどの特殊な文字が含まれている場合には使えない。
ブラケット記法 ([]) は、プロパティ名にハイフンなどの特殊な文字が含まれている場合に使う。
res.headers['access-token']のように書けば、正しくデータにアクセスできる。
*/