# 質問
1. macOSに標準インストールされているApache httpdを利用するにはどうすればよいですか？
2. macOSのApache httpdでWebサーバーを起動・停止するには、どのようなコマンドを使用しますか？
3. macOSのApache httpdで、特定のディレクトリをWebサーバーのドキュメントルートとして設定するにはどうすればよいですか？

# 回答
**1. macOSに標準インストールされているApache httpdを利用するにはどうすればよいですか？**

まず、以下のコマンドを使ってApache httpdが実際にインストールされているか、そしてコントローラであるapachectlがインストールされているかを確認します。

*   **インストール確認（httpdのパス確認）:**
    `$ which httpd`
*   **コントローラ確認:**
    `$ which apachectl`

これらの確認が完了したら、開発するWEBサービスに合わせてコンテンツと設定を変更することで利用開始できます。

**2. macOSのApache httpdでWebサーバーを起動・停止するには、どのようなコマンドを使用しますか？**

Webサーバーの起動と停止には、`sudo`を付けて`apachectl`コマンドを使用します。

*   **起動:**
    `$ sudo /usr/sbin/apachectl start`
*   **停止:**
    `$ sudo /usr/sbin/apachectl stop`

**3. macOSのApache httpdで、特定のディレクトリをWebサーバーのドキュメントルートとして設定するにはどうすればよいですか？**

提供された文脈には、特定のディレクトリをWebサーバーのドキュメントルートとして設定するための具体的なコマンドや手順についての記述はありません。一般的には、「自身が開発するWEBサービスにあわせてコンテンツと設定を変更する」必要があります。

# Reference
[macOS に標準インストールされている Apache httpd を利用する方法 |](https://weblabo.oscasierra.net/apache-macos-usage/)
