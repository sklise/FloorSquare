$(document).ready(function(){
	$("#checkins").dataTable({
    	"bPaginate": false
  	});
	$('#checkins .netid').hide();
	_.each($('#checkins tbody tr'), function(e,i) {
	  $row = $(e);
		var netid = $row.find('.netid').text();
		$.ajax({
			url: 'http://itp.nyu.edu/~mah593/projects_db_work/serving_scripts/get_projects_venue.php?venueid=84&netid='+netid,
			dataType: 'jsonp',
			success: function(data){
			  console.log(data.results);
				var projects = data.results;
				console.log(i)
				$('#checkins tbody tr:eq('+i+')').find('.project').empty();
				$.each(projects, function(i,v){
  				$('#checkins tbody tr:eq('+i+')').find('.project').append(projects[i][1]+" ");
				})
			}
		});
	});
});