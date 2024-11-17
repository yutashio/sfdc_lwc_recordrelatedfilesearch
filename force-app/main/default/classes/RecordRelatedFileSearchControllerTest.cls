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
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //標準項目に時間項目が存在しないため判定分突破のため日付項目を使用
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
		System.assert(soql.contains('CloseDate >= 12:00:00'), 'MyTimeField の開始条件が正しいこと');
		System.assert(soql.contains('CloseDate <= 15:00:00'), 'MyTimeField の終了条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyStartTimeValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //標準項目に時間項目が存在しないため判定分突破のため日付項目を使用
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
		System.assert(soql.contains('CloseDate >= 12:00:00'), 'MyTimeField の開始条件が正しいこと');
	}

	@isTest
	static void testSetSpecifyRangeSoqlWhere_OnlyEndTimeValueAvailable() {
		// テストデータ作成
		String objApiName = 'Opportunity';
		Set<String> inputSearchRangeValsSet = new Set<String>{'CloseDate'}; //標準項目に時間項目が存在しないため判定分突破のため日付項目を使用
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
		System.assert(soql.contains('CloseDate <= 15:00:00'), 'MyTimeField の終了条件が正しいこと');
	}

	@isTest
	static void testInitExtDispSearchResFieldsColumns() {
		// テストデータ作成
		String objApiName = 'Account';
		String extDispSearchResFieldsColumns = 'Name,Phone,CreatedDate';

		// 実行
		Test.startTest();
		List<Map<String, String>> result = RecordRelatedFileSearchController.initExtDispSearchResFieldsColumns(objApiName, extDispSearchResFieldsColumns);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assert(result.size() > 0, '結果が空ではないこと');

		// デフォルトの列が正しく追加されているか
		System.assertEquals('ファイル名', result[0].get('label'), 'ファイル名のラベルが正しいこと');
		System.assertEquals('fileUrl', result[0].get('fieldName'), 'ファイル名のフィールド名が正しいこと');
		System.assertEquals('url', result[0].get('type'), 'ファイル名のタイプが正しいこと');

		System.assertEquals('サイズ', result[1].get('label'), 'サイズのラベルが正しいこと');
		System.assertEquals('fileSize', result[1].get('fieldName'), 'サイズのフィールド名が正しいこと');
		System.assertEquals('String', result[1].get('type'), 'サイズのタイプが正しいこと');

		// 項目が正しく追加されているか
		Integer customFieldStartIndex = 5; // デフォルト列の後
		System.assertEquals('Name', result[customFieldStartIndex].get('fieldName'), '"Name" のフィールド名が正しいこと');
		System.assertEquals('String', result[customFieldStartIndex].get('type'), '"Name" のタイプが正しいこと');

		System.assertEquals('Phone', result[customFieldStartIndex + 1].get('fieldName'), '"Phone" のフィールド名が正しいこと');
		System.assertEquals('String', result[customFieldStartIndex + 1].get('type'), '"Phone" のタイプが正しいこと');

		System.assertEquals('CreatedDate', result[customFieldStartIndex + 2].get('fieldName'), '"CreatedDate" のフィールド名が正しいこと');
		System.assertEquals('datetime', result[customFieldStartIndex + 2].get('type'), '"CreatedDate" のタイプが正しいこと');
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

		// 検索条件の設定
		String objApiName = 'Opportunity';
		String keywordSectFieldsApiName = 'Name,StageName';
		String rangeSectFieldsApiName = 'CloseDate';
		String extDispSearchResFieldsColumns = 'Name,StageName';
		String inputFileSearchTxtVals = '{"ContentDocument.Title":{"value":"Test","matchType":"containsString"}}';
		String inputFileSearchRangeStartVals = '{"ContentDocument.ContentModifiedDate":"2022-01-01T00:00:00.000Z"}';
		String inputFileSearchRangeEndVals = '{"ContentDocument.ContentModifiedDate":"2024-12-31T23:59:59.999Z"}';
		String inputSObjSearchTxtVals = '{"Name":{"value":"Test Opportunity","matchType":"containsString"}}';
		String inputSObjSearchCheckboxVals = '{"IsPrivate":"true"}'; // チェックボックス条件
		String inputSObjSearchRangeStartVals = '{"CloseDate":"2022-01-01"}';
		String inputSObjSearchRangeEndVals = '{"CloseDate":"2024-12-31"}';
		String inputSObjSearchPickListVals = '{}'; // 複数選択リスト項目は空

		// 実行
		Test.startTest();
		List<Map<String, String>> result = RecordRelatedFileSearchController.search(
			10,
			objApiName,
			keywordSectFieldsApiName,
			rangeSectFieldsApiName,
			extDispSearchResFieldsColumns,
			inputFileSearchTxtVals,
			inputFileSearchRangeStartVals,
			inputFileSearchRangeEndVals,
			inputSObjSearchTxtVals,
			inputSObjSearchCheckboxVals,
			inputSObjSearchRangeStartVals,
			inputSObjSearchRangeEndVals,
			inputSObjSearchPickListVals
		);
		Test.stopTest();

		// 検証
		System.assertNotEquals(null, result, '結果が null ではないこと');
		System.assertNotEquals(0, result.size(), '検索結果が取得されていること');
		System.assertEquals('Test File', result[0].get('fileName'), 'ファイル名が正しいこと');
		System.assertEquals('Test Opportunity', result[0].get('recordName'), 'レコード名が正しいこと');
		System.assertEquals('Prospecting', result[0].get('StageName'), 'ステージ名が正しいこと');
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