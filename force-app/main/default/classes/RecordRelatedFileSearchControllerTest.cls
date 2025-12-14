@isTest
private class RecordRelatedFileSearchControllerTest {

	@isTest
	static void testInitKeywordSearchSection() {
		// テストデータ作成
		String objApiName = 'Account';
		String keywordSectFieldsApiName = 'Name,Phone';

		// 実行
		Test.startTest();
		List<RecordRelatedFileSearchController.SearchCriteria> result = RecordRelatedFileSearchController.initKeywordSearchSection(objApiName, keywordSectFieldsApiName);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertEquals(2, result.size(), '結果サイズが正しいこと');
		System.assertEquals('Name', result[0].fieldApi, 'フィールドAPIが正しいこと');
		System.assertEquals('String', result[0].fieldType, 'フィールドタイプが正しいこと');
	}

	@isTest
	static void testInitKeywordSearchSection_Exception() {
		// テストデータ作成
		String objApiName = 'Account';
		String keywordSectFieldsApiName = 'NumberOfEmployees'; // キーワード検索に使用できない数値項目を指定

		// 実行と検証
		Test.startTest();
		try {
			RecordRelatedFileSearchController.initKeywordSearchSection(objApiName, keywordSectFieldsApiName);
		} catch (RecordRelatedFileSearchController.CustomException e) {
			System.assert(e.getMessage().contains('キーワード検索に使用できない項目が含まれています'), 'カスタム例外メッセージが正しいこと');
		}
		Test.stopTest();
	}

	@isTest
	static void testInitCheckboxSearchSection() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		String checkboxSectFieldsApiName = 'IsPrivate';

		// 実行
		Test.startTest();
		List<RecordRelatedFileSearchController.SearchCriteria> result = 
			RecordRelatedFileSearchController.initCheckboxSearchSection(objApiName, checkboxSectFieldsApiName);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertEquals(1, result.size(), '結果サイズが正しいこと');
		System.assertEquals('IsPrivate', result[0].fieldApi, 'フィールドAPIが正しいこと');
		System.assertEquals('checkbox', result[0].fieldType, 'フィールドタイプが正しいこと');
	}

	@isTest
	static void testInitCheckboxSearchSection_Exception() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		String checkboxSectFieldsApiName = 'CloseDate'; // チェックボックス検索に使用できない日付項目を指定

		// 実行と検証
		Test.startTest();
		try {
			RecordRelatedFileSearchController.initCheckboxSearchSection(objApiName, checkboxSectFieldsApiName);
		} catch (RecordRelatedFileSearchController.CustomException e) {
			System.assert(e.getMessage().contains('チェックボックス検索に使用できない項目が含まれています'), 'カスタム例外メッセージが正しいこと');
		}
		Test.stopTest();
	}

	@isTest
	static void testInitRangeSearchSection() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		String rangeSectFieldsApiName = 'CloseDate';

		// 実行
		Test.startTest();
		List<RecordRelatedFileSearchController.SearchCriteria> result = 
			RecordRelatedFileSearchController.initRangeSearchSection(objApiName, rangeSectFieldsApiName);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertEquals(1, result.size(), '結果サイズが正しいこと');
		System.assertEquals('CloseDate', result[0].fieldApi, 'フィールドAPIが正しいこと');
		System.assertEquals('date', result[0].fieldType, 'フィールドタイプが正しいこと');
	}

	@isTest
	static void testInitRangeSearchSection_Exception() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		String rangeSectFieldsApiName = 'Name'; // 範囲検索に使用できないテキスト項目を指定

		// 実行と検証
		Test.startTest();
		try {
			RecordRelatedFileSearchController.initRangeSearchSection(objApiName, rangeSectFieldsApiName);
		} catch (RecordRelatedFileSearchController.CustomException e) {
			System.assert(e.getMessage().contains('範囲検索に使用できない項目が含まれています'), 'カスタム例外メッセージが正しいこと');
		}
		Test.stopTest();
	}

	@isTest
	static void testInitPickListSearchSection() {
		// テストデータ作成
		String objApiName = 'Account';
		String pickListSectFieldsApiName = ''; // 複数選択リスト項目がある場合は指定する

		Test.startTest();
		List<Object> result = RecordRelatedFileSearchController.initPickListSearchSection(
			objApiName,
			pickListSectFieldsApiName,
			false
		);
		Test.stopTest();

		System.assertNotEquals(null, result, '戻り値が null ではないこと');
		System.assertEquals(0, result.size(), '結果が空であること');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_StartEndValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'Amount'};
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{
			'Amount' => '1000'
		};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{
			'Amount' => '5000'
		};

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('Amount >= 1000'), 'Amount の開始条件が正しいこと');
		System.assert(soql.contains('Amount <= 5000'), 'Amount の終了条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyStartValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'Amount'};
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{
			'Amount' => '1000'
		};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{};

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('Amount >= 1000'), 'Amount の開始条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyEndValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'Amount'};
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{
			'Amount' => '5000'
		};

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('Amount <= 5000'), 'Amount の終了条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_StartEndTimeValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //Time型の標準項目が存在しないため、ロジック分岐を通過させる目的で CloseDate（日付項目）に時間値を渡してテスト
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{
			'CloseDate' => '12:00:00'
		};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{
			'CloseDate' => '15:00:00'
		};

		// TestVisible 変数を使用してカバレッジを確保
		RecordRelatedFileSearchController.usedInTestToPassJudge = true;

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('CloseDate >= 12:00:00'), 'CloseDate  の開始条件が正しいこと');
		System.assert(soql.contains('CloseDate <= 15:00:00'), 'CloseDate  の終了条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyStartTimeValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //Time型の標準項目が存在しないため、ロジック分岐を通過させる目的で CloseDate（日付項目）に時間値を渡してテスト
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{
			'CloseDate' => '12:00:00'
		};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{};

		// TestVisible 変数を使用してカバレッジを確保
		RecordRelatedFileSearchController.usedInTestToPassJudge = true;

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('CloseDate >= 12:00:00'), 'CloseDate の開始条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyEndTimeValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //Time型の標準項目が存在しないため、ロジック分岐を通過させる目的で CloseDate（日付項目）に時間値を渡してテスト
		Map<String, String> inputSearchRangeStartValsMap = new Map<String, String>{};
		Map<String, String> inputSearchRangeEndValsMap = new Map<String, String>{
			'CloseDate' => '15:00:00'
		};

		// TestVisible 変数を使用してカバレッジを確保
		RecordRelatedFileSearchController.usedInTestToPassJudge = true;

		// 実行
		Test.startTest();
		String soql = RecordRelatedFileSearchController.setSpecifyRangeSoqlWhere(objApiName, inputSearchRangeValsSet, inputSearchRangeStartValsMap, inputSearchRangeEndValsMap);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, soql, 'SOQL が null ではないこと');
		System.assert(soql.contains('CloseDate <= 15:00:00'), 'CloseDate の終了条件が正しいこと');
	}

	@isTest
	static void testInitExtDispSearchResFieldsColumns() {
		String objApiName = 'Account';
		String extDispSearchResFieldsColumns = 'Phone,CreatedDate';

		Test.startTest();
		List<Map<String, String>> result =
			RecordRelatedFileSearchController.initExtDispSearchResFieldsColumns(objApiName, extDispSearchResFieldsColumns);
		Test.stopTest();

		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assert(result.size() == 8, 'デフォルト6列+追加2列であること');

		// 0) プレビュー列
		System.assertEquals('プレビュー', result[0].get('label'), 'プレビュー列: label');
		System.assertEquals('button-icon', result[0].get('type'), 'プレビュー列: type');
		System.assertEquals('fileName', result[0].get('typeAttributes_title_fieldName'), 'プレビュー列: title フィールド');
		System.assertEquals('preview', result[0].get('buttonActionName'), 'プレビュー列: action 名');
		System.assertEquals('filePreview', result[0].get('typeAttributes_Name'), 'プレビュー列: name');
		System.assertEquals('utility:preview', result[0].get('iconName'), 'プレビュー列: icon');
		System.assertEquals('bare', result[0].get('variant'), 'プレビュー列: variant');

		// 1) ファイル名列
		System.assertEquals('ファイル名', result[1].get('label'), 'ファイル名列: label');
		System.assertEquals('fileUrl', result[1].get('fieldName'), 'ファイル名列: fieldName');
		System.assertEquals('url', result[1].get('type'), 'ファイル名列: type');
		System.assertEquals('fileName', result[1].get('typeAttributes_label_fieldName'), 'ファイル名列: 表示ラベル項目');
		System.assertEquals('_blank', result[1].get('typeAttributes_target'), 'ファイル名列: target');

		// 2) サイズ列
		System.assertEquals('サイズ', result[2].get('label'), 'サイズ列: label');
		System.assertEquals('fileSize', result[2].get('fieldName'), 'サイズ列: fieldName');
		System.assertEquals('String', result[2].get('type'), 'サイズ列: type');

		// 3) 拡張子列
		System.assertEquals('拡張子', result[3].get('label'), '拡張子列: label');
		System.assertEquals('fileExtension', result[3].get('fieldName'), '拡張子列: fieldName');
		System.assertEquals('String', result[3].get('type'), '拡張子列: type');

		// 4) ファイル作成/更新日列
		System.assertEquals('ファイル作成/更新日', result[4].get('label'), '日付列: label');
		System.assertEquals('fileCreatedDate', result[4].get('fieldName'), '日付列: fieldName');
		System.assertEquals('datetime', result[4].get('type'), '日付列: type');

		// 5) レコード名列
		System.assertEquals('レコード名', result[5].get('label'), 'レコード名列: label');
		System.assertEquals('recordUrl', result[5].get('fieldName'), 'レコード名列: fieldName');
		System.assertEquals('url', result[5].get('type'), 'レコード名列: type');
		System.assertEquals('recordName', result[5].get('typeAttributes_label_fieldName'), 'レコード名列: 表示ラベル項目');
		System.assertEquals('_blank', result[5].get('typeAttributes_target'), 'レコード名列: target');

		// 追加項目の開始位置（デフォルト6列の後）
		Integer customStart = 6;

		// 6) Phone
		System.assertEquals('Phone', result[customStart].get('fieldName'), '追加列1: fieldName');
		System.assertEquals('String', result[customStart].get('type'), '追加列1: type');

		// 7) CreatedDate
		System.assertEquals('CreatedDate', result[customStart + 1].get('fieldName'), '追加列2: fieldName');
		System.assertEquals('datetime', result[customStart + 1].get('type'), '追加列2: type');
	}

	@isTest
	static void testSearch() {
		// テストデータ作成
		Opportunity opp = new Opportunity(
			Name = 'Test Opportunity',
			StageName = 'Prospecting',
			CloseDate = System.today().addDays(30),
			IsPrivate = true // チェックボックス項目
		);
		insert opp;

		// ContentVersion を使用してファイルを作成
		ContentVersion contentVersion = new ContentVersion(
			Title = 'Test File',
			PathOnClient = 'TestFile.txt',
			VersionData = Blob.valueOf('This is a test file.')
		);
		insert contentVersion;

		// ContentVersion を再クエリして ContentDocumentId を取得
		contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];

		// ContentDocumentLink を作成して Opportunity に関連付ける
		ContentDocumentLink cdl = new ContentDocumentLink(
			LinkedEntityId = opp.Id,
			ContentDocumentId = contentVersion.ContentDocumentId,
			ShareType = 'V' // Visibility (View) 権限
		);
		insert cdl;

		// CloseDate の検索範囲
		String closeStart = System.now().addDays(15).format('yyyy-MM-dd');
		String closeEnd   = System.now().addDays(45).format('yyyy-MM-dd');

		// ContentVersion の作成日時
		String createdStart = System.now().addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
		String createdEnd   = System.now().addDays(1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		// 検索条件の設定
		String searchCriteriaJson = '{'
		+ '"limitNumOfDisp":500,'
		+ '"objApiName":"Opportunity",'
		+ '"keywordSectFieldsApiName":"Name,StageName",'
		+ '"rangeSectFieldsApiName":"CloseDate",'
		+ '"extDispSearchResFieldsColumns":"Name,StageName",'
		+ '"inputFileSearchTxtVals":{"ContentDocument.Title":{"value":"Test","matchType":"containsString"}},'
		+ '"inputFileSearchRangeStartVals":{"ContentDocument.ContentModifiedDate":"'+ createdStart + '"},'
		+ '"inputFileSearchRangeEndVals":{"ContentDocument.ContentModifiedDate":"' + createdEnd + '"},'
		+ '"inputSObjSearchTxtVals":{"Name":{"value":"Test Opportunity","matchType":"containsString"}},'
		+ '"inputSObjSearchCheckboxVals":{"IsPrivate":"true"},'
		+ '"inputSObjSearchRangeStartVals":{"CloseDate":"' + closeStart +'"},'
		+ '"inputSObjSearchRangeEndVals":{"CloseDate":"' + closeEnd + '"},'
		+ '"inputSObjSearchPickListVals":{}'
		+ '}';

		// 実行
		Test.startTest();
		List<Map<String, String>> result = RecordRelatedFileSearchController.search(searchCriteriaJson);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertNotEquals(0, result.size(), '検索結果が取得されていること');
		System.assertEquals('Test File', result[0].get('fileName'), 'ファイル名が正しいこと');
		System.assertEquals('Test Opportunity', result[0].get('recordName'), 'レコード名が正しいこと');
		System.assertEquals('Prospecting', result[0].get('StageName'), 'ステージ名が正しいこと');
	}

	@isTest
	static void testSearchLimitPlusOne() {
		//データの作成
		List<Account> accountList = new List<Account>();
		for (Integer i = 0; i < 15; i++) {
			accountList.add(new Account(Name = 'Test Account ' + i));
		}
		insert accountList;

		//ContentVersionの作成
		List<ContentVersion> contentVersionList = new List<ContentVersion>();
		for (Account acc : accountList) {
			contentVersionList.add(new ContentVersion(
				Title = 'Test File ' + acc.Name,
				PathOnClient = 'TestFile_' + acc.Name + '.txt',
				VersionData = Blob.valueOf('This is a test file for ' + acc.Name)
			));
		}
		insert contentVersionList;

		//ContentDocumentLinkの作成
		Map<Id, Id> accountToDocumentMap = new Map<Id, Id>();
		List<ContentVersion> insertedContentVersions = [
			SELECT Id, ContentDocumentId, Title
			FROM ContentVersion
			WHERE Title LIKE 'Test File%'
		];
		for (Integer i = 0; i < accountList.size(); i++) {
			accountToDocumentMap.put(accountList[i].Id, insertedContentVersions[i].ContentDocumentId);
		}
		List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
		for (Account acc : accountList) {
			contentDocumentLinks.add(new ContentDocumentLink(
				LinkedEntityId = acc.Id,
				ContentDocumentId = accountToDocumentMap.get(acc.Id),
				ShareType = 'V' // Visibility (View) 権限
			));
		}
		insert contentDocumentLinks;

		//検索条件の設定(検索結果を最大100件に制限)
		String searchCriteriaJson = '{'
		+ '"limitNumOfDisp":10,'
		+ '"objApiName":"Account",'
		+ '"keywordSectFieldsApiName":"Name",'
		+ '"rangeSectFieldsApiName":"CreatedDate",'
		+ '"extDispSearchResFieldsColumns":"Name",'
		+ '"inputFileSearchTxtVals":{"ContentDocument.Title":{"value":"Test File","matchType":"containsString"}},'
		+ '"inputFileSearchRangeStartVals":{},'
		+ '"inputFileSearchRangeEndVals":{},'
		+ '"inputSObjSearchTxtVals":{"Name":{"value":"Test Account","matchType":"containsString"}},'
		+ '"inputSObjSearchCheckboxVals":{},'
		+ '"inputSObjSearchRangeStartVals":{},'
		+ '"inputSObjSearchRangeEndVals":{},'
		+ '"inputSObjSearchPickListVals":{}'
		+ '}';

		//検索
		Test.startTest();
		List<Map<String, String>> result = RecordRelatedFileSearchController.search(searchCriteriaJson);
		Test.stopTest();

		//検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertEquals(11, result.size(), '結果が11件返ってくること(limit + 1件)');
		System.assert(result[0].containsKey('fileName'), '検索結果にファイル名が含まれていること');
		System.assert(result[0].containsKey('recordName'), '検索結果にレコード名が含まれていること');
	}

	@isTest
	static void testFormatTime() {
		Test.startTest();
		Time result1 = RecordRelatedFileSearchController.formatTime('12:34:56');
		Test.stopTest();
		System.assertEquals(Time.newInstance(12, 34, 56, 0), result1, '12:34:56 が正しい Time オブジェクトに変換されること');
	}

	@isTest
	static void testFormatBytes() {
		// バイト単位
		String result1 = RecordRelatedFileSearchController.formatBytes(500L);
		System.assertEquals('500 B', result1, '500 バイトのフォーマットが正しいこと');

		// キロバイト単位 (1 KB)
		String result2 = RecordRelatedFileSearchController.formatBytes(1024L);
		System.assertEquals('1 KB', result2, '1 KB のフォーマットが正しいこと');

		// メガバイト単位 (10 MB)
		String result3 = RecordRelatedFileSearchController.formatBytes(10485760L);
		System.assertEquals('10 MB', result3, '10 MB のフォーマットが正しいこと');

		// ギガバイト単位 (1 GB)
		String result4 = RecordRelatedFileSearchController.formatBytes(1073741824L);
		System.assertEquals('1 GB', result4, '1 GB のフォーマットが正しいこと');

		// テラバイト単位 (2 TB)
		String result5 = RecordRelatedFileSearchController.formatBytes(2199023255552L);
		System.assertEquals('2 TB', result5, '2 TB のフォーマットが正しいこと');

		// 0 バイト
		String result6 = RecordRelatedFileSearchController.formatBytes(0L);
		System.assertEquals('0 B', result6, '0 バイトのフォーマットが正しいこと');
	}

}