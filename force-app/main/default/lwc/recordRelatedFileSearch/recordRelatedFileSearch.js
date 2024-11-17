import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from "lightning/alert";
import search from '@salesforce/apex/RecordRelatedFileSearchController.search';
import initKeywordSearchSection from '@salesforce/apex/RecordRelatedFileSearchController.initKeywordSearchSection';
import initCheckboxSearchSection from '@salesforce/apex/RecordRelatedFileSearchController.initCheckboxSearchSection';
import initRangeSearchSection from '@salesforce/apex/RecordRelatedFileSearchController.initRangeSearchSection';
import initPickListSearchSection from '@salesforce/apex/RecordRelatedFileSearchController.initPickListSearchSection';
import initExtDispSearchResFieldsColumns from '@salesforce/apex/RecordRelatedFileSearchController.initExtDispSearchResFieldsColumns';

export default class RecordRelatedFileSearch extends LightningElement {

	limitNumOfDisp = 500; // 検索結果の最大表示件数
	@api componentTitle; //コンポーネントのタイトル
	@api objApiName; //オブジェクトのAPI名
	@api keywordSectFieldsApiName; //キーワード検索する項目のAPI名(複数の場合は,区切り)
	@api checkboxSectFieldsApiName; //チェックボックス項目のAPI名(複数の場合は,区切り)
	@api rangeSectFieldsApiName; //範囲検索する項目のAPI名(複数の場合は,区切り)
	@api pickListSectFieldsApiName; //複数選択リスト項目のAPI名(複数の場合は,区切り)
	@api isPickListSelectDefaultAll; //複数選択リスト項目デフォルト全選択フラグ(デフォルトfalse)
	@api extDispSearchResFieldsColumns; //検索結果に追加で表示させる項目のAPI名(複数の場合は,区切り)

	data = []; //データテーブル用
	columns;//データテーブル用
	numOfSearchRes;//画面表示用 検索結果件数
	inputFileSearchTxtVals = new Map();
	inputFileSearchRangeStartVals = new Map();
	inputFileSearchRangeEndVals = new Map();
	inputSObjSearchTxtVals = new Map();
	inputSObjSearchCheckboxVals = new Map();
	inputSObjSearchRangeStartVals = new Map();
	inputSObjSearchRangeEndVals = new Map();
	inputSObjSearchPickListVals = new Map();
	searchResKeywordList;
	searchResCheckboxList;
	searchResRangeList;
	searchResPickListList;
	spinner = false;

	matchTypeValue = 'containsString';
	get matchTypeOptions() {
        return [
            { label: '部分一致', value: 'containsString' },
            { label: '完全一致', value: 'matchesString' },
        ];
    }

	radioValue = 'noOption';
	get radioOptions() {
        return [
            { label: 'なし', value: 'noOption' },
            { label: 'true', value: 'true' },
			{ label: 'false', value: 'false' },
        ];
    }

	connectedCallback(){
		this.spinner = true;
		initKeywordSearchSection({objApiName: this.objApiName,
									keywordSectFieldsApiName: this.keywordSectFieldsApiName
		})
		.then(result => {
			this.searchResKeywordList = result;
			this.spinner = false;
		})
		.catch(error => {
			LightningAlert.open({
				message: error.body.message,
				theme: "error",
				label: "エラー",
			});
			this.spinner = false;
		});

		initCheckboxSearchSection({objApiName: this.objApiName,
									checkboxSectFieldsApiName: this.checkboxSectFieldsApiName
		})
		.then(result => {
			this.searchResCheckboxList = result;
			this.spinner = false;
		})
		.catch(error => {
			LightningAlert.open({
			message: error.body.message,
				theme: "error",
				label: "エラー",
			});
			this.spinner = false;
		});

		initRangeSearchSection({objApiName: this.objApiName,
								rangeSectFieldsApiName: this.rangeSectFieldsApiName
		})
		.then(result => {
			this.searchResRangeList = result;
			this.spinner = false;
		})
		.catch(error => {
			LightningAlert.open({
				message: error.body.message,
				theme: "error",
				label: "エラー",
			});
			this.spinner = false;
		});

		initPickListSearchSection({objApiName: this.objApiName,
									pickListSectFieldsApiName: this.pickListSectFieldsApiName,
									isPickListSelectDefaultAll: this.isPickListSelectDefaultAll
		})
		.then(result => {
			this.searchResPickListList = result;
			if(this.isPickListSelectDefaultAll === true){
				this.searchResPickListList.forEach(item => {
					this.inputSObjSearchPickListVals.set(item.fieldApi, item.defaultPickList.join(','));
				});
			}
			this.spinner = false;
		})
		.catch(error => {
			LightningAlert.open({
				message: error.body.message,
				theme: "error",
				label: "エラー",
			});
			this.spinner = false;
		});

		initExtDispSearchResFieldsColumns({objApiName: this.objApiName,
											extDispSearchResFieldsColumns: this.extDispSearchResFieldsColumns,
		})
		.then(result => {
			this.columns = result.map(item => ({
				label: item.label,
				fieldName: item.fieldName,
				type: item.type,
				typeAttributes: {
					label: {
						fieldName: item.typeAttributes_label_fieldName
					},
					target: item.typeAttributes_target
				},
			}));
			this.spinner = false;
		})
		.catch(error => {
			LightningAlert.open({
				message: error.body.message,
				theme: "error",
				label: "エラー",
			});
			this.spinner = false;
		});
	}

	searchButton(){
		var inputFileName = this.template.querySelector('.inputFileName');
		if(inputFileName.value == ''){
			inputFileName.setCustomValidity('この項目を入力してください。');
			inputFileName.reportValidity();
		}else{
			inputFileName.setCustomValidity('');
			inputFileName.reportValidity();
			this.spinner = true;
			search({limitNumOfDisp: this.limitNumOfDisp,
					objApiName: this.objApiName,
					keywordSectFieldsApiName: this.keywordSectFieldsApiName,
					rangeSectFieldsApiName: this.rangeSectFieldsApiName,
					extDispSearchResFieldsColumns: this.extDispSearchResFieldsColumns,
					inputFileSearchTxtVals: JSON.stringify(Object.fromEntries(this.inputFileSearchTxtVals)),
					inputFileSearchRangeStartVals: JSON.stringify(Object.fromEntries(this.inputFileSearchRangeStartVals)),
					inputFileSearchRangeEndVals: JSON.stringify(Object.fromEntries(this.inputFileSearchRangeEndVals)),
					inputSObjSearchTxtVals: JSON.stringify(Object.fromEntries(this.inputSObjSearchTxtVals)),
					inputSObjSearchCheckboxVals: JSON.stringify(Object.fromEntries(this.inputSObjSearchCheckboxVals)),
					inputSObjSearchRangeStartVals: JSON.stringify(Object.fromEntries(this.inputSObjSearchRangeStartVals)),
					inputSObjSearchRangeEndVals: JSON.stringify(Object.fromEntries(this.inputSObjSearchRangeEndVals)),
					inputSObjSearchPickListVals: JSON.stringify(Object.fromEntries(this.inputSObjSearchPickListVals))
			})
			.then(result => {
				if(Object.keys(result).length == 0){
					this.data = result.slice(0, this.limitNumOfDisp);
					this.numOfSearchRes = result.length;
					this.dispatchEvent(
						new ShowToastEvent({
							title: '検索結果は0件です。',
							message: '検索条件を変更して再度検索してください。',
							variant: 'info ',
							mode: 'dismissible'
						})
					);
				}else if(Object.keys(result).length > this.limitNumOfDisp){
					this.data = result.slice(0, this.limitNumOfDisp);
					this.numOfSearchRes = result.length-1;
					this.dispatchEvent(
						new ShowToastEvent({
							title: '検索結果が上限の'+this.limitNumOfDisp+'件数を超えました',
							message: '最新のファイル'+this.numOfSearchRes+'件を表示しています。',
							variant: 'info ',
							mode: 'dismissible'
						})
					);
				}else{
					this.data = result.slice(0, this.limitNumOfDisp);
					this.numOfSearchRes = result.length;
					this.dispatchEvent(
						new ShowToastEvent({
							title: this.numOfSearchRes+'件ヒットしました。',
							message: '「ファイル作成及び更新日」の降順で表示しています。',
							variant: 'success',
							mode: 'dismissible'
						})
					);
				}
				this.spinner = false;
			})
			.catch(error => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'エラーが発生しました。',
						message: error.body.message,
						variant: 'error',
						mode: 'sticky'
					})
				);
				this.spinner = false;
			});
		}
	}

	//ファイル名,ファイル拡張子
	handleInputFileSearchTxtChange(event) {
		const inputName = event.target.name;
		const inputValue = event.target.value;
		const existingValue = this.inputFileSearchTxtVals.get(inputName);

		if (existingValue) {
			existingValue.value = inputValue;
			this.inputFileSearchTxtVals.set(inputName, existingValue);
		} else {
			this.inputFileSearchTxtVals.set(inputName, { value: inputValue, matchType: 'containsString' });
		}
	}

	handleInputFileSearchComboChange(event) {
		const comboboxName = event.target.name;
		const selectedValue = event.detail.value;
		const existingValue = this.inputFileSearchTxtVals.get(comboboxName);

		if (existingValue) {
			existingValue.matchType = selectedValue;
			this.inputFileSearchTxtVals.set(comboboxName, existingValue);
		} else {
			this.inputFileSearchTxtVals.set(comboboxName, { value: '', matchType: selectedValue });
		}
	}

	//ファイル作成日　開始日
	handleInputFileSearchRangeStartChange(event){
		this.inputFileSearchRangeStartVals.set(event.target.name,event.detail.value);
	}

	//ファイル作成日　終了日
	handleInputFileSearchRangeEndChange(event){
		this.inputFileSearchRangeEndVals.set(event.target.name,event.detail.value);
	}

	//キーワード検索
	handleInputSObjSearchTxtChange(event){
		const inputName = event.target.name; // 変数名を短く
		const inputValue = event.target.value;
		const existingValue = this.inputSObjSearchTxtVals.get(inputName);

		if (existingValue) {
			existingValue.value = inputValue;
			this.inputSObjSearchTxtVals.set(inputName, existingValue);
		} else {
			this.inputSObjSearchTxtVals.set(inputName, { value: inputValue, matchType: 'containsString' });
		}
	}

	handleInputSObjSearchComboChange(event) {
		const comboboxName = event.target.name;
		const selectedValue = event.detail.value;
		const existingValue = this.inputSObjSearchTxtVals.get(comboboxName);

		if (existingValue) {
			existingValue.matchType = selectedValue;
			this.inputSObjSearchTxtVals.set(comboboxName, existingValue);
		} else {
			this.inputSObjSearchTxtVals.set(comboboxName, { value: '', matchType: selectedValue });
		}
	}

	//チェックボックス検索
	handleInputSObjCheckboxSearch(event){
		this.inputSObjSearchCheckboxVals.set(event.target.name,event.detail.value);
	}

	//範囲検索 開始日
	handleInputSObjSearchRangeStartChange(event){
		this.inputSObjSearchRangeStartVals.set(event.target.name,event.detail.value);
	}

	//範囲検索 終了日
	handleInputSObjSearchRangeEndChange(event){
		this.inputSObjSearchRangeEndVals.set(event.target.name,event.detail.value);
	}

	//複数選択リスト
	handleInputSObjSearchPickListChange(event){
		this.inputSObjSearchPickListVals.set(event.target.name,event.detail.value.join(','));
	}

	clearButton(){
		this.template.querySelectorAll('lightning-combobox').forEach(element => {
			element.value = 'containsString';
			this.matchTypeValue = 'containsString';
		});
		this.template.querySelectorAll('lightning-input').forEach(element => {
			element.value = null;
		});
		this.template.querySelectorAll('lightning-radio-group').forEach(element => {
			element.value = 'noOption';
			this.radioValue = 'noOption';
		});
		this.inputFileSearchTxtVals.clear();
		this.inputFileSearchRangeStartVals.clear();
		this.inputFileSearchRangeEndVals.clear();
		this.inputSObjSearchTxtVals.clear();
		this.inputSObjSearchCheckboxVals.clear();
		this.inputSObjSearchRangeStartVals.clear();
		this.inputSObjSearchRangeEndVals.clear();
		if(this.isPickListSelectDefaultAll === true){
			initPickListSearchSection({objApiName: this.objApiName,
										pickListSectFieldsApiName: this.pickListSectFieldsApiName,
										isPickListSelectDefaultAll: this.isPickListSelectDefaultAll
			})
			.then(result => {
				this.searchResPickListList = result;
				if(this.isPickListSelectDefaultAll === true){
					this.searchResPickListList.forEach(item => {
						this.inputSObjSearchPickListVals.set(item.fieldApi, item.defaultPickList.join(','));
					});
				}
			})
			.catch(error => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'エラーが発生しました。',
						message: error.body.message,
						variant: 'error',
						mode: 'sticky'
					})
				);
			});
		}else{
			this.template.querySelectorAll('lightning-dual-listbox').forEach(element => {
				element.value = null;
			});
			this.inputSObjSearchPickListVals.clear();
		}
	}
}