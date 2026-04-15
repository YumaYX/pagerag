# 質問
1. macOSに標準インストールされているApache httpdを利用するには、どのような手順を踏むべきですか？
2. macOSの標準インストール版Apache httpdは、どのような機能が利用可能ですか？
3. macOSの標準インストール版Apache httpdを使用する際の注意点はありますか？

# 回答
**1. macOSに標準インストールされているApache httpdを利用するには、どのような手順を踏むべきですか？**

以下の手順を踏む必要があります。

1.  **存在の確認:** ターミナルを開き、`$ which httpd` および `$ which apachectl` コマンドを実行して、Apache httpd およびコントローラとなる apachectl がインストールされているかを確認します。
2.  **バージョン確認:** `$ /usr/sbin/httpd -version` のように、`httpd` コマンドに `-version` オプションを付けて実行し、インストールされているバージョンを確認します。
3.  **起動:** `sudo /usr/sbin/apachectl start` を実行して起動します。
4.  **停止:** `sudo /usr/sbin/apachectl stop` を実行して停止します。
5.  **自動起動の設定（オプション）:** macOSの再起動時にも自動的にバックグランドサービスとして起動させたい場合は、`sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist` コマンドで設定できます。

**2. macOSの標準インストール版Apache httpdは、どのような機能が利用可能ですか？**

*   **機能の利用:** 標準でインストールされており、起動・停止を行うことができます。
*   **状態の確認:** 起動し、ブラウザで `http://localhost` にアクセスすることで、「It works!」という初期画面が表示されることを確認できます。
*   **自動化:** macOSの起動・再起動時に自動的にバックグランドサービスとして起動するように設定（`launchctl` コマンドを使用）が可能です。

**3. macOSの標準インストール版Apache httpdを使用する際の注意点はありますか？**

*   **コンテンツと設定の変更:** 自身が開発するWEBサービスに利用する場合、コンテンツと設定を自身で変更する必要があります。
*   **プロキシ設定:** 「It works!」という画面を確認する際、プロキシの設定を行っている場合は、ネットワーク設定の「プロキシ設定を使用しないホストとドメイン」に `localhost` があることを確認する必要があります。

# Reference
[macOS に標準インストールされている Apache httpd を利用する方法 |](https://weblabo.oscasierra.net/apache-macos-usage/)
