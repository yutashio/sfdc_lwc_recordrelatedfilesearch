# Lightning Web コンポーネント(LWC)で添付ファイル検索コンポーネント作成してみた。  

## はじめに
Salesforce内のファイルを検索したい場合は、グローバル検索を使用しますよね！？  
グローバル検索もアップデートがあり、かなり便利になってきていますが、  
特定のレコードに関連するファイルの検索には今ひとつ...ということでLWCで作成してみました🔎  

## イメージ  
※検索条件・検索結果は、カスタム可能です。後ほど、紹介します！  
![イメージ](/docs/image_record_related_filesearch.png)  

## コンポーネントのセットアップ 
### まずは、コンポーネントの配置です。  
配置手順は下記2つ  
* Lightning アプリケーションビルダー  
  * 設定 → ユーザーインターフェース → Lightning アプリケーションビルダー  
    * 配置したいレコードページを編集して`recordRelatedFileSearch`コンポーネントをお好みの場所に配置。  
* 配置したいオブジェクトの「Lightning レコードページ」  
  * 設定 → オブジェクトマネージャー → 配置したいオブジェクト選択 → Lightning レコードページ  
    * 対象のレコードページを編集して`recordRelatedFileSearch`コンポーネントをお好みの場所に配置。  

※下記画像は、ホームページのLightning レコードページに`recordRelatedFileSearch`コンポーネントを配置しています。  
![セットアップ](/docs/placing_record_related_filesearch.png)  

* 配置したコンポーネントをクリックすると画面右側にメニューが表示されます。  
* こちらでコンポーネントのタイトルや、検索条件・検索結果のカスタムします。  
![カスタマイズ](/docs/setting_record_related_filesearch.png)  

### コンポーネントのタイトル・検索条件・検索結果のカスタム
タイトル・検索条件・検索結果のカスタムを設定することでコンポーネントの利用ができます。  

![カスタマイズ](/docs/settingimage_record_related_filesearch.png)  

|No|項目名|詳細|
|-|-|-|
|1|タイトル|入力した文字がコンポーネント右上にタイトルとして表示されます。|
|2|オブジェクトのAPI名|検索対象のファイルが保存されているオブジェクトのAPI参照名を入力します。<br>※指定できるオブジェクトの数は1個までです。|
|3|キーワード検索する項目のAPI名(複数の場合は,区切り)|No.2で指定したオブジェクトの中で、キーワード検索条件として使用する項目のAPI参照名を入力します。|
|4|チェックボックス項目のAPI名(複数の場合は,区切り)|No.2で指定したオブジェクトの検索条件として使用するチェックボックス項目のAPI参照名を入力します。|
|5|範囲検索する項目のAPI名(複数の場合は,区切り)|No.2で指定したオブジェクトで、範囲検索の条件として使用する項目のAPI参照名を入力します。|
|6|複数選択リスト項目のAPI名(複数の場合は,区切り)|No.2で指定したオブジェクトで、検索条件として使用する複数選択リスト項目のAPI参照名を入力します。|
|7|複数選択リスト項目デフォルト全選択|初期状態で値が全選択状態にしておきたい場合はチェックを付けます。|
|8|検索結果に追加で表示させる項目のAPI名(複数の場合は,区切り)|検索結果に追加で表示したい項目を入力します。<br>※固定で左から[ファイル名, サイズ, 拡張子, ファイル作成及び更新日, レコード名]が表示されています。|  

## 機能と特徴
### 複数の条件を組み合わせて効率的にファイルを検索できます。  
■ファイル自体に対する検索条件は固定で下記を使用できます。  
* ファイル名
  * キーワード検索
* ファイル拡張子
  * キーワード検索
* 作成日
  * 範囲検索

■ファイルの検索を行いたいオブジェクトと項目はカスタムできます。  
* キーワード検索
  * 使用可能な項目のデータ型
    * `ID,URL,TEXTAREA,STRING,EMAIL,PICKLIST,PHONE`
* チェックボックス検索
  * 使用可能な項目のデータ型
    * `BOOLEAN`
* 範囲検索
  * 使用可能な項目のデータ型
    * `INTEGER,DOUBLE,LONG,PERCENT,CURRENCY,DATETIME,DATE,TIME`
* 複数選択リスト検索
  * 使用可能な項目のデータ型
    * `MULTIPICKLIST`

> [!NOTE]
> キーワード検索は、それぞれの項目に対して「部分一致」「完全一致」を選択できます。  
> ![カスタマイズ](/docs/keyword_search.png)  

> [!NOTE]
> チェックボックス検索は、「なし」 「true」 「false」を選択できます。  
> ![カスタマイズ](/docs/checkbox.png)  

> [!IMPORTANT]
> 検索条件を入力しないで[Search]ボタンを押下した場合は、すべてのデータが検索対象となります。  
> ※チェックボックスは、「なし」の状態  
> ※複数選択リストは、「選択済み」欄が空の状態  

### 検索結果
* 左から **[ファイル名, サイズ, 拡張子, ファイル作成及び更新日, レコード名]** は固定表示  
* 固定で表示されている項目の「ファイル名」 「レコード名」はリンクになっています。  
> ![カスタマイズ](/docs/search_results.png)  

ファイル名のリンクをクリックした場合
> ![カスタマイズ](/docs/filename_link.png)  

レコード名のリンクをクリックした場合
> ![カスタマイズ](/docs/recordname_link.png)  

### 制限及び注意点
* 「ファイル名」項目は必須項目となっています。  
* 検索結果は、「ファイル作成及び更新日」の降順で表示されます。  
* 検索結果の表示は最大500件までとなっています。  

## ディレクトリ構成
```
force-app
    └─main
        └─default
            ├─classes
            │      RecordRelatedFileSearchController.cls
            │      RecordRelatedFileSearchController.cls-meta.xml
            │      RecordRelatedFileSearchControllerTest.cls
            │      RecordRelatedFileSearchControllerTest.cls-meta.xml
            │
            └─lwc
                └─recordRelatedFileSearch
                        recordRelatedFileSearch.css
                        recordRelatedFileSearch.html
                        recordRelatedFileSearch.js
                        recordRelatedFileSearch.js-meta.xml
```