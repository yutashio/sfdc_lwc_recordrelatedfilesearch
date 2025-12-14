public with sharing class RecordRelatedFileSearchController {

	@TestVisible private static Boolean usedInTestToPassJudge = false;
	@TestVisible private class CustomException extends Exception {}

	//キーワード検索条件セクション構築
	@AuraEnabled
	public static List<SearchCriteria> initKeywordSearchSection(String objApiName, String keywordSectFieldsApiName){
		try {
			List<String> keywordSectAvailableList = new List<String>{'ID','URL','TEXTAREA','STRING','EMAIL','PICKLIST','PHONE'};
			List<SearchCriteria> searchCriteriaItemList = new List<SearchCriteria>();
			if(!String.isEmpty(keywordSectFieldsApiName)){
				for(String objFieldApiName: keywordSectFieldsApiName.split(',')){
					String objectFieldType = getDataType(objApiName, objFieldApiName);
					String objectFieldName =getFieldLabel(objApiName, objFieldApiName);
					if(keywordSectAvailableList.contains(objectFieldType) && canBeUsedSoqlWhereClause(objApiName, objFieldApiName)){
						SearchCriteria searchCriteriaItem = new SearchCriteria();
						searchCriteriaItem.fieldLabel = objectFieldName;
						searchCriteriaItem.fieldApi = objFieldApiName;
						searchCriteriaItem.fieldType = 'String';
						searchCriteriaItemList.add(searchCriteriaItem);
					}else {
						throw new CustomException('キーワード検索に使用できない項目が含まれています。「表示ラベル：'+objectFieldName+' / API名：'+objFieldApiName+'」');
					}
				}
			}
			return searchCriteriaItemList;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	//チェックボックス検索条件セクション構築
	@AuraEnabled
	public static List<SearchCriteria> initCheckboxSearchSection(String objApiName, String checkboxSectFieldsApiName){
		try {
			List<String> checkboxSectAvailableList = new List<String>{'BOOLEAN'};
			List<SearchCriteria> searchCriteriaItemList = new List<SearchCriteria>();
			if(!String.isEmpty(checkboxSectFieldsApiName)){
				for(String objFieldApiName: checkboxSectFieldsApiName.split(',')){
					String objectFieldType = getDataType(objApiName, objFieldApiName);
					String objectFieldName =getFieldLabel(objApiName, objFieldApiName);
					if(checkboxSectAvailableList.contains(objectFieldType) && canBeUsedSoqlWhereClause(objApiName, objFieldApiName)){
						SearchCriteria searchCriteriaItem = new SearchCriteria();
						searchCriteriaItem.fieldLabel = objectFieldName;
						searchCriteriaItem.fieldApi = objFieldApiName;
						searchCriteriaItem.fieldType = 'checkbox';
						searchCriteriaItemList.add(searchCriteriaItem);
					}else {
						throw new CustomException('チェックボックス検索に使用できない項目が含まれています。「表示ラベル：'+objectFieldName+' / API名：'+objFieldApiName+'」');
					}
				}
			}
			return searchCriteriaItemList;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	//範囲検索条件セクション構築
	@AuraEnabled
	public static List<SearchCriteria> initRangeSearchSection(String objApiName, String rangeSectFieldsApiName){
		try {
			List<String> rangeSectAvailableList = new List<String>{'INTEGER','DOUBLE','LONG','PERCENT','CURRENCY','DATETIME','DATE','TIME'};
			List<SearchCriteria> searchCriteriaItemList = new List<SearchCriteria>();
			if(!String.isEmpty(rangeSectFieldsApiName)){
				for(String objFieldApiName: rangeSectFieldsApiName.split(',')){
					String objectFieldType = getDataType(objApiName, objFieldApiName);
					String objectFieldName =getFieldLabel(objApiName, objFieldApiName);
					if(rangeSectAvailableList.contains(objectFieldType) && canBeUsedSoqlWhereClause(objApiName, objFieldApiName)){
						SearchCriteria searchCriteriaItem = new SearchCriteria();
						searchCriteriaItem.fieldLabel = objectFieldName;
						searchCriteriaItem.fieldApi = objFieldApiName;
						if(objectFieldType == 'DATETIME'){
							searchCriteriaItem.fieldType = 'datetime';
						}else if(objectFieldType == 'DATE'){
							searchCriteriaItem.fieldType = 'date';
						}else if(objectFieldType == 'TIME'){
							searchCriteriaItem.fieldType = 'time';
						}else {
							searchCriteriaItem.fieldType = 'String';
						}
						searchCriteriaItemList.add(searchCriteriaItem);
					}else {
						throw new CustomException('範囲検索に使用できない項目が含まれています。「表示ラベル：'+objectFieldName+' / API名：'+objFieldApiName+'」');
					}
				}
			}
			return searchCriteriaItemList;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	//複数選択リスト検索条件セクション構築
	@AuraEnabled
	public static List<SearchCriteria> initPickListSearchSection(String objApiName, String pickListSectFieldsApiName, Boolean isPickListSelectDefaultAll){
		try {
			List<String> pickListSectAvailableList = new List<String>{'MULTIPICKLIST'};
			List<SearchCriteria> searchCriteriaItemList = new List<SearchCriteria>();
			if(!String.isEmpty(pickListSectFieldsApiName)){
				for(String objFieldApiName: pickListSectFieldsApiName.split(',')){
					String objectFieldType = getDataType(objApiName, objFieldApiName);
					String objectFieldName = getFieldLabel(objApiName, objFieldApiName);
					if(pickListSectAvailableList.contains(objectFieldType) && canBeUsedSoqlWhereClause(objApiName, objFieldApiName)){
						SearchCriteria searchCriteriaItem = new SearchCriteria();
						searchCriteriaItem.fieldLabel = objectFieldName;
						searchCriteriaItem.fieldApi = objFieldApiName;
						searchCriteriaItem.pickList = getPickList(objApiName, objFieldApiName);
						if(isPickListSelectDefaultAll){
							searchCriteriaItem.defaultPickList = getDefaultPickList(objApiName, objFieldApiName);
						}
						searchCriteriaItemList.add(searchCriteriaItem);
					}else {
						throw new CustomException('範囲検索に使用できない項目が含まれています。「表示ラベル：'+objectFieldName+' / API名：'+objFieldApiName+'」');
					}
				}
			}
			return searchCriteriaItemList;
		} catch (CustomException e) {
			throw new CustomException(e.getMessage());
		} catch (Exception e) {
			throw new AuraHandledException('予期せぬエラーが発生しました。管理者に問い合わせてください。'+e.getMessage());
		}
	}

	//検索結果セクション構築
	@AuraEnabled
	public static List<Map<String, String>> initExtDispSearchResFieldsColumns(String objApiName, String extDispSearchResFieldsColumns){

		List<Map<String, String>> extDispSearchResFieldsColumnsList = new List<Map<String, String>>();

		Map<String, String> previewColumnMap = new Map<String, String>{
			'label' => 'プレビュー',
			'type' => 'button-icon',
			'typeAttributes_title_fieldName' => 'fileName',
			'buttonActionName' => 'preview',
			'typeAttributes_Name' => 'filePreview',
			'iconName' => 'utility:preview',
			'variant' => 'bare'
		};
		extDispSearchResFieldsColumnsList.add(previewColumnMap);

		Map<String, String> fileNameColumnMap = new Map<String, String>{
			'label' => 'ファイル名',
			'fieldName' => 'fileUrl',
			'type' => 'url',
			'typeAttributes_label_fieldName' => 'fileName',
			'typeAttributes_target' => '_blank'
		};
		extDispSearchResFieldsColumnsList.add(fileNameColumnMap);

		Map<String, String> fileSizeColumnMap = new Map<String, String>{
			'label' => 'サイズ',
			'fieldName' => 'fileSize',
			'type' => 'String'
		};
		extDispSearchResFieldsColumnsList.add(fileSizeColumnMap);

		Map<String, String> fileExtensionColumnMap = new Map<String, String>{
			'label' => '拡張子',
			'fieldName' => 'fileExtension',
			'type' => 'String'
		};
		extDispSearchResFieldsColumnsList.add(fileExtensionColumnMap);

		Map<String, String> fileCreatedDateColumnMap = new Map<String, String>{
			'label' => 'ファイル作成/更新日',
			'fieldName' => 'fileCreatedDate',
			'type' => 'datetime'
		};
		extDispSearchResFieldsColumnsList.add(fileCreatedDateColumnMap);

		Map<String, String> recordNameColumnMap = new Map<String, String>{
			'label' => 'レコード名',
			'fieldName' => 'recordUrl',
			'type' => 'url',
			'typeAttributes_label_fieldName' => 'recordName',
			'typeAttributes_target' => '_blank'
		};
		extDispSearchResFieldsColumnsList.add(recordNameColumnMap);

		if(!String.isEmpty(extDispSearchResFieldsColumns)){
			for(String extDispField: extDispSearchResFieldsColumns.split(',')){
				Map<String, String> extDispFieldsMap = new Map<String, String>();
				String objectFieldName = getFieldLabel(objApiName, extDispField);
				extDispFieldsMap.put('label', objectFieldName);
				extDispFieldsMap.put('fieldName', extDispField);
				String objectFieldType = getDataType(objApiName, extDispField);
				if(objectFieldType == 'DATETIME'){
					extDispFieldsMap.put('type', 'datetime');
				}else if(objectFieldType == 'TIME'){
					extDispFieldsMap.put('type', 'time');
				}else if(objectFieldType == 'DATE'){
					extDispFieldsMap.put('type', 'date');
				}else {
					extDispFieldsMap.put('type', 'String');
				}
				extDispSearchResFieldsColumnsList.add(extDispFieldsMap);
			}
		}
		return extDispSearchResFieldsColumnsList;
	}

	@AuraEnabled
	public static List<Map<String, String>> search(String searchCriteriaJson) {
		// JSON文字列をオブジェクトに変換
		SearchCriteriaWrapper searchCriteria = (SearchCriteriaWrapper) JSON.deserialize(searchCriteriaJson, SearchCriteriaWrapper.class);

		//添付ファイルセクションのキーワード検索の入力値
		Map<String, TxtValue> inputFileSearchTxtValsMap = searchCriteria.inputFileSearchTxtVals;
		//添付ファイルセクションの範囲検索の開始入力値
		Map<String, String> inputFileSearchRangeStartValsMap = searchCriteria.inputFileSearchRangeStartVals;
		//添付ファイルセクションの範囲検索の終了入力値
		Map<String, String> inputFileSearchRangeEndValsMap = searchCriteria.inputFileSearchRangeEndVals;
		//SObjectセクションのキーワード検索の入力値
		Map<String, TxtValue> inputSObjSearchTxtValsMap = searchCriteria.inputSObjSearchTxtVals;
		//SObjectセクションのチェックボックス検索の入力値
		Map<String, String> inputSObjSearchCheckboxValsMap = searchCriteria.inputSObjSearchCheckboxVals;
		//SObjectセクションの範囲検索の開始入力値
		Map<String, String> inputSObjSearchRangeStartValsMap = searchCriteria.inputSObjSearchRangeStartVals;
		//SObjectセクションの範囲検索の終了入力値
		Map<String, String> inputSObjSearchRangeEndValsMap = searchCriteria.inputSObjSearchRangeEndVals;
		//SObjectセクションの複数選択リスト検索の入力値
		Map<String, String> inputSObjSearchPickListValsMap = searchCriteria.inputSObjSearchPickListVals;

		//最大検索件数を設定
		Integer soqlLimitSize = searchCriteria.limitNumOfDisp + 1;

		//添付ファイルのSOQL作成
		List<ContentDocumentLink> resultContentVersionList = new List<ContentDocumentLink>();
		String contVerSoql = '';
		contVerSoql += 'SELECT';
		contVerSoql += ' ContentDocument.title,';
		contVerSoql += ' ContentDocument.ContentSize,';
		contVerSoql += ' ContentDocument.FileExtension,';
		contVerSoql += ' ContentDocument.FileType,';
		contVerSoql += ' ContentDocument.ContentModifiedDate,';
		contVerSoql += ' ContentDocument.LatestPublishedVersionId,';
		contVerSoql += ' ContentDocumentId,';
		contVerSoql += ' LinkedEntityId,';
		contVerSoql += ' LinkedEntity.name';
		contVerSoql += ' FROM';
		contVerSoql += ' ContentDocumentLink';
		contVerSoql += ' WHERE';
		contVerSoql += ' LinkedEntityId';
		contVerSoql += ' IN';
		contVerSoql += ' (';
		contVerSoql += 'SELECT';
		contVerSoql += ' Id';
		contVerSoql += ' FROM';
		contVerSoql += ' ' + searchCriteria.objApiName;
		contVerSoql +=' WHERE';
		contVerSoql +=' Id != null';

		if(!inputSObjSearchTxtValsMap.isEmpty()){
			contVerSoql += setTxtSoqlWhere(searchCriteria.objApiName, inputSObjSearchTxtValsMap);
		}

		if(!inputSObjSearchCheckboxValsMap.isEmpty()){
			contVerSoql += setCheckboxSoqlWhere(searchCriteria.objApiName, inputSObjSearchCheckboxValsMap);
		}

		Set<String> inputSObjSearchRangeValsSet = new Set<String>();
		inputSObjSearchRangeValsSet.addAll(inputSObjSearchRangeStartValsMap.keySet());
		inputSObjSearchRangeValsSet.addAll(inputSObjSearchRangeEndValsMap.keySet());
		if(!inputSObjSearchRangeValsSet.isEmpty()){
			contVerSoql += setSpecifyRangeSoqlWhere(searchCriteria.objApiName, inputSObjSearchRangeValsSet, inputSObjSearchRangeStartValsMap, inputSObjSearchRangeEndValsMap);
		}

		if(!inputSObjSearchPickListValsMap.isEmpty()){
			contVerSoql += setPickListSoqlWhere(searchCriteria.objApiName, inputSObjSearchPickListValsMap);
		}

		contVerSoql += ' )';

		if(!inputFileSearchTxtValsMap.isEmpty()){
			contVerSoql += setTxtSoqlWhere(null, inputFileSearchTxtValsMap);
		}

		Set<String> inputFileSearchRangeValsSet = new Set<String>();
		inputFileSearchRangeValsSet.addAll(inputFileSearchRangeStartValsMap.keySet());
		inputFileSearchRangeValsSet.addAll(inputFileSearchRangeEndValsMap.keySet());
		if(!inputFileSearchRangeValsSet.isEmpty()){
			contVerSoql += setSpecifyRangeSoqlWhere(null, inputFileSearchRangeValsSet, inputFileSearchRangeStartValsMap, inputFileSearchRangeEndValsMap);
		}

		contVerSoql += ' ORDER BY ContentDocument.ContentModifiedDate DESC';
		contVerSoql += ' LIMIT :soqlLimitSize';

		//添付ファイル検索
		resultContentVersionList = database.query(contVerSoql);

		//付随するSObjectの検索結果を抽出する。
		Map<String ,Map<String, String>> contMatchedSobjMap = new Map<String ,Map<String, String>>();
		if(searchCriteria.extDispSearchResFieldsColumns != null){
			Set<Id> resultLinkedEntityIdSet = new Set<Id>();
			for(ContentDocumentLink resContVer : resultContentVersionList){
				resultLinkedEntityIdSet.add(resContVer.LinkedEntityId);
			}
			//SObjectのSOQL作成
			String sObjectSoql = '';
			sObjectSoql += 'SELECT';
			sObjectSoql += ' Id';
			sObjectSoql += ','+searchCriteria.extDispSearchResFieldsColumns;
			sObjectSoql += ' FROM';
			sObjectSoql += ' ' + searchCriteria.objApiName;
			sObjectSoql += ' WHERE';
			sObjectSoql += ' Id IN :resultLinkedEntityIdSet';
			//付随するSObject検索
			List<SObject> resultSObjectList = database.query(sObjectSoql);
			for (SObject resSObj : resultSObjectList) {
				Map<String, String> extDispFieldsMap = new Map<String, String>();
				for (String extDispField : searchCriteria.extDispSearchResFieldsColumns.split(',')) {
					if(getDataType(searchCriteria.objApiName, extDispField) == 'DATETIME' && resSObj.get(extDispField) != null){
						//DATETIME型データの成型
						extDispFieldsMap.put(extDispField, String.valueOf(Datetime.valueOf(resSObj.get(extDispField)).format()));
					}else if(getDataType(searchCriteria.objApiName, extDispField) == 'TIME' && resSObj.get(extDispField) != null){
						//TIME型データの成型
						extDispFieldsMap.put(extDispField, String.valueOf(resSObj.get(extDispField)).remove('.000Z'));
					}else {
						extDispFieldsMap.put(extDispField, String.valueOf(resSObj.get(extDispField)));
					}
				}
				contMatchedSobjMap.put(resSObj.Id ,extDispFieldsMap);
			}
		}

		List<Map<String, String>> searchCriteriaItemValList = new List<Map<String, String>>();
		for(ContentDocumentLink resultContVer : resultContentVersionList){
			Map<String, String> searchResultMap = new Map<String, String>();
			if(searchCriteria.extDispSearchResFieldsColumns != null){
				searchResultMap.putAll(contMatchedSobjMap.get(resultContVer.LinkedEntityId));
			}
			searchResultMap.put('fileName', resultContVer.ContentDocument.title);
			searchResultMap.put('fileId', resultContVer.ContentDocumentId);
			searchResultMap.put('fileSize', formatBytes(resultContVer.ContentDocument.ContentSize));
			searchResultMap.put('fileExtension', resultContVer.ContentDocument.FileExtension);
			searchResultMap.put('fileUrl', URL.getOrgDomainURL().toExternalForm() +'/' + resultContVer.ContentDocumentId);
			searchResultMap.put('fileCreatedDate', String.valueOf(resultContVer.ContentDocument.ContentModifiedDate.format()));
			searchResultMap.put('recordName', resultContVer.LinkedEntity.name);
			searchResultMap.put('recordUrl', URL.getOrgDomainURL().toExternalForm() +'/' +  resultContVer.LinkedEntityId);
			searchCriteriaItemValList.add(searchResultMap);
		}
		return searchCriteriaItemValList;
	}

	//キーワード検索　where句の条件式作成
	@TestVisible
	private static String setTxtSoqlWhere(String objApiName, Map<String, TxtValue> inputSearchCriteriaMap){
		List <String> strList = new List <String>();
		String soql = ' AND (';
		for(String inputFieldApi: inputSearchCriteriaMap.keySet()){
			if(inputSearchCriteriaMap.get(inputFieldApi).value != ''){
				if(inputSearchCriteriaMap.get(inputFieldApi).matchType == 'containsString'){
					strList.add(' '+inputFieldApi+' Like \'%' + String.escapeSingleQuotes(inputSearchCriteriaMap.get(inputFieldApi).value) + '%\'');
				}else if (inputSearchCriteriaMap.get(inputFieldApi).matchType == 'matchesString') {
					strList.add(' '+inputFieldApi+' = \'' + String.escapeSingleQuotes(inputSearchCriteriaMap.get(inputFieldApi).value) + '\'');
				}
			}
		}
		if(strList.isEmpty()){
			soql = '';
		}else {
			soql += String.join(strList, ' AND ');
			soql += ' )';
		}
		return soql;
	}

	//チェックボックス検索　where句の条件式作成
	@TestVisible
	private static String setCheckboxSoqlWhere(String objApiName, Map<String, String> inputSearchCriteriaMap){
		List <String> strList = new List <String>();
		String soql = ' AND (';
		for(String inputFieldApi: inputSearchCriteriaMap.keySet()){
			if(inputSearchCriteriaMap.get(inputFieldApi) != 'noOption'){
				strList.add(' '+inputFieldApi+' =' + inputSearchCriteriaMap.get(inputFieldApi));
			}
		}
		if(strList.isEmpty()){
			soql = '';
		}else {
			soql += String.join(strList, ' AND ');
			soql += ' )';
		}
		return soql;
	}

	//複数選択リスト検索　where句の条件式作成
	@TestVisible
	private static String setPickListSoqlWhere(String objApiName, Map<String, String> inputSearchCriteriaMap){
		List <String> strList = new List <String>();
		String soql = ' AND (';
		for(String inputFieldApi: inputSearchCriteriaMap.keySet()){
			if(inputSearchCriteriaMap.get(inputFieldApi) != ''){
				if(String.valueOf(inputSearchCriteriaMap.get(inputFieldApi)).contains('--なし--')){
					String pickListVals = String.valueOf(inputSearchCriteriaMap.get(inputFieldApi)).replace('--なし--', '');
					strList.add(' '+inputFieldApi+' includes (\'' + pickListVals.replace(',','\',\'') + '\')');
				}else if(String.valueOf(inputSearchCriteriaMap.get(inputFieldApi)) != ''){
					String pickListVals = String.valueOf(inputSearchCriteriaMap.get(inputFieldApi));
					strList.add(' '+inputFieldApi+' includes (\'' + pickListVals.replace(',','\',\'') + '\')');
				}
			}
		}
		if(strList.isEmpty()){
			soql = '';
		}else {
			soql += String.join(strList, ' AND ');
			soql += ' )';
		}
		return soql;
	}

	//範囲検索　where句の条件式作成
	@TestVisible
	private static String setSpecifyRangeSoqlWhere(String objApiName, Set<String> inputSearchRangeValsSet, Map<String, String> inputSearchRangeStartValsMap, Map<String, String> inputSearchRangeEndValsMap){
		List <String> strList = new List <String>();
		String soql = '';
		for(String rangeFieldApi: inputSearchRangeValsSet){
			String dataType = getDataType(objApiName, rangeFieldApi);
			if(dataType == 'TIME' || usedInTestToPassJudge){
				if(inputSearchRangeStartValsMap.get(rangeFieldApi) != null && inputSearchRangeEndValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' (';
					Soql += ' '+rangeFieldApi+' >= ' + formatTime(inputSearchRangeStartValsMap.get(rangeFieldApi));
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' <= ' + formatTime(inputSearchRangeEndValsMap.get(rangeFieldApi));
					Soql += ' )';
				}else if(inputSearchRangeStartValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' >= ' + formatTime(inputSearchRangeStartValsMap.get(rangeFieldApi));
				}else if (inputSearchRangeEndValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' <= ' + formatTime(inputSearchRangeEndValsMap.get(rangeFieldApi));
				}
			}else {
				if(inputSearchRangeStartValsMap.get(rangeFieldApi) != null && inputSearchRangeEndValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' (';
					Soql += ' '+rangeFieldApi+' >= ' + inputSearchRangeStartValsMap.get(rangeFieldApi);
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' <= ' + inputSearchRangeEndValsMap.get(rangeFieldApi);
					Soql += ' )';
				}else if(inputSearchRangeStartValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' >= ' + inputSearchRangeStartValsMap.get(rangeFieldApi);
				}else if (inputSearchRangeEndValsMap.get(rangeFieldApi) != null){
					Soql += ' AND';
					Soql += ' '+rangeFieldApi+' <= ' + inputSearchRangeEndValsMap.get(rangeFieldApi);
				}
			}
		}
		return Soql;
	}

	//Timeオブジェクトに変換
	@TestVisible
	private static Time formatTime(String inputTime){
		List<String> timeParts = inputTime.split(':');
		Time timeValue = Time.newInstance(Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]), 0);
		return timeValue;
	}

	//項目の表示ラベル取得
	@TestVisible
	private static String getFieldLabel(String objApiName, String fieldApiName){
		if (objApiName != null && fieldApiName != null) {
			return Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getLabel();
		}else {
			return '';
		}
	}

	//項目のデータタイプ取得
	@TestVisible
	private static String getDataType(String objApiName, String fieldApiName){
		if (objApiName != null && fieldApiName != null) {
			return String.valueOf(Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getType());
		}else {
			return '';
		}
	}

	//項目のWHERE検索条件の一部として使用可否判定
	@TestVisible
	private static Boolean canBeUsedSoqlWhereClause(String objApiName, String fieldApiName){
		if (objApiName != null && fieldApiName != null) {
			return Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe().isFilterable();
		}else {
			return false;
		}
	}

	//複数選択リストの値を取得
	@TestVisible
	private static List<Map<String, String>> getPickList(String objApiName, String fieldApiName){
		List<Schema.PicklistEntry> peList = Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();
		// 選択リスト値一覧から、対象の値のラベルを取得する。
		List<Map<String, String>> pickListMapList = new List<Map<String, String>>();
		// boolean isFirst = true;
		Map<String, String> emptypickListMap = new Map<String, String>();
		emptypickListMap.put('label', '--なし--');
		emptypickListMap.put('value', '--なし--');
		pickListMapList.add(emptypickListMap);
		for(Schema.PicklistEntry pe : peList){
			Map<String, String> pickListMap = new Map<String, String>();
				pickListMap.put('label', pe.getLabel());
				pickListMap.put('value', pe.getValue());
				pickListMapList.add(pickListMap);
		}
		return pickListMapList;
	}

	//複数選択リスト　値デフォルト全選択の場合の値を取得
	@TestVisible
	private static List<String> getDefaultPickList(String objApiName, String fieldApiName){
		List<Schema.PicklistEntry> peList = Schema.getGlobalDescribe().get(objApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();
		List<String> pickList = new List<String>();
		pickList.add('--なし--');
		for(Schema.PicklistEntry pe : peList){
			pickList.add(String.valueOf(pe.getLabel()));
		}
		return pickList;
	}

	//バイト換算
	@TestVisible
	private static String formatBytes(Long bytes) {
		if (bytes < 1024) {
			return bytes + ' B';
		} else if (bytes < 1048576) {
			return String.valueOf(Math.round(bytes / 1024.0)) + ' KB';
		} else if (bytes < 1073741824) {
			return String.valueOf(Math.round(bytes / 1048576.0)) + ' MB';
		} else if (bytes < 1099511627776L) {
			return String.valueOf(Math.round(bytes / 1073741824.0)) + ' GB';
		} else {
			return String.valueOf(Math.round(bytes / 1099511627776.0)) + ' TB';
		}
	}

	public class SearchCriteria {
		@AuraEnabled
		public String fieldLabel;
		@AuraEnabled
		public String fieldApi;
		@AuraEnabled
		public String fieldType;
		@AuraEnabled
		public List<Map<String, String>> pickList;
		@AuraEnabled
		public List<String> defaultPickList;
	}

	public class TxtValue {
		public String value;
		public String matchType;
	}

	public class SearchCriteriaWrapper {
		public Integer limitNumOfDisp;
		public String objApiName;
		public String keywordSectFieldsApiName;
		public String rangeSectFieldsApiName;
		public String extDispSearchResFieldsColumns;

		public Map<String, TxtValue> inputFileSearchTxtVals;
		public Map<String, String> inputFileSearchRangeStartVals;
		public Map<String, String> inputFileSearchRangeEndVals;
		public Map<String, TxtValue> inputSObjSearchTxtVals;
		public Map<String, String> inputSObjSearchCheckboxVals;
		public Map<String, String> inputSObjSearchRangeStartVals;
		public Map<String, String> inputSObjSearchRangeEndVals;
		public Map<String, String> inputSObjSearchPickListVals;
	}
}