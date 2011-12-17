$(document).ready(function(){
	$("#checkins").dataTable({
    	"bPaginate": false
  	});
	$('#checkins .netid').hide();
	$('#checkins tbody tr').each(function(e){
		console.log(e);
		$row = $(this);
		console.log($row);
		netid = $row.find('.netid').text();
		var name = $row.find('.first').text()+' '+$row.find('.last').text();
		$.ajax({
			url: 'http://itp.nyu.edu/~mah593/projects_db_work/serving_scripts/get_projects_venue.php?venueid=84&netid='+netid,
			dataType: 'jsonp',
			success: function(data){
				var projects = data.results;
				console.log(projects);
				$row.find('.project').empty();
				$.each(projects, function(i,v){
					$row.find('.project').append(projects[i][1]+" ");
				})
			}
		});
	});
});