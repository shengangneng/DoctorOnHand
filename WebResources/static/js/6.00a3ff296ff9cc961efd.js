webpackJsonp([6],{"0AvM":function(e,t){},"6+TG":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var i=a("Xxa5"),o=a.n(i),l=a("exGp"),n=a.n(l),r=a("Dd8w"),s=a.n(r),d=a("NYxO"),c=a("+vI2"),m=a("Igzn"),p=a("Lgrw"),u=a("0AY0"),h=a("lXUi"),b=a("UsB0"),f={name:"AdviceLongterm",components:{PatientInfo:c.a,popupWindow:m.a,historyDialog:p.a,naviBar:u.a,addItem:b.a},data:function(){return{isHistoryDialog:!1,showPop:!1,historyData:[{id:"1",name:"王小虎",number:"000033421",outTime:"2016-05-04",discharge:"呼吸内科一病区",doctor:"王刚"}],queryAll:!1,beforeStopDelData:[],isCheckedShow:!1,isBottomBtns:!1,currCheckedRow:[],whichBtnClick:"",isDisabled:!1,isShowSign:!1}},computed:s()({},Object(d.c)(["patient","history"])),beforeMount:function(){},methods:s()({},Object(d.b)("history",["update"]),{toHistory:function(){this.isHistoryDialog=!0},toNow:function(){this.isHistoryDialog=!1},historyClick:function(e){console.log(e),this.update(!0),this.isHistoryDialog=!1},selectAll:function(e){console.log(e)},isCheckedAndBtnsShow:function(e){this.isCheckedShow=e,this.isBottomBtns=e},btnAdd:function(){this.isCheckedAndBtnsShow(!1),this.isDisabled=!1,this.showPop=!0},hideShowPop:function(){this.showPop=!1},btnStop:function(){this.isCheckedAndBtnsShow(!0),this.whichBtnClick="btnStop",this.isDisabled=!0},btnDelect:function(){this.isCheckedAndBtnsShow(!0),this.whichBtnClick="btnDelect",this.isDisabled=!0},dropItemSelect:function(e){switch(e){case"itemUpdate":this.$message("修改-暂未开发，等需求");break;case"itemCancel":this.isCheckedAndBtnsShow(!0),this.whichBtnClick="itemCancel",this.isDisabled=!0;break;case"itemCallTemplates":break;case"itemSaveTemplates":this.$message("需要后台生成excel，前端下载")}},checkedRow:function(e){e.forEach(function(e){e.isChecked=!0}),this.currCheckedRow=e},cancelConfirm:function(){this.isCheckedAndBtnsShow(!1),this.isDisabled=!1},btnConfirm:function(){if(0!==this.currCheckedRow.length)switch(this.whichBtnClick){case"btnStop":case"btnDelect":case"itemCancel":this.isShowSign=!0;break;case"btnHistory":this.$message("btnHistory2")}else this.$message("请先选中医嘱")},addSign:function(){var e=this,t=this;switch(this.whichBtnClick){case"btnStop":this.beforeStopDelData=this.beforeStopDelData.filter(function(e){return!t.currCheckedRow.includes(e)}),t.currCheckedRow.forEach(function(t){e.afterStopDelData.push(t)}),this.isShowSign=!1;break;case"btnDelect":this.beforeStopDelData=this.beforeStopDelData.filter(function(e){return!t.currCheckedRow.includes(e)}),this.isShowSign=!1;break;case"itemCancel":this.isShowSign=!1;break;case"btnHistory":this.$message("btnHistory2")}}}),mounted:function(){var e=this;return n()(o.a.mark(function t(){var a;return o.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,h.a.getAdviceList({registerId:e.patient.registerId,type:0});case 2:a=t.sent,console.log("res",a),e.beforeStopDelData=a.resultData;case 5:case"end":return t.stop()}},t,e)}))()}},v={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"LongtermBox bsbb"},[a("addItem",{attrs:{showPop:e.showPop},on:{hideShowPop:e.hideShowPop}}),e._v(" "),a("div",{staticClass:"pageTopBox"},[a("navi-bar",[a("div",{attrs:{slot:"right"},slot:"right"},[e.history?e._e():a("el-checkbox",{attrs:{disabled:e.isDisabled},on:{change:e.selectAll},model:{value:e.queryAll,callback:function(t){e.queryAll=t},expression:"queryAll"}},[e._v("全部")]),e._v(" "),e.history?e._e():a("el-button",{attrs:{type:"text"},on:{click:e.btnAdd}},[a("span",{staticClass:"iconfont icon-xinzeng1"}),e._v("新增")]),e._v(" "),e.history?e._e():a("el-button",{attrs:{type:"text"},on:{click:e.btnStop}},[a("span",{staticClass:"iconfont icon-tingzhi"}),e._v("停止")]),e._v(" "),e.history?e._e():a("el-button",{attrs:{type:"text"},on:{click:e.btnDelect}},[a("span",{staticClass:"iconfont icon-shanchu"}),e._v("删除")]),e._v(" "),a("el-dropdown",{attrs:{trigger:"click"},on:{command:e.dropItemSelect}},[a("span",{staticClass:"el-dropdown-link"},[e._v("\n            更多"),a("i",{staticClass:"el-icon-arrow-down el-icon--right"})]),e._v(" "),a("el-dropdown-menu",{attrs:{slot:"dropdown"},slot:"dropdown"},[e.history?e._e():a("el-dropdown-item",{attrs:{command:"itemUpdate"}},[e._v("修改")]),e._v(" "),e.history?e._e():a("el-dropdown-item",{attrs:{command:"itemCancel"}},[e._v("撤销提交")]),e._v(" "),e.history?e._e():a("el-dropdown-item",{attrs:{divided:"",command:"itemCallTemplates"}},[e._v("调用模板")]),e._v(" "),a("el-dropdown-item",{attrs:{divided:"",command:"itemSaveTemplates"}},[e._v("存模板")])],1)],1),e._v(" "),a("el-button",{attrs:{type:"text"},on:{click:e.toHistory}},[a("span",{staticClass:"iconfont icon-lishijilu"}),e._v("既往")])],1)])],1),e._v(" "),a("div",{staticClass:"pageContainer"},[a("el-table",{attrs:{"header-cell-style":{color:"#000000",background:"#F6F6F6"},align:"center",data:e.beforeStopDelData,height:"100%"},on:{"selection-change":e.checkedRow}},[e.isCheckedShow?a("el-table-column",{attrs:{type:"selection",width:"50"}}):e._e(),e._v(" "),a("el-table-column",{attrs:{fixed:"",prop:"orderNo",label:"序号",width:"60"}}),e._v(" "),a("el-table-column",{attrs:{fixed:"",prop:"validTime",label:"期效",width:"50"}}),e._v(" "),a("el-table-column",{attrs:{fixed:"",prop:"startTime",label:"开始时间",width:"150"}}),e._v(" "),a("el-table-column",{attrs:{fixed:"",prop:"content",label:"医嘱内容",width:"160"}}),e._v(" "),a("el-table-column",{attrs:{prop:"perNumber",label:"单量",width:"70"}}),e._v(" "),a("el-table-column",{attrs:{prop:"perUnit",label:"单位",width:"50"}}),e._v(" "),a("el-table-column",{attrs:{prop:"usage",label:"用法",width:"50"}}),e._v(" "),a("el-table-column",{attrs:{prop:"skinTest",label:"皮试",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"frequency",label:"频率",width:"50"}}),e._v(" "),a("el-table-column",{attrs:{prop:"dayNum",label:"天数",width:"70"}}),e._v(" "),a("el-table-column",{attrs:{prop:"all",label:"总量",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"allUnit",label:"总量单位",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"urgent",label:"紧急",width:"70"}}),e._v(" "),a("el-table-column",{attrs:{prop:"speed",label:"滴速",width:"70"}}),e._v(" "),a("el-table-column",{attrs:{prop:"advice_doctor",label:"开嘱医生",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"advice_time",label:"开嘱时间",width:"160"}}),e._v(" "),a("el-table-column",{attrs:{prop:"cost",label:"费用",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"remark",label:"备注",width:"190"}}),e._v(" "),a("el-table-column",{attrs:{prop:"examine_nurse",label:"核对护士",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{prop:"examine_time",label:"核对时间",width:"150"}}),e._v(" "),a("el-table-column",{attrs:{prop:"department",label:"执行科室",width:"100"}})],1),e._v(" "),a("div",{directives:[{name:"show",rawName:"v-show",value:e.isBottomBtns,expression:"isBottomBtns"}],staticClass:"popConfirm"},[a("el-button",{attrs:{type:"primary"},on:{click:e.btnConfirm}},[e._v("提 交")]),e._v(" "),a("el-button",{on:{click:function(t){return e.cancelConfirm()}}},[e._v("取 消")])],1)],1),e._v(" "),a("el-dialog",{attrs:{title:"签名",visible:e.isShowSign,width:"10rem","append-to-body":"","show-close":!1,center:""},on:{"update:visible":function(t){e.isShowSign=t}}},[a("el-form",[a("el-form-item",{attrs:{label:"工号","label-width":"100px"}},[a("el-input",{attrs:{autocomplete:"off"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"密码","label-width":"100px"}},[a("el-input",{attrs:{autocomplete:"off",type:"password"}})],1)],1),e._v(" "),a("span",{staticClass:"dialog-footer",attrs:{slot:"footer"},slot:"footer"},[a("el-button",{on:{click:function(t){e.isShowSign=!1}}},[e._v("取 消")]),e._v(" "),a("el-button",{attrs:{type:"primary"},on:{click:e.addSign}},[e._v("确 定")])],1)],1),e._v(" "),a("historyDialog",{attrs:{historyData:e.historyData,isHistoryDialog:e.isHistoryDialog},on:{historyClickEvent:e.historyClick,toRowEvent:e.toNow}})],1)},staticRenderFns:[]};var w=a("VU/8")(f,v,!1,function(e){a("eMAV")},"data-v-20537fd1",null);t.default=w.exports},UsB0:function(e,t,a){"use strict";var i=a("Xxa5"),o=a.n(i),l=a("exGp"),n=a.n(l),r=a("Igzn"),s=a("lXUi"),d={components:{popupWindow:r.a},props:{showPop:{type:Boolean,default:!1}},data:function(){return{addDialogFormVisible:!1,isShow:1,tableData:[],addForm:{abstract:"",urgent:"2",startTime:"",skinTest:"2",medicine:"",frequency:"",perNumber:"",unit:"个",days:"1",all:"",allUnit:"个",content:"多喝热水",speed:"5ml/s",firstDayNumber:"5",endDayNumber:"10",department:"05科室",dispensingDispensary:"05药房",boilMedicine:"2"},medicineOption:["IV.静脉注射","iVgtt 静滴","im肌肉注射","PO口服","iP腹腔注射","SC皮下注射","sipp栓剂"],rateOption:["qd","bid","tid"],project:[],title:"长期医嘱下达",herbalMedicine:!1,condition:"",typeName:""}},computed:{},watch:{showPop:function(e){this.addDialogFormVisible=e}},methods:{beforeClose:function(){this.isShow?this.cancel():this.isShow=1},handleSelect:function(e){console.log(e)},changeTypeName:function(e){var t=this;return n()(o.a.mark(function a(){return o.a.wrap(function(a){for(;;)switch(a.prev=a.next){case 0:t.typeName=e,t.getItem();case 2:case"end":return a.stop()}},a,t)}))()},define:function(){this.beforeStopDelData.push(this.addForm),this.addForm={},this.isDisabled=!1,this.cancel()},cancel:function(){this.$emit("hideShowPop"),this.isShow=1},openDetails:function(){this.isShow=0},search:function(){this.getItem()},getItem:function(){var e=this;return n()(o.a.mark(function t(){var a,i,l;return o.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:if(a=e.typeName,!(i=e.condition)){t.next=7;break}return t.next=4,s.a.getCondition({typeName:a,condition:i});case 4:l=t.sent,console.log(l),e.tableData=l.resultData;case 7:case"end":return t.stop()}},t,e)}))()}},created:function(){var e=this;return n()(o.a.mark(function t(){var a;return o.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return e.addDialogFormVisible=e.showPop,t.next=3,s.a.getItemtypes();case 3:a=t.sent,e.project=a.resultData,e.typeName=e.project[0];case 6:case"end":return t.stop()}},t,e)}))()},mounted:function(){}},c={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("popup-window",{attrs:{addDialogFormVisible:e.addDialogFormVisible,beforeClose:e.beforeClose,title:e.title}},[1===e.isShow?a("div",{staticClass:"information",attrs:{slot:"information"},slot:"information"},[e._l(e.project,function(t,i){return a("a",{key:i,class:{active:t===e.typeName},on:{click:function(a){return e.changeTypeName(t)}}},[e._v(e._s(t))])}),e._v(" "),a("el-input",{attrs:{placeholder:"按拼音码检索"},nativeOn:{keyup:function(t){return e.search(t)}},model:{value:e.condition,callback:function(t){e.condition="string"==typeof t?t.trim():t},expression:"condition"}}),e._v(" "),[a("el-table",{staticStyle:{width:"100%"},attrs:{data:e.tableData,"header-cell-style":{color:"#000000",background:"#F6F6F6"}},on:{"row-click":e.openDetails}},[a("el-table-column",{attrs:{prop:"result",label:"搜索结果"}})],1)]],2):e._e(),e._v(" "),0===e.isShow?a("div",{staticClass:"information2",attrs:{slot:"information"},slot:"information"},[a("el-form",{attrs:{model:e.addForm}},[a("el-form-item",[a("h3",{staticStyle:{"text-align":"center"}},[e._v("阿苯达唑片 0.2X10片/盒，血常规三分类，肝功能五项")])]),e._v(" "),a("el-form-item",{attrs:{label:"紧急","label-width":"2.06rem"}},[[a("el-radio",{attrs:{label:"1"},model:{value:e.addForm.urgent,callback:function(t){e.$set(e.addForm,"urgent",t)},expression:"addForm.urgent"}},[e._v("是")]),e._v(" "),a("el-radio",{attrs:{label:"2"},model:{value:e.addForm.urgent,callback:function(t){e.$set(e.addForm,"urgent",t)},expression:"addForm.urgent"}},[e._v("否")])]],2),e._v(" "),a("el-form-item",{attrs:{label:"开始时间","label-width":"2.06rem"}},[a("el-date-picker",{attrs:{"value-format":"yyyy-MM-dd HH:mm:ss",type:"datetime",placeholder:"输入您的时间"},model:{value:e.addForm.startTime,callback:function(t){e.$set(e.addForm,"startTime",t)},expression:"addForm.startTime"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"皮试","label-width":"2.06rem"}},[[a("el-radio",{attrs:{label:"1"},model:{value:e.addForm.skinTest,callback:function(t){e.$set(e.addForm,"skinTest",t)},expression:"addForm.skinTest"}},[e._v("是")]),e._v(" "),a("el-radio",{attrs:{label:"2"},model:{value:e.addForm.skinTest,callback:function(t){e.$set(e.addForm,"skinTest",t)},expression:"addForm.skinTest"}},[e._v("否")])]],2),e._v(" "),a("el-form-item",{attrs:{label:"给药途径","label-width":"2.06rem"}},[a("el-select",{attrs:{placeholder:"请选择"},model:{value:e.addForm.medicine,callback:function(t){e.$set(e.addForm,"medicine",t)},expression:"addForm.medicine"}},e._l(e.medicineOption,function(e){return a("el-option",{key:e,attrs:{label:e,value:e}})}),1)],1),e._v(" "),a("el-form-item",{attrs:{label:"执行频率","label-width":"2.06rem"}},[a("el-select",{attrs:{placeholder:"请选择"},model:{value:e.addForm.frequency,callback:function(t){e.$set(e.addForm,"frequency",t)},expression:"addForm.frequency"}},e._l(e.rateOption,function(e){return a("el-option",{key:e,attrs:{label:e,value:e}})}),1)],1),e._v(" "),a("el-form-item",{attrs:{label:"每次用量","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"只能输入数字",type:"number"},model:{value:e.addForm.perNumber,callback:function(t){e.$set(e.addForm,"perNumber",t)},expression:"addForm.perNumber"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"用量单位","label-width":"2.06rem"}},[a("span",[e._v(e._s(e.addForm.unit))])]),e._v(" "),a("el-form-item",{attrs:{label:"天数","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"只能输入数字",type:"number"},model:{value:e.addForm.days,callback:function(t){e.$set(e.addForm,"days",t)},expression:"addForm.days"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"总量","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"只能输入数字",type:"number"},model:{value:e.addForm.all,callback:function(t){e.$set(e.addForm,"all",t)},expression:"addForm.all"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"总量单位","label-width":"2.06rem"}},[a("span",[e._v(e._s(e.addForm.allUnit))])]),e._v(" "),a("el-form-item",{attrs:{label:"医生嘱托","label-width":"2.06rem"}},[a("el-input",{attrs:{type:"textarea",rows:2,placeholder:"请输入内容"},model:{value:e.addForm.content,callback:function(t){e.$set(e.addForm,"content",t)},expression:"addForm.content"}})],1),e._v(" "),0==e.herbalMedicine?a("el-form-item",{attrs:{label:"滴速","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"可输入数字或文字"},model:{value:e.addForm.speed,callback:function(t){e.$set(e.addForm,"speed",t)},expression:"addForm.speed"}})],1):e._e(),e._v(" "),-1!=this.title.indexOf("长")?a("el-form-item",{attrs:{label:"首日量","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"只能输入数字",type:"number"},model:{value:e.addForm.firstDayNumber,callback:function(t){e.$set(e.addForm,"firstDayNumber",t)},expression:"addForm.firstDayNumber"}})],1):e._e(),e._v(" "),-1!=this.title.indexOf("长")?a("el-form-item",{attrs:{label:"末日量","label-width":"2.06rem"}},[a("el-input",{attrs:{placeholder:"只能输入数字",type:"number"},model:{value:e.addForm.endDayNumber,callback:function(t){e.$set(e.addForm,"endDayNumber",t)},expression:"addForm.endDayNumber"}})],1):e._e(),e._v(" "),a("el-form-item",{attrs:{label:"执行科室","label-width":"2.06rem"}},[a("span",[e._v(e._s(e.addForm.department))])]),e._v(" "),a("el-form-item",{attrs:{label:"发药药房","label-width":"2.06rem"}},[a("span",[e._v(e._s(e.addForm.dispensingDispensary))])]),e._v(" "),1==e.herbalMedicine?a("el-form-item",{attrs:{label:"代煎","label-width":"2.06rem"}},[[a("el-radio",{attrs:{label:"1"},model:{value:e.addForm.boilMedicine,callback:function(t){e.$set(e.addForm,"boilMedicine",t)},expression:"addForm.boilMedicine"}},[e._v("是")]),e._v(" "),a("el-radio",{attrs:{label:"2"},model:{value:e.addForm.boilMedicine,callback:function(t){e.$set(e.addForm,"boilMedicine",t)},expression:"addForm.boilMedicine"}},[e._v("否")])]],2):e._e()],1),e._v(" "),a("div",{staticClass:"footer"},[a("el-button",{attrs:{type:"primary"},on:{click:e.define}},[e._v("确 定")]),e._v(" "),a("el-button",{on:{click:e.cancel}},[e._v("取 消")])],1)],1):e._e()])},staticRenderFns:[]};var m=a("VU/8")(d,c,!1,function(e){a("0AvM")},"data-v-a90bb708",null);t.a=m.exports},eMAV:function(e,t){}});