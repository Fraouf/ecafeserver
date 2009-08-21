function ECafe(){ }

ECafe.configurations = function() {
	
	return {
		"render_new": function() {
			$('#configuration_new').ajaxForm({
				dataType: 'json',
				success: function(data) {
					if(data.success == true) {
						jInfo(data.msg, 'Success');
					}
					else {
						jAlert(data.msg, 'Failure');
					}
				}
			});
		}
	}
}();

/*ECafe.employees = function() {
	
	return {
		"render_index": function() {
			jQuery("#employees").jqGrid({
				url: '/employees.json',
				datatype: 'json',
				colNames:['ID', 'Login', 'Password', 'Name', 'Admin'],
				colModel:[
					{name:'id', index:'id'},
					{name:'login',index:'login', editable: true},
					{name:'password', index:'password'},
					{name:'name',index:'name', editable: true},
					{name:'is_admin',index:'is_admin', formatter:'checkbox', editable: true, edittype: "checkbox"}
				],
				width: 800,
				rowNum:10,
				rowList:[10,20,30],
				pager: jQuery('#pager'),
				sortname: 'login',
				viewrecords: true,
				sortorder: "desc",
				caption:"Employees",
				editurl:"someurl.php"
			}).navGrid("#pager", {search:false});
		}
	 }
}();*/
