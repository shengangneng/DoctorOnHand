webpackJsonp([32],{"2QW9":function(t,e){},oyba:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var l=a("Dd8w"),n=a.n(l),o=a("NYxO"),i={name:"Patient-Cost",components:{PatientInfo:a("+vI2").a},data:function(){return{parientListShow:!0,activeName:"first",jzData:[{id:"12987122",name:"西药",amount1:"234",amount2:"3.2",amount3:10},{id:"12987123",name:"中药",amount1:"165",amount2:"4.43",amount3:12},{id:"12987124",name:"手续",amount1:"324",amount2:"1.9",amount3:9},{id:"12987123",name:"中药",amount1:"165",amount2:"4.43",amount3:12},{id:"12987124",name:"手续",amount1:"324",amount2:"1.9",amount3:9},{id:"12987123",name:"中药",amount1:"165",amount2:"4.43",amount3:12},{id:"12987124",name:"手续",amount1:"324",amount2:"1.9",amount3:9},{id:"12987123",name:"中药",amount1:"165",amount2:"4.43",amount3:12}],yjjData:[{payDate:"2020-04-16",money:"3000.00",explain:"这是一个预交金"}],rqdData:[{id:"",date:"2020-04-16",itemIndex:"1",cost:"64.43",item:"青霉素",rule:"20u",number:"3",unitPrice:"25.1",explain:"一个日清单"},{id:"",date:"2020-04-17",itemIndex:"2",cost:"340.00",item:"CT监测",rule:"正片",number:"1",unitPrice:"340.00",explain:"一个日清单"}]}},computed:n()({},Object(o.c)(["patient","PatientlistVisibility"])),mounted:function(){this.$store.dispatch("PatientlistVisibility/setPatientlistVisibility",this.parientListShow)},methods:{indexMethod:function(t){return t+1}}},r={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"box"},[a("PatientInfo",{staticClass:"patientInfo"}),t._v(" "),a("div",{staticClass:"tableBox"},[a("div",{staticClass:"title"},[t._v("记账费用")]),t._v(" "),a("el-table",{staticStyle:{width:"100%"},attrs:{data:t.jzData,"show-summary":"","header-cell-style":{backgroundColor:"#f2f2f2",color:"black"}}},[a("el-table-column",{attrs:{type:"index",index:t.indexMethod,prop:"id",label:"序号",width:"50"}}),t._v(" "),a("el-table-column",{attrs:{prop:"name",label:"分类"}}),t._v(" "),a("el-table-column",{attrs:{prop:"amount1",label:"费用(元)"}}),t._v(" "),a("el-table-column",{attrs:{index:t.indexMethod,label:"序号"}}),t._v(" "),a("el-table-column",{attrs:{prop:"name",label:"分类"}}),t._v(" "),a("el-table-column",{attrs:{prop:"amount2",label:"费用(元)"}}),t._v(" "),a("el-table-column",{attrs:{index:t.indexMethod,label:"序号"}}),t._v(" "),a("el-table-column",{attrs:{prop:"name",label:"分类"}}),t._v(" "),a("el-table-column",{attrs:{prop:"amount3",label:"费用(元)"}})],1),t._v(" "),a("div",{staticClass:"title"},[t._v("预交金信息")]),t._v(" "),a("el-table",{staticStyle:{width:"100%"},attrs:{data:t.yjjData,"show-summary":"","header-cell-style":{backgroundColor:"#f2f2f2",color:"black"}}},[a("el-table-column",{attrs:{type:"index",index:t.indexMethod,prop:"id",label:"序号",width:"50"}}),t._v(" "),a("el-table-column",{attrs:{prop:"payDate",label:"缴费日期"}}),t._v(" "),a("el-table-column",{attrs:{prop:"money",label:"费用(元)"}}),t._v(" "),a("el-table-column",{attrs:{prop:"explain",label:"说明"}}),t._v(" "),a("el-table-column",{attrs:{index:t.indexMethod,label:"序号"}}),t._v(" "),a("el-table-column",{attrs:{prop:"payDate",label:"缴费日期"}}),t._v(" "),a("el-table-column",{attrs:{prop:"money",label:"费用(元)"}}),t._v(" "),a("el-table-column",{attrs:{prop:"explain",label:"说明"}})],1),t._v(" "),a("div",{staticClass:"title"},[t._v("日清单")]),t._v(" "),a("el-table",{staticStyle:{width:"100%"},attrs:{data:t.rqdData,"header-cell-style":{backgroundColor:"#f2f2f2",color:"black"}}},[a("el-table-column",{attrs:{type:"index",index:t.indexMethod,prop:"id",label:"序号",width:"50"}}),t._v(" "),a("el-table-column",{attrs:{prop:"date",label:"发生日期"}}),t._v(" "),a("el-table-column",{attrs:{prop:"itemIndex",label:"项目序号"}}),t._v(" "),a("el-table-column",{attrs:{prop:"cost",label:"费用"}}),t._v(" "),a("el-table-column",{attrs:{prop:"item",label:"项目"}}),t._v(" "),a("el-table-column",{attrs:{prop:"rule",label:"规格"}}),t._v(" "),a("el-table-column",{attrs:{prop:"number",label:"数量"}}),t._v(" "),a("el-table-column",{attrs:{prop:"unitPrice",label:"单价"}}),t._v(" "),a("el-table-column",{attrs:{prop:"explain",label:"说明"}})],1)],1)],1)},staticRenderFns:[]};var m=a("VU/8")(i,r,!1,function(t){a("2QW9")},"data-v-07ea5b75",null);e.default=m.exports}});